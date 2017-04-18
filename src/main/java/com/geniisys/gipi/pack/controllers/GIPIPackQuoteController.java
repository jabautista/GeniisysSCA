package com.geniisys.gipi.pack.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.pack.entity.GIPIPackQuote;
import com.geniisys.gipi.pack.service.GIPIPackQuoteService;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIPackQuoteController extends BaseController {

	private static final long serialVersionUID = 6177614031062280942L;
	
	private static Logger log = Logger.getLogger(GIPIPackQuoteController.class);

	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/* end of default attributes */
	
				
			/* Define services need */
			GIPIPackQuoteService gipiPackQuoteService= (GIPIPackQuoteService) APPLICATION_CONTEXT.getBean("gipiPackQuoteService"); // +env
			@SuppressWarnings("unused")
			GIISUserFacadeService userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService"); // +env
			LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			System.out.println("ACTIONl: "+ACTION);
			if("getSelectPackQuotationListing".equals(ACTION)){
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				log.info("Getting quotation listing page "+pageNo);
				String lineCd = request.getParameter("packLineCdSel") == null ?"" : request.getParameter("packLineCdSel");
				String issCd = request.getParameter("packIssCd");
				System.out.println("line cd="+lineCd);
				System.out.println("iss cd="+issCd);
				PaginatedList quoteList = gipiPackQuoteService.getQuoteListFromIssCd(lineCd,issCd, "", 1, USER.getUserId());
				quoteList.gotoPage(pageNo-1);	
				System.out.println("Number of pages: "+quoteList.getNoOfPages());
			//System.out.println("pageNo: "+pageNo);
			//System.out.println("defaultIssCd: "+issCd);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("quoteList", quoteList);
				request.setAttribute("noOfPages", quoteList.getNoOfPages());
				PAGE = "/pages/underwriting/subPages/selectPackQuotationListing.jsp";
			}else if("filterPackQuoteListing".equals(ACTION)){
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				log.info("Getting quotation listing page "+pageNo);
				String lineCd = request.getParameter("packLineCdSel") == null ?"" : request.getParameter("packLineCdSel");
				String issCd = request.getParameter("defaultIssCd");
				String keyword = request.getParameter("keyWord");
				PaginatedList quoteList = gipiPackQuoteService.getQuoteListFromIssCd(lineCd,issCd, keyword, 1, USER.getUserId());
				quoteList.gotoPage(pageNo-1);	
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("quoteList", quoteList);
				request.setAttribute("noOfPages", quoteList.getNoOfPages());
				System.out.println("Number of pages: "+quoteList.getNoOfPages());
				PAGE = "/pages/underwriting/subPages/selectPackQuotationListingTable.jsp";
			}  else if ("updateGipiPackQuote".equals(ACTION)) {
				int quoteId  = Integer.parseInt(("".equals(request.getParameter("quoteId")) || request.getParameter("quoteId") == null)? "0" : (request.getParameter("quoteId")));
				gipiPackQuoteService.updateGipiPackQuote(quoteId);
				message = "Pack Quote status updated.";
				PAGE = "/pages/genericMessage.jsp";
			}else if("returnPackParToQuotation".equals(ACTION)){
				int packQuoteId = Integer.parseInt(request.getParameter("packQuoteId"));
				int packParId = Integer.parseInt(request.getParameter("packParId"));
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packParId", packParId);
				params.put("packQuoteId", packQuoteId);
				params.put("appUser", USER.getUserId());
				System.out.println("pack par id:"+packParId);
				System.out.println("pack quote ID:"+packQuoteId);
				gipiPackQuoteService.returnPackParToQuotation(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("initialPackQuotationListing".equals(ACTION)){
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				String lineCd = request.getParameter("lineCd");
				String lineName = request.getParameter("lineName");
				System.out.println("LInecd:"+lineCd);
				System.out.println(USER.getUserId());
				request.setAttribute("lineName", lineName);
				request.setAttribute("lineCd", lineCd);
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineName", lineName);
				params.put("lineCd", lineCd);
				params.put("appUser", USER.getUserId());
				request.setAttribute("directParOpenAccess", giisParametersService.getParamValueV2("DIRECT_PAR_OPENACCESS"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				request.setAttribute("quotationFlag", 'P');
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("user", new JSONObject(USER)); // added by: Nica 08.22.2012
				
				gipiPackQuoteService.getPackQuotationListing(params);
				request.setAttribute("gipiPackQuotationListTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/marketing/quotation-pack/packQuotationTableGridListing.jsp";
			}else if ("refreshPackQuotationListing".equals(ACTION)) {
				request.getParameter("lineCd");		
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineName", request.getParameter("lineName"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("appUser", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				System.out.println(USER.getUserId());
				gipiPackQuoteService.getPackQuotationListing(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if ("createPackQuotation".equals(ACTION)) {
				String lineCd = request.getParameter("lineCd");
				String lineName = request.getParameter("lineName");
				String[] parameters =  {"", "GIIMM001A", USER.getUserId()};
				String[] params = {lineCd};
				
				List<LOV> branchSourceList = lovHelper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
				request.setAttribute("branchSourceListing", branchSourceList);
				
				List<LOV> reasonList = lovHelper.getList(LOVHelper.REASON_LISTING, params);
				request.setAttribute("reasonListing", reasonList);
				Calendar cal = Calendar.getInstance();
				request.setAttribute("proposalNo", "00");
				request.setAttribute("acceptDate", ((cal.get(Calendar.MONTH)+1)<10 ? "0" + String.valueOf((cal.get(Calendar.MONTH)+1)) : (cal.get(Calendar.MONTH)+1)) +"-"+(cal.get(Calendar.DATE) < 10 ? "0" + String.valueOf(cal.get(Calendar.DATE)) : cal.get(Calendar.DATE))+"-"+cal.get(Calendar.YEAR));
				request.setAttribute("year", cal.get(Calendar.YEAR));
//				cal.add(Calendar.MONTH, 1);
				cal.add(Calendar.DATE, 30); //change by steven 2.5.2013;it should not add by one month,instead it should add 30 days.
				request.setAttribute("validityDate", ((cal.get(Calendar.MONTH)+1)<10 ? "0"+ String.valueOf((cal.get(Calendar.MONTH)+1)) : (cal.get(Calendar.MONTH)+1)) +"-"+(cal.get(Calendar.DATE) < 10 ? "0" + String.valueOf(cal.get(Calendar.DATE)) : cal.get(Calendar.DATE))+"-"+cal.get(Calendar.YEAR));
				
				String []issParams = {USER.getUserId()};
				if (lovHelper.getList(LOVHelper.DEFAULT_ISS_SOURCE, issParams).size() > 0) {
					request.setAttribute("defaultIssSource", lovHelper.getList(LOVHelper.DEFAULT_ISS_SOURCE, issParams).get(0));
				}
				
				//System.out.println("default iss source:"+lovHelper.getList(LOVHelper.DEFAULT_ISS_SOURCE, params).get(0));
				
				if (lovHelper.getList(LOVHelper.DEFAULT_FOOTER).size() > 0) {
					request.setAttribute("footer", lovHelper.getList(LOVHelper.DEFAULT_FOOTER).get(0));
				}
				
				if (lovHelper.getList(LOVHelper.DEFAULT_PACK_HEADER).size() > 0) {
					request.setAttribute("defaultHeader", lovHelper.getList(LOVHelper.DEFAULT_PACK_HEADER).get(0));
				}
				
				/*String[] lineNames = {lineName.toLowerCase()};
				if (lovHelper.getList(LOVHelper.DEFAULT_HEADER, lineNames).size() > 0) {
					request.setAttribute("defaultHeader", lovHelper.getList(LOVHelper.DEFAULT_HEADER, lineNames).get(0));
				}*/ // replaced by: Nica 12.04.2012
				
				request.setAttribute("validityDate", ((cal.get(Calendar.MONTH)+1)<10 ? "0"+ String.valueOf((cal.get(Calendar.MONTH)+1)) : (cal.get(Calendar.MONTH)+1)) +"-"+(cal.get(Calendar.DATE) < 10 ? "0" + String.valueOf(cal.get(Calendar.DATE)) : cal.get(Calendar.DATE))+"-"+cal.get(Calendar.YEAR));
				request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.PACK_PAR_ISS_SOURCE_LISTING, parameters));
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("lineName", lineName);
				request.setAttribute("sublineListing", lovHelper.getList(LOVHelper.SUB_LINE_LISTING, params));
				request.setAttribute("ora2010Sw", gipiPackQuoteService.checkOra2010Sw());
				PAGE = "/pages/marketing/quotation-pack/createPackQuotation.jsp";
			}else if("editPackQuotation".equals(ACTION)){
				int packQuoteId = Integer.parseInt(request.getParameter("packQuoteId"));
				GIPIPackQuote gipiPackQuote = gipiPackQuoteService.getGIPIPackDetails(packQuoteId);
				System.out.println(gipiPackQuote.getPackQuoteId());
				String quotationNo = null;
				String[] parameters =  {"", "GIIMM001A", USER.getUserId()};
		        LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); //  + env

		        List<LOV> branchSourceList = lovHelper.getList(LOVHelper.BRANCH_SOURCE_LISTING); //added by steven 10/31/2012
				request.setAttribute("branchSourceListing", branchSourceList);
		        
		        quotationNo = zeroPad(String.valueOf(gipiPackQuote.getQuotationNo()), 6);
		        request.setAttribute("quotationNo", quotationNo);
		        String args[] = { gipiPackQuote.getLineCd() };
		        
		        List<LOV> sublineList = helper.getList(LOVHelper.SUB_LINE_LISTING, args);
		        request.setAttribute("sublineListing", sublineList);
		        
		        request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.PACK_PAR_ISS_SOURCE_LISTING, parameters));
		       // List<LOV> branchSourceList = helper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
		        //request.setAttribute("issourceListing", branchSourceList);

		        List<LOV> reasonList = helper.getList(LOVHelper.REASON_LISTING, args);
		        request.setAttribute("reasonListing", reasonList);
		        request.setAttribute("packQuoteId", gipiPackQuote.getPackQuoteId());
		        request.setAttribute("gipiPackQuote", StringFormatter.escapeHTMLForELInObject(gipiPackQuote)); //added by steven 10/31/2012
				request.setAttribute("editPackQuotation", "1");
				request.setAttribute("ora2010Sw", gipiPackQuoteService.checkOra2010Sw());	//added by Gzelle 12.12.2013
				PAGE = "/pages/marketing/quotation-pack/createPackQuotation.jsp";
			}else if("savePackQuotation".equals(ACTION)){
				GIPIPackQuote gipiPackQuote = gipiPackQuoteService.saveGipiPackQuote(preparePackQuotation(request, USER));
				
				//request.setAttribute("quotationNo", zeroPad(String.valueOf(gipiPackQuote.getQuotationNo()), 6));
				StringFormatter.replaceQuotesInObject(gipiPackQuote);
				JSONObject jsonGIPIPackQuote = new JSONObject(gipiPackQuote);
				//StringFormatter.replaceQuotesInObject(jsonGIPIPackQuote);
				//JSONArray jsonPackQuotations = null;
				System.out.println(jsonGIPIPackQuote );
				
				GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packQuoteId", request.getParameter("packQuoteId"));
				params.put("userId", USER.getUserId());
				List<GIPIQuote> packQuotations =  serv.getQuotationByPackQuoteId(params);
				//StringFormatter.replaceQuotesInList(packQuotations);
				System.out.println("packQuotations length: "+packQuotations.size());
				JSONArray jsonPackQuotations = new JSONArray(packQuotations);
			
				request.setAttribute("packQuoteId", gipiPackQuote.getPackQuoteId());
				request.setAttribute("assdName", gipiPackQuote.getAssdName());
				request.setAttribute("quoteNo", gipiPackQuote.getQuoteNo());
				request.setAttribute("quotationNo", gipiPackQuote.getQuotationNo());
				request.setAttribute("jsonGIPIPackQuote", jsonGIPIPackQuote);
				request.setAttribute("jsonPackQuotations", jsonPackQuotations == null ? "[]" : jsonPackQuotations);
				PAGE = "/pages/marketing/quotation-pack/subPages/packQuotationParameters.jsp";
			}else if ("setPackQuoteParameters".equals(ACTION)) {
				
				GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
				int packQuoteId = Integer.parseInt(request.getParameter("packQuoteId"));
				System.out.println("Setting pack quote parameters for: "+packQuoteId);
				GIPIPackQuote gipiPackQuote =gipiPackQuoteService.getGIPIPackDetails(packQuoteId);
				JSONObject jsonGIPIPackQuote = new JSONObject(StringFormatter.escapeHTMLInObject(gipiPackQuote));
//				StringFormatter.escapeHTMLInList((jsonGIPIPackQuote));
//				StringFormatter.escapeHTMLInObject(jsonGIPIPackQuote);
				// get pack quotations
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packQuoteId", packQuoteId);
				params.put("userId", USER.getUserId());
				List<GIPIQuote> packQuotations =  serv.getQuotationByPackQuoteId(params);
				//StringFormatter.replaceQuotesInList(packQuotations);
				System.out.println("packQuotations length: "+packQuotations.size());
				JSONArray jsonPackQuotations = new JSONArray(packQuotations);
				
				System.out.println(jsonGIPIPackQuote);
				System.out.println(jsonPackQuotations);
				request.setAttribute("jsonGIPIPackQuote", jsonGIPIPackQuote);
				request.setAttribute("assdName", gipiPackQuote.getAssdName());
				request.setAttribute("quoteNo", gipiPackQuote.getQuoteNo());
				request.setAttribute("packQuoteId", gipiPackQuote.getPackQuoteId());
				request.setAttribute("quotationNo", gipiPackQuote.getQuotationNo());
				request.setAttribute("jsonPackQuotations", jsonPackQuotations == null ? "[]" : jsonPackQuotations);
				PAGE = "/pages/marketing/quotation-pack/subPages/packQuotationParameters.jsp";
			}else if ("deletePackQuotation".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packQuoteId", request.getParameter("packQuoteId"));
				params.put("userId", USER.getUserId());
				gipiPackQuoteService.deletePackQuotation(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showReasonPage".equals(ACTION)){
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] args = { request.getParameter("lineCd") };
				List<LOV> reasonList = helper.getList(LOVHelper.REASON_LISTING, args);
				request.setAttribute("packQuoteNo", request.getParameter("packQuoteNo"));
				request.setAttribute("packQuoteId", request.getParameter("packQuoteId"));
				request.setAttribute("reasonListing", reasonList);
				PAGE = "/pages/marketing/quotation-pack/subPages/chooseReason.jsp";
			}else if ("denyPackQuotation".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packQuoteId", request.getParameter("packQuoteId"));
				params.put("reasonCd", request.getParameter("reasonCd"));
				params.put("userId", USER.getUserId());
				gipiPackQuoteService.denyPackQuotation(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("copyPackQuotation".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packQuoteId", request.getParameter("packQuoteId"));
				params.put("userId", USER.getUserId());
				String quoteNo = gipiPackQuoteService.copyPackQuotation(params);
				message = "SUCCESS,"+quoteNo;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("duplicatePackQuotation".equals(ACTION)) {
				Map<String, Object> params =new HashMap<String, Object>();
				params.put("packQuoteId", request.getParameter("packQuoteId"));
				params.put("userId", USER.getUserId());
				String quoteNo = gipiPackQuoteService.duplicatePackQuotation(params);
				message = "SUCCESS,"+quoteNo;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showPackBankRefNo".equals(ACTION)) {
				PAGE = "/pages/marketing/quotation-pack/subPages/pop-ups/searchPackBankRefNo.jsp";
			}else if ("searchPackBankRefNo".equals(ACTION)) {
				log.info("Getting Bank ref no. Listing records.");
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("nbtAcctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
				params.put("nbtBranchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
				params.put("isPack", request.getParameter("isPack") == null ? "N" : request.getParameter("isPack")); // bonok :: 09.27.2013 :: SR: 388
				params.put("keyword", keyword);
				params.put("isPack", request.getParameter("isPack") == null ? "N" : request.getParameter("isPack")); // bonok :: 09.27.2013 :: SR: 388
				log.info("Parameters: "+params);
				PaginatedList searchResult = null;
				searchResult = gipiWPolbasService.getBankRefNoList(params,pageNo);
				request.setAttribute("keyword", keyword);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				JSONArray searchResultJSON = new JSONArray(searchResult);
				request.setAttribute("searchResultJSON", searchResultJSON);
				PAGE = "/pages/marketing/quotation-pack/subPages/pop-ups/searchPackBankRefNoResult.jsp";
			}else if ("validateAcctIssCd".equals(ACTION)) {
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				log.info("Validating issue code in bank details...");
				message = gipiWPolbasService.validateAcctIssCd((request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateBranchCd".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				log.info("Validating branch code in bank details...");
				HashMap<String, String> params = new HashMap<String, String>();
				params.put("nbtAcctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
				params.put("nbtBranchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
				message = gipiWPolbasService.validateBranchCd(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("generatePackBankRefNo".equals(ACTION)) {
				log.info("Generating bank details...");
				int packQuoteId = Integer.parseInt("".equals(request.getParameter("packQuoteId")) || request.getParameter("packQuoteId") == null? "0" : request.getParameter("packQuoteId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("packQuoteId", packQuoteId);
				params.put("acctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
				params.put("branchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
				params = gipiPackQuoteService.generatePackBankRefNo(params);
				request.setAttribute("object", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/genericObject.jsp";
			}else if("getExistMsgPack".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				Integer assdNo = Integer.parseInt(request.getParameter("assdNo") == "" ? "0" : request.getParameter("assdNo"));
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("assdNo", assdNo);
				System.out.println("lineCd: "+lineCd);
				System.out.println("assdNo:"+assdNo);
				message = gipiPackQuoteService.getExistMessagePack(params);
				System.out.println("message: "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getExistingPackQuotations".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("assdNo", request.getParameter("assdNo"));
				
				params = TableGridUtil.getTableGrid(request, params);
				String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("refresh"))){
					message = grid;
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("lineCd", request.getParameter("lineCd"));
					request.setAttribute("assdNo", request.getParameter("assdNo"));
					request.setAttribute("jsonExistingPackQuotations", grid);
					PAGE = "/pages/marketing/quotation-pack/subPages/existingPackQuotationTGListing.jsp";
				}
			} 
		} catch (SQLException e) {
			message = "SQL Exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (Exception e) {
			message = "Unhandled exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
	private GIPIPackQuote preparePackQuotation(HttpServletRequest request, GIISUser user){
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		GIPIPackQuote gipiPackQuote = new GIPIPackQuote();
		String packQuoteId = request.getParameter("packQuoteId");
		
		if (null == packQuoteId || "".equalsIgnoreCase(packQuoteId)) {
			gipiPackQuote.setPackQuoteId(0);
			gipiPackQuote.setLineCd(request.getParameter("lineCd"));
			gipiPackQuote.setSublineCd(request.getParameter("subline"));
			gipiPackQuote.setIssCd(request.getParameter("issSource"));
		} else {
			gipiPackQuote.setPackQuoteId(Integer.parseInt(packQuoteId));
		}
		
		gipiPackQuote.setCredBranch(request.getParameter("creditingBranch"));
		gipiPackQuote.setQuotationNo(Integer.parseInt(request.getParameter("quotationNo") == "" ? "0" : request.getParameter("quotationNo")));
		gipiPackQuote.setQuotationYy(Integer.parseInt(request.getParameter("quotationYY")));
		gipiPackQuote.setProposalNo(Integer.parseInt(request.getParameter("proposalNo")));
		gipiPackQuote.setUserId(user.getUserId());
		gipiPackQuote.setAssdName(request.getParameter("assuredName"));
		gipiPackQuote.setAssdNo(Integer.parseInt((request.getParameter("assuredNo")== null || request.getParameter("assuredNo").equals("")) ? "0" : request.getParameter("assuredNo")));
		gipiPackQuote.setAddress1(request.getParameter("address1"));
		gipiPackQuote.setAddress2(request.getParameter("address2"));
		gipiPackQuote.setAddress3(request.getParameter("address3"));
		gipiPackQuote.setAcctOfCd(Integer.parseInt((request.getParameter("acctOfCd") == null || request.getParameter("acctOfCd").equals("")) ? "0" : request.getParameter("acctOfCd")));
		gipiPackQuote.setStatus("");
		gipiPackQuote.setUnderwriter(user.getUserId());
		gipiPackQuote.setInceptTag("".equals(request.getParameter("inceptTag")) ? "N" : request.getParameter("inceptTag"));
		gipiPackQuote.setExpiryTag("".equals(request.getParameter("expiryTag")) ? "N" : request.getParameter("expiryTag"));
		gipiPackQuote.setHeader(request.getParameter("header"));
		gipiPackQuote.setFooter(request.getParameter("footer"));
		gipiPackQuote.setRemarks(request.getParameter("remarks"));
		gipiPackQuote.setReasonCd(Integer.parseInt((request.getParameter("reason")== null || request.getParameter("reason").equals("")) ? "0" : request.getParameter("reason")));
		gipiPackQuote.setCompSw(request.getParameter("compSw"));
		gipiPackQuote.setProrateFlag(request.getParameter("prorateFlag"));
		gipiPackQuote.setAccountOfSW(Integer.parseInt(request.getParameter("accountOfSW"))); //Added by Jerome 08.18.2016 SR 5586
		
		BigDecimal shorts = new BigDecimal((request.getParameter("shortRatePercent") == null || request.getParameter("shortRatePercent").equals("")) ? "0" : request.getParameter("shortRatePercent"));
		
		// DO NOT REMOVE THE 1.0 ADDED HERE, IT WILL BE CANCELLED OUT IN THE ORACLE STATEMENT IN IBATIS
		shorts = shorts.add(new BigDecimal("1.000000000")).setScale(9, BigDecimal.ROUND_HALF_UP); 
		// ERRONEOUS DATA WILL BE ENTERED TO THE DATABASE IF THIS CODE IS DELETED 
		gipiPackQuote.setShortRatePercent(shorts);
		try {			
			gipiPackQuote.setExpiryDate(sdf.parse(request.getParameter("doe")));
			gipiPackQuote.setInceptDate(sdf.parse(request.getParameter("doi")));
			gipiPackQuote.setValidDate((request.getParameter("validDate")== null || request.getParameter("validDate").equals("")) ? null : sdf.parse(request.getParameter("validDate")));
			gipiPackQuote.setAcceptDt((request.getParameter("acceptDate")== null || request.getParameter("acceptDate").equals("")) ? null : sdf.parse(request.getParameter("acceptDate")));
		} catch (ParseException e1) {			
			e1.printStackTrace();
		}
		return gipiPackQuote;
	}
	
	private String zeroPad(String input, int padding){
		String padder = "0";
		StringBuffer bldr = new StringBuffer();
		if (input.length() < padding) {
			for (int x = 0; x < (padding - input.length()); x++){
				bldr.append(padder);
			}
			bldr.append(input);
		}
		return bldr.toString();
	}

}


