/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuotePictures;
import com.geniisys.gipi.pack.entity.GIPIWPackLineSubline;
import com.geniisys.gipi.pack.service.GIPIWPackLineSublineService;
import com.geniisys.gipi.service.GIPIInspDataService;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService;
import com.geniisys.gipi.service.GIPIQuotePicturesService;
import com.geniisys.gipi.util.FileUtil;
import com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIQuotationController.
 */
public class GIPIQuotationController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -4520241224206001129L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings( { "deprecation", "unchecked" })
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, 
			GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException { //, String env

		try {
			/* default attributes */
			log.info("Initializing: " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/* Define services need */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIISUserFacadeService userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService"); // +env
			GIPIQuoteDeductiblesFacadeService deductibleService = (GIPIQuoteDeductiblesFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteDeductiblesFacadeService"); //nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null || request.getParameter("quoteId").equals("")) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if(quoteId != 0){
				//gipiQuote = (GIPIQuote) StringFormatter.escapeHTMLInObject(serv.getQuotationDetailsByQuoteId(quoteId)); //added by steven 10/29/2012 - escapeHTMLInObject
				gipiQuote = (GIPIQuote) StringFormatter.escapeHTMLForELInObject(serv.getQuotationDetailsByQuoteId(quoteId)); // bonok :: 02.05.2013
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			if("initialQuotationListing".equals(ACTION)){

				String lineCd = request.getParameter("lineCd");
				String lineName = request.getParameter("lineName");
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("directParOpenAccess", giisParametersService.getParamValueV2("DIRECT_PAR_OPENACCESS"));			
				List<GIISUser> users = userService.getGiisUserAllList();
				request.setAttribute("users", users);
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("lineName", lineName);
				request.setAttribute("lineCd", lineCd);
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineName", lineName);
				params.put("lineCd", lineCd);
				params.put("userId", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("moduleId", "GIIMM001");
				request.setAttribute("quotationFlag", 'Q');
				serv.getGIPIQuoteListing(params);
				request.setAttribute("gipiQuotationListTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.escapeHTMLInMap(params)));  //added by steven 9/29/2012 - escapeHTMLInMap
				request.setAttribute("user", new JSONObject(USER)); // added by: Nica 08.22.2012
				PAGE = "/pages/marketing/quotation/quotationTableGridListing.jsp";
			}else if("refreshQuotationListing".equals(ACTION)){ 
				request.getParameter("lineCd");		
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineName", request.getParameter("lineName"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				params.put("moduleId", "GIIMM001");
				serv.getGIPIQuoteListing(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.escapeHTML(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("initialReassignQuotationListing".equals(ACTION)){			
				String lineCd = request.getParameter("lineCd");
				String lineName = request.getParameter("lineName");
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("directParOpenAccess", giisParametersService.getParamValueV2("DIRECT_PAR_OPENACCESS"));			
				List<GIISUser> users = userService.getGiisUserAllList();
				request.setAttribute("users", users);
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("misSw", USER.getMisSw());
				request.setAttribute("mgrSw", USER.getMgrSw());
				request.setAttribute("lineName", lineName);
				request.setAttribute("lineCd", lineCd);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineName", lineName);
				params.put("lineCd", lineCd);
				params.put("userId", USER.getUserId());
				params.put("moduleId", "GIIMM013");
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				request.setAttribute("quotationFlag", 'Q');
				//serv.getGIPIQuoteListing(params); replaced by: Nica 12.13.2012
				serv.getReassignQuoteListing(params);
				request.setAttribute("gipiQuotationListTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/marketing/quotation/reassignQuotationTableGridListing.jsp";	
			}else if("refreshReassignQuotationListing".equals(ACTION)){ 
				request.getParameter("lineCd");		
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineName", request.getParameter("lineName"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId());
				params.put("moduleId", "GIIMM013");
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				//serv.getGIPIQuoteListing(params); replaced by: Nica 12.13.2012
				serv.getReassignQuoteListing(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";	
			
			}else if ("getQuotationListing".equals(ACTION)){
				request.getAttribute("lineName");
				request.getAttribute("lineCd");
				request.getAttribute("USER");
				request.setAttribute("lineCd",	request.getParameter("lineCd"));
				request.setAttribute("USER",	request.getParameter("USER"));
				PAGE = "/pages/marketing/quotationListing.jsp";
			}else if("getQuotationListingByUserIdByLineCd".equals(ACTION)){
				String lineCd 	= (String) request.getParameter("lineCd");
				String lineName	= (String) request.getParameter("lineName");
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("lineName", lineName);
				log.info("Getting quotation listing of User " + USER.getUserId() + " for " + lineCd + "-" + lineName);
				
				int pageNo = Integer.parseInt((request.getParameter("pageNo") == "" || request.getParameter("pageNo") == null) ? "0" : request.getParameter("pageNo"));
				PaginatedList searchResult = serv.getQuotationListing(USER.getUserId(), lineCd);
				searchResult.gotoPage(pageNo-1);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("gipiQuoteList", searchResult);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				request.setAttribute("currentUser", USER.getUsername());
				
				PAGE = "/pages/marketing/quotation/subPages/quotationListingTable.jsp";

			} else if ("getFilterQuoteListing".equals(ACTION)) { // ACTION TO BE REPLACED BY TABLEGRID
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("quoteYy", request.getParameter("quoteYear"));
				params.put("quoteNo", request.getParameter("quoteNo"));
				params.put("propSeqNo", request.getParameter("propSeqNo"));
				params.put("assdName", request.getParameter("assdName"));
				params.put("module", request.getParameter("module"));
				params.put("allUserSwitch", USER.getAllUserSw()); // added by Irwin march 2, 2011
				params.put("userId", USER.getUserId());// added by Irwin march 2, 2011
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				
				int pageNo = Integer.parseInt(("".equals(request.getParameter("pageNo")) || request.getParameter("pageNo") == null) ? "0" : request.getParameter("pageNo"));
				PaginatedList searchResult = serv.getFilterQuoteListing(params);
				searchResult.gotoPage(pageNo-1);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("gipiQuoteList", searchResult);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				request.setAttribute("currentUser", USER.getUserId());
				request.setAttribute("directParOpenAccess", giisParametersService.getParamValueV2("DIRECT_PAR_OPENACCESS")); // added by irwin. march 3,2011 Validation for editing quotation created by a different user
				request.setAttribute("userId", USER.getUserId()); // sets the user id for security
				
				PAGE = "/pages/marketing/quotation/subPages/quotationListingTable.jsp";
			//***************************************************************************	
			} else if ("createQuotation".equals(ACTION)) {
				
				log.info("Creating quotation form...");
				String lineCd = request.getParameter("lineCd");
				String lineName = request.getParameter("lineName");
				System.out.println("lineCd:"+lineCd);
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // + env
				String[] args = { lineCd };
				
				List<LOV> sublineList = helper.getList(LOVHelper.SUB_LINE_LISTING, args);
				request.setAttribute("sublineListing", sublineList);
				
				List<LOV> branchSourceList = helper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
				request.setAttribute("branchSourceListing", branchSourceList);
				
				//emsy09042012 
				String[] parameters = {lineCd, "GIIMM001", USER.getUserId() };
				List<LOV> issSourceList = helper.getList(LOVHelper.ISSUING_SOURCE_LISTING, parameters);
				request.setAttribute("issSourceListing", issSourceList);
				//emsy09042012
				
				List<LOV> reasonList = helper.getList(LOVHelper.REASON_LISTING, args);
				request.setAttribute("reasonListing", reasonList);
				
				String[] params = {USER.getUserId()};
				Calendar cal = Calendar.getInstance();
				if (helper.getList(LOVHelper.DEFAULT_FOOTER).size() > 0) {
					request.setAttribute("footer", helper.getList(LOVHelper.DEFAULT_FOOTER).get(0));
				}
				String[] lineNames = {lineName.toLowerCase()};
				if (helper.getList(LOVHelper.DEFAULT_HEADER, lineNames).size() > 0) {
					request.setAttribute("defaultHeader", helper.getList(LOVHelper.DEFAULT_HEADER, lineNames).get(0));
				}
				request.setAttribute("proposalNo", "000");
				request.setAttribute("acceptDate", ((cal.get(Calendar.MONTH)+1)<10 ? "0" + String.valueOf((cal.get(Calendar.MONTH)+1)) : (cal.get(Calendar.MONTH)+1)) +"-"+(cal.get(Calendar.DATE) < 10 ? "0" + String.valueOf(cal.get(Calendar.DATE)) : cal.get(Calendar.DATE))+"-"+cal.get(Calendar.YEAR));
				request.setAttribute("year", cal.get(Calendar.YEAR));
//				cal.add(Calendar.MONTH, 1);
				cal.add(Calendar.DATE, 30); //change by steven 2.5.2013;it should not add by one month,instead it should add 30 days.
				request.setAttribute("validityDate", ((cal.get(Calendar.MONTH)+1)<10 ? "0"+ String.valueOf((cal.get(Calendar.MONTH)+1)) : (cal.get(Calendar.MONTH)+1)) +"-"+(cal.get(Calendar.DATE) < 10 ? "0" + String.valueOf(cal.get(Calendar.DATE)) : cal.get(Calendar.DATE))+"-"+cal.get(Calendar.YEAR));
				
				if (helper.getList(LOVHelper.DEFAULT_ISS_SOURCE, params).size() > 0) {
					request.setAttribute("defaultIssSource", helper.getList(LOVHelper.DEFAULT_ISS_SOURCE, params).get(0));
				}
				
				request.setAttribute("lineName", lineName);
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("userId", USER.getUserId());
				// added for select inspection - irwin 5.16.11
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("vSelInsp", giisParametersService.getParamValueV2("CONVERT_INSPECTION"));
					
				
				//emsy09072012
				GIISISSourceFacadeService issServ = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				String riSwitch = request.getParameter("riSwitch");
				request.setAttribute("defaultIssCd", issServ.getDefaultIssCd(riSwitch, USER.getUserId()));
				//emsy09072012
				
				//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
				Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("ACTION", "getAllGIPIQuoteDeduct");
				params2.put("quoteId", null);
				
				Map<String, Object> tbgQuotationDeductible = TableGridUtil.getTableGrid(request, params2);
				
				JSONObject json = new JSONObject(tbgQuotationDeductible);
				request.setAttribute("tbgQuotationDeductible", json);
				//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles end
				
				request.setAttribute("requireRefNo", giisParametersService.getParamValueV2("REQUIRE_REF_NO")); //Added by Jerome 12.12.2016 SR 5746
				
				log.info("Redirecting to quotation page...");
				PAGE = "/pages/marketing/quotation/createQuotation.jsp";
	
			} else if ("editQuotation".equals(ACTION)) {
				System.out.println("ante>>>   editController");
				System.out.println(gipiQuote.getBankRefNo());
				// added for select inspection - irwin 5.16.11
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("vSelInsp", giisParametersService.getParamValueV2("CONVERT_INSPECTION"));
				request.setAttribute("requireRefNo", giisParametersService.getParamValueV2("REQUIRE_REF_NO")); //Added by Jerome 12.12.2016 SR 5746
				request = prepareQuotationForEditing(request, gipiQuote); // , env
				request.setAttribute("src", request.getParameter("src"));
				request.setAttribute("editQuotation", "1");
	
				if (gipiQuote.getLineCd().equals("FI")) {
					request.setAttribute("quoteItemExist", serv.checkIfGIPIQuoteItemExsist(gipiQuote.getQuoteId()));
					request.setAttribute("inspExists", serv.checkIfInspExists(gipiQuote.getAssdNo()));
				}
				
				//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getAllGIPIQuoteDeduct");
				params.put("quoteId", request.getParameter("quoteId"));
				
				Map<String, Object> tbgQuotationDeductible = TableGridUtil.getTableGrid(request, params);
				
				Integer quoteId1 = Integer.parseInt((String)request.getParameter("quoteId"));
				
				List<LOV> quotePerilsList = deductibleService.getQuotePerilList(quoteId1);
				request.setAttribute("dedPerilsList", quotePerilsList);
				JSONObject json = new JSONObject(tbgQuotationDeductible);
				request.setAttribute("tbgQuotationDeductible", json);
				//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles end
				
	            PAGE = "/pages/marketing/quotation/createQuotation.jsp";
	
			} else if ("saveQuotation".equals(ACTION)) {
				log.info("Saving quotation...");
				gipiQuote = new GIPIQuote();
				int quotationNo = 0;
				gipiQuote = createQuote(request, USER);
				gipiQuote.setAccountOfSW(Integer.parseInt(request.getParameter("accountOfSW"))); //Added by Jerome 08.18.2016 SR 5586
				quoteId = serv.saveGIPIQuoteDetails(gipiQuote);
				quotationNo = serv.getQuotationDetailsByQuoteId(quoteId).getQuotationNo();
				String issCd = serv.getQuotationDetailsByQuoteId(quoteId).getIssCd();
				message = "SUCCESS";
				request.setAttribute("quotationNo", zeroPad(String.valueOf(quotationNo), 6));
				request.setAttribute("quoteId", quoteId);
				request.setAttribute("isscd", gipiQuote.getIssCd());
				request.setAttribute("inspExists", serv.checkIfInspExists(gipiQuote.getAssdNo()));
				//for mortgagee
				String mortTag = request.getParameter("saveMortTag")== null ? "Y" : request.getParameter("saveMortTag");
				System.out.println(mortTag);
				if(mortTag != null){
					if(mortTag.equals("Y")){
						GIPIQuoteMortgageeFacadeService mortgPackageFacadeService = (GIPIQuoteMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteMortgageeFacadeService"); // + env
						
						Map<String, Object> params = new HashMap<String, Object>();
						GIPIQuote gipiQuote2 = null;
						gipiQuote2 = serv.getQuotationDetailsByQuoteId(quoteId);	
						params.put("gipiQuote", gipiQuote2);
						
						String[] mortgCds = request.getParameterValues("mortgCds");
						String[] amounts = request.getParameterValues("amounts");
						String[] itemNos = request.getParameterValues("mortgageeItemNos");
						String qLevel = "Y";
						
						params.put("issCd", issCd);
						params.put("mortgCds", mortgCds);
						params.put("amounts", amounts);
						params.put("itemNos", itemNos);
						params.put("userId", USER.getUserId());
						params.put("quoteId", quoteId);
						params.put("qLevel", qLevel);
						mortgPackageFacadeService.saveGIPIQuoteMortgagee(params);

						PAGE = "/pages/marketing/quotation/quoteIdMessagePage.jsp";
					}
				}
				deductibleService.saveGIPIQuoteDeductibles2(request, USER.getUserId()); //nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
				
				message = "SUCCESS";	
				PAGE = "/pages/marketing/quotation/quoteIdMessagePage.jsp";
				
			}else if ("copyQuotation".equals(ACTION)) {
				//int quotationNo = 0;
				/*gipiQuote.setUnderwriter(USER.getUserId());
				quoteId = serv.copyQuotation(gipiQuote);
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
			    message = "SUCCESS"+","+serv.getQuotationDetailsByQuoteId(quoteId).getQuoteNo();
				PAGE = "/pages/genericMessage.jsp";*/ //replaced by Nica 04.18.2012
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", quoteId);
				params.put("userId", USER.getUserId());
				
				Integer newQuoteId = serv.copyQuotation2(params);
				gipiQuote = serv.getQuotationDetailsByQuoteId(newQuoteId);
				gipiQuote.setQuoteId(newQuoteId);				
				message = "SUCCESS"+","+serv.getQuotationDetailsByQuoteId(newQuoteId).getQuoteNo();
				PAGE = "/pages/genericMessage.jsp";
	            
	            /* Previous setup
	            request = prepareQuotationForEditing(request, gipiQuote); // , env
				request.setAttribute("editQuotation", "1");
	            PAGE = "/pages/marketing/quotation/createQuotation.jsp";
				*/
			} else if ("duplicateQuotation".equals(ACTION)) {
				/*gipiQuote.setUnderwriter(USER.getUserId());
				quoteId = serv.duplicateQuotation(gipiQuote);
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);				
				message = "SUCCESS"+","+serv.getQuotationDetailsByQuoteId(quoteId).getQuoteNo();
				PAGE = "/pages/genericMessage.jsp";*/ //replaced by Nica 04.18.2012
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", quoteId);
				params.put("userId", USER.getUserId());
				
				Integer newQuoteId = serv.duplicateQuotation2(params);
				gipiQuote = serv.getQuotationDetailsByQuoteId(newQuoteId);
				gipiQuote.setQuoteId(newQuoteId);				
				message = "SUCCESS"+","+serv.getQuotationDetailsByQuoteId(newQuoteId).getQuoteNo();
				PAGE = "/pages/genericMessage.jsp";
				
				/*previous setup
				 * request = prepareQuotationForEditing(request, gipiQuote); // , env
				request.setAttribute("editQuotation", "1");
	            PAGE = "/pages/marketing/quotation/createQuotation.jsp";*/
				
			} else if ("deleteQuotation".equals(ACTION)) {
				//serv.deleteQuotation(gipiQuote.getQuoteId());
				Map<String, Object> params = new HashMap<String, Object>(); //added by robert
				params.put("quoteId", quoteId);
				params.put("userId", USER.getUserId());
				
				GIPIQuotePicturesService gipiQuotePicturesService = (GIPIQuotePicturesService) APPLICATION_CONTEXT.getBean("gipiQuotePicturesService");
				List<GIPIQuotePictures> attachments = gipiQuotePicturesService.getAllGIPIQuotePictures(quoteId);
				List<String> files = new ArrayList<String>();
				
				serv.deleteQuotation2(params);
				
				for (GIPIQuotePictures attachment : attachments) {
					files.add(attachment.getFileName());
				}
				FileUtil.deleteFiles(files); // SR-21674 JET JAN-31-2017
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("denyQuotation".equals(ACTION)) {
				quoteId = Integer.parseInt(request.getParameter("quoteId"));
				Integer reasonCd = Integer.parseInt(request.getParameter("reasonCd"));
				serv.updateReasonCd(quoteId, reasonCd);
				serv.denyQuotation(gipiQuote.getQuoteId());
				message = "SUCCESS"; 
				PAGE = "/pages/genericMessage.jsp";
			}else if ("reassignQuotation".equals(ACTION)) {
				String userId = request.getParameter("rqUserId");
				serv.reassignQuotation(userId, quoteId);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("viewQuotationStatus".equals(ACTION)) {
				PAGE = "/pages/marketing/quotation/inquiry/viewQuotationStatusListing.jsp";
			}else if ("viewQuotationStatusListing".equals(ACTION)){ //Rey
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				
				Map<String, Object> par = new HashMap<String, Object>();
				par.put("request", request);
				par.put("USER", USER);
				par.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				par = serv.getGIPIQuoteList(par);
				request.setAttribute("gipiQuotationStatus", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(par)));
				PAGE = "/pages/marketing/quotation/inquiry/viewQuotationStatusTableGridListing.jsp";
			}else if("refreshQuotationListing2".equals(ACTION)){  //Rey
				String lineCd = request.getParameter("lineCd");
				request.setAttribute("lineCd", lineCd);
				
				Map<String, Object> par=new HashMap<String, Object>();
				par.put("request",request);
				par.put("USER",USER);
				par.put("lineCd",lineCd);
				par.put("moduleId", request.getParameter("moduleId"));
				par.put("filter", request.getParameter("objFilter"));
				par.put("sortColumn", request.getParameter("sortColumn"));
				par.put("ascDescFlg", request.getParameter("ascDescFlg"));
				par.put("currentPage",request.getParameter("page")==null? 1: Integer.parseInt(request.getParameter("page")));
				par = serv.getGIPIQuoteList(par);				
				request.setAttribute("gipiQuotationStatus",new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(par)));
				JSONObject json = new JSONObject(par);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if ("viewQuotationListingForQuotationStatus".equals(ACTION)) {
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				String keyword = request.getParameter("keyword");
				Map<String, Object> params = new HashMap<String, Object>();
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				
				String fromDate = request.getParameter("from");
				Date dateFrom = null;
				if (!"".equals(fromDate) && null != fromDate) {
					dateFrom = df.parse(fromDate);
				}
				
				String toDate = request.getParameter("to");
				Date dateTo = null;
				if (!"".equals(toDate) && null != toDate) {
					dateTo = df.parse(toDate);
				}
				
				params.put("dateFrom", dateFrom);
				params.put("dateTo", dateTo);
				params.put("status", request.getParameter("status"));
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("module"));
				params.put("keyword", keyword);
				
			/*	Map<String, Object> par = new HashMap<String, Object>();
				par.put("request", request);
				par.put("USER", USER);*/

				PaginatedList searchResult = serv.getQuoteListStatus(params);
				searchResult.gotoPage(pageNo-1);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("quotationStatus", searchResult);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/marketing/quotation/inquiry/viewQuotationStatusListingTable.jsp";
			} else if ("getSelectQuotationListingTable".equals(ACTION)){
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				log.info("Getting quoatation listing page "+pageNo);
				String issCd = request.getParameter("vissCd");
				String lineCd = request.getParameter("vlineCd");
				PaginatedList quoteList = serv.getQuoteListFromIssCd(issCd, lineCd, "", USER.getUserId(), 1);
				quoteList.gotoPage(pageNo-1);	
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("quoteList", quoteList);
				request.setAttribute("noOfPages", quoteList.getNoOfPages());
				PAGE = "/pages/underwriting/subPages/selectQuotationListing.jsp";
			} else if ("filterQuoteListing".equals(ACTION)) {
				log.info("filtering quotations...");
				String issCd = request.getParameter("vissCd");
				String lineCd = request.getParameter("vlineCd");
				String keyword = request.getParameter("keyWord");
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				PaginatedList quoteList = serv.getQuoteListFromIssCd(issCd, lineCd, keyword, USER.getUserId(), pageNo);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("quoteList", quoteList);
				request.setAttribute("noOfPages", quoteList.getNoOfPages());
				PAGE = "/pages/underwriting/subPages/selectQuotationListingTable.jsp";
			} else if ("saveQuoteToParUpdates".equals(ACTION)){
				log.info("Updating quote details...");
				quoteId = Integer.parseInt(request.getParameter("selectedQuoteId"));
				Integer assdNo = Integer.parseInt(request.getParameter("selectedAssdNo"));
				String issCd = request.getParameter("selectedIssCd");
				String lineCd = request.getParameter("selectedLineCd");
				serv.saveQuoteToParUpdates(quoteId, assdNo, lineCd, issCd);
				log.info("Saving is successful.");
				message = "SAVING SUCCESSFUL.";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("returnToQuotation".equals(ACTION)){
				log.info("Getting quote details...");
				quoteId = Integer.parseInt(request.getParameter("globalQuoteId"));
				GIPIQuote quote = serv.getQuotationDetailsByQuoteId(quoteId);
				int quotationYy = quote.getQuotationYy();
				int quotationNo = quote.getQuotationNo();
				String sublineCd = quote.getSublineCd();
				String lineCd = (request.getParameter("globalLineCd"));
				String issCd = (request.getParameter("globalIssCd"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quotationYy", quotationYy);
				params.put("quotationNo", quotationNo);
				params.put("sublineCd", sublineCd);
				params.put("status", "N");
				params.put("lineCd", lineCd);
				params.put("issCd", issCd);
				serv.updateStatus(params);
				message = "Updating quotation successful.";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showReasons".equals(ACTION)){
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] args = { request.getParameter("lineCd") };
				List<LOV> reasonList = helper.getList(LOVHelper.REASON_LISTING, args);
				String quotationId = request.getParameter("quoteId");
				String quoteNo = request.getParameter("quoteNo");
				request.setAttribute("quoteNo", quoteNo);
				request.setAttribute("quoteId", quotationId);
				request.setAttribute("reasonListing", reasonList);
				PAGE = "/pages/marketing/quotation/pop-ups/chooseReason.jsp";
			} else if ("updateReasonCd".equals(ACTION)){
				quoteId = Integer.parseInt(request.getParameter("quotationId"));
				Integer reasonCd = Integer.parseInt(request.getParameter("reasonCd"));
				serv.updateReasonCd(quoteId, reasonCd);
				message = "SUCCESS";
			} else if ("getExistMessage".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				Integer assdNo = Integer.parseInt(request.getParameter("assdNo") == "" ? "0" : request.getParameter("assdNo"));
				String assdName = request.getParameter("assdName").replaceAll("�", ""); // workaround for SR # 12212
				System.out.println("lineCd: "+lineCd);
				System.out.println("assdNo:"+assdNo);
				message = serv.getExistMessage(lineCd, assdNo, assdName, String.valueOf(quoteId));
				System.out.println("message: "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getExistingQuotesPolsListing".equals(ACTION)){
				/*String lineCd = request.getParameter("lineCd");
				Integer assdNo = (!request.getParameter("assdNo").equals("") && request.getParameter("assdNo") != null ? Integer.parseInt(request.getParameter("assdNo")) : null);
				String assdName = request.getParameter("assdName");
				Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				HashMap<String, Object> grid = new HashMap<String, Object>();
				grid.put("currentPage", page);
				grid.put("lineCd", lineCd);
				grid.put("assdNo", assdNo);
				grid.put("assdName", assdName);
				grid = (HashMap<String, Object>) serv.getExistingQuotesPolsListing(grid);*/
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("assdName", request.getParameter("assdName"));
				params.put("vExist2", request.getParameter("vExist2"));
				log.info("vExist2: "+request.getParameter("vExist2"));
				params = TableGridUtil.getTableGrid(request, params);
				String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				
				if("1".equals(request.getParameter("refresh"))){
					message = grid;
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("lineCd", request.getParameter("lineCd"));
					request.setAttribute("assdNo", request.getParameter("assdNo"));
					request.setAttribute("vExist2", request.getParameter("vExist2"));
					request.setAttribute("assdName", StringFormatter.escapeHTML(request.getParameter("assdName"))); //added steven 11/6/2012
					request.setAttribute("existingQuotesAndPoliciesTableGrid", grid);
					PAGE = "/pages/marketing/quotation/pop-ups/existingQuotationAndPolicyTG.jsp";
				}
				
			}else if("checkAssdName".equals(ACTION)){ // ADDED BY IRWIN, MARCH 3, 2011
				
				System.out.println("assdName: "+request.getParameter("assdName"));
				Map<String, Object> result = serv.checkAssdName(request);
				
				/*String assdNo = (String)(result.get("assdNo") == null? "": result.get("assdNo"));
				String address1 = (String) (result.get("address1") == null ? "" : result.get("address1"));
				String address2= (String) (result.get("address2") == null ? "" : result.get("address2"));
				String address3 = (String) (result.get("address3") == null ? "" : result.get("address3"));
				message = "SUCCESS,"+assdNo+","+address1+","+address2+","+address3;*/ //changed. Irwin - 5.22.2012
				//message = QueryParamGenerator.generateQueryParams(result);
				message = new JSONObject(StringFormatter.escapeHTMLInMap(result)).toString(); //edited. d.alcantara, 8.24.2012
				System.out.println("Test checkAssdName result2: "+message);
				//System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("reassignQuotation2".equals(ACTION)){
				System.out.println("updatedRows at gipiQuotationController: " + request.getParameter("updatedRows"));
				serv.reassignQuoatation2(request.getParameter("updatedRows"));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";		
			}else if ("showPackLineSubline".equals(ACTION)) {
				GIPIWPackLineSublineService gipiwPackLineSublineService = (GIPIWPackLineSublineService) APPLICATION_CONTEXT.getBean("gipiwPackLineSublineService");
				String lineCd = request.getParameter("lineCd");
				Integer packQuoteId = Integer.parseInt(request.getParameter("packQuoteId"));
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packQuoteId", packQuoteId);
				params.put("userId", request.getParameter("userId")); //changed the parameter from  USER.getUserId() to request.getParameter("userId"); - irwin. 10.12.11
				
				Calendar cal = Calendar.getInstance();
				request.setAttribute("year", cal.get(Calendar.YEAR));
				
				List<GIPIWPackLineSubline> lineSubline = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackLineSublineList(lineCd));
				List<GIPIQuote> packQuotations =  serv.getQuotationByPackQuoteId(params);
				JSONArray jsonPackQuotations = new JSONArray(packQuotations);
				for(int i = 0; i<jsonPackQuotations.length(); i++){
					System.out.println("here1:"+jsonPackQuotations.getJSONObject(i).getString("lineCd"));
				}
				
				for(GIPIQuote packQuotation: packQuotations){
					System.out.println("here:" +packQuotation.getLineCd());
				}
				
//				request.setAttribute("jsonPackQuotations", jsonPackQuotations);
				request.setAttribute("objLineSubline", new JSONArray(lineSubline));
//				PAGE = "/pages/marketing/quotation-pack/subPages/packQuotationLineSubline.jsp";
				JSONObject json = serv.getQuotationByPackQuoteIdJson(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonPackQuotations", json);
					PAGE = "/pages/marketing/quotation-pack/subPages/packQuotationLineSublineTG.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("getPackLineSublineTG".equals(ACTION)) {
				JSONObject json = serv.getQuotationByPackQuoteIdJson(request, USER.getUserId());
				System.out.println(json.toString());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("savePackLineSubline".equals(ACTION)) {
				Integer packQuoteId = Integer.parseInt(request.getParameter("packQuoteId"));
				System.out.println("packQuoteId="+packQuoteId);
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("parameter", request.getParameter("parameter"));
				params.put("packQuoteId", packQuoteId);
				System.out.println(request.getParameter("parameter"));
				serv.savePackLineSubline(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showInspectionList".equals(ACTION)) {
				GIPIInspDataService inspDataService = (GIPIInspDataService) APPLICATION_CONTEXT.getBean("gipiInspDataService");
				Integer assdNo = Integer.parseInt(request.getParameter("assdNo") == "" ? "0": request.getParameter("assdNo"));
				HashMap<String, Object> inspListGrid = new HashMap<String, Object>(); 
				inspListGrid.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				inspListGrid.put("assdNo", assdNo);
				inspListGrid = inspDataService.getQuoteInpsList(inspListGrid);
				request.setAttribute("gipiInspListTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(inspListGrid)));
				request.setAttribute("quoteId", request.getParameter("quoteId"));
				PAGE= "/pages/marketing/quotation/pop-ups/inspectionList.jsp";
			}else if ("refreshInspectionList".equals(ACTION)) {
				GIPIInspDataService inspDataService = (GIPIInspDataService) APPLICATION_CONTEXT.getBean("gipiInspDataService");
				Integer assdNo = Integer.parseInt(request.getParameter("assdNo") == "" ? "0": request.getParameter("assdNo"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("assdNo", assdNo);
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				params = inspDataService.getQuoteInpsList(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveQuoteInspectionDetails".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("appUser", USER.getUserId());
				params.put("quoteId", request.getParameter("quoteId"));
				params.put("inspNo", request.getParameter("inspNo"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("itemDesc", request.getParameter("itemDesc"));
				params.put("blockNo", request.getParameter("blockNo"));
				params.put("districtNo", request.getParameter("districtNo"));
				params.put("locRisk1", request.getParameter("locRisk1"));
				params.put("locRisk2", request.getParameter("locRisk2"));
				params.put("locRisk3", request.getParameter("locRisk3"));
				serv.saveQuoteInspectionDetails(params);
				message= "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("generateQuoteBankRefNo".equals(ACTION)) {
				log.info("Generating bank details...");
				int quoteId1 = Integer.parseInt("".equals(request.getParameter("quoteId")) || request.getParameter("quoteId") == null? "0" : request.getParameter("quoteId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", quoteId1);
				params.put("acctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
				params.put("branchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
				params = serv.generateQuoteBankRefNo(params);
				request.setAttribute("object", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/genericObject.jsp";
			}else if("saveQuoteInspectionDetails2".equals(ACTION)){
				message = serv.saveQuoteInspectionDetails2(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("copyAttachments".equals(ACTION)) {
				GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("quoteId", request.getParameter("quoteId"));
				params.put("quoteNo", request.getParameter("quoteNoDisp"));
				params.put("inspNo", request.getParameter("inspNo"));
				params.put("mediaPathMK", giisParameterFacadeService.getParamValueV2("MEDIA_PATH_MK"));
				params.put("mediaPathINSP", giisParameterFacadeService.getParamValueV2("MEDIA_PATH_INSP"));
				message = serv.copyAttachments(params);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

	/**
	 * Creates the quote.
	 * 
	 * @param request the request
	 * @param USER the uSER
	 * @return the gIPI quote
	 */
	public GIPIQuote createQuote(HttpServletRequest request, GIISUser USER) {
		log.info("Parsing request params to GIPIQuote...");
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");

		GIPIQuote gipiQuote = new GIPIQuote();
		String quoteId = request.getParameter("quoteId");
		if (null == quoteId || "".equalsIgnoreCase(quoteId)) {
			gipiQuote.setQuoteId(0);
			log.info("Generating New Quotation Id...");
		} else {
			gipiQuote.setQuoteId(Integer.parseInt(quoteId));
			log.info("Updating Quotation with quoteId:" + quoteId);
		}
		
		//gipiQuote.setUserId(request.getParameter("userId"));
		gipiQuote.setLineCd(request.getParameter("lineName"));
		gipiQuote.setSublineCd(request.getParameter("sublineCd"));
		gipiQuote.setSublineName(request.getParameter("sublineName")); // Nica 07.18.2012
		gipiQuote.setIssCd(request.getParameter("issSource"));
		gipiQuote.setIssName(request.getParameter("issName"));
		//emsy09102012
		gipiQuote.setCredBranch(request.getParameter("creditingBranch"));
		gipiQuote.setQuotationNo(Integer.parseInt(request.getParameter("quotationNo") == "" ? "0" : request.getParameter("quotationNo")));
		gipiQuote.setQuotationYy(Integer.parseInt(request.getParameter("quotationYY")));
		gipiQuote.setProposalNo(Integer.parseInt(request.getParameter("proposalNo")));
		gipiQuote.setUserId(USER.getUserId());
		gipiQuote.setAssdName(request.getParameter("assuredName"));
		//gipiQuote.setAssdNo(Integer.parseInt((request.getParameter("assuredNo")== null || request.getParameter("assuredNo").equals("")) ? "0" : request.getParameter("assuredNo"))); // andrew - 05.18.2011 - assdNo should be null when there is no assured entered
		if(request.getParameter("assuredNo") != null && !request.getParameter("assuredNo").equals("")){
			gipiQuote.setAssdNo(Integer.parseInt(request.getParameter("assuredNo")));
		}
		gipiQuote.setAddress1(request.getParameter("address1"));
		gipiQuote.setAddress2(request.getParameter("address2"));
		gipiQuote.setAddress3(request.getParameter("address3"));
		if(request.getParameter("acctOfCd") != null && !request.getParameter("acctOfCd").equals("")){
			gipiQuote.setAcctOfCd(Integer.parseInt(request.getParameter("acctOfCd")));
		}
		gipiQuote.setStatus("");
		gipiQuote.setUnderwriter(request.getParameter("userId"));
		gipiQuote.setInceptTag("".equals(request.getParameter("inceptTag")) ? "N" : request.getParameter("inceptTag"));
		gipiQuote.setExpiryTag("".equals(request.getParameter("expiryTag")) ? "N" : request.getParameter("expiryTag"));
		gipiQuote.setHeader(request.getParameter("header"));
		gipiQuote.setFooter(request.getParameter("footer"));
		gipiQuote.setRemarks(request.getParameter("remarks"));
		gipiQuote.setReasonCd(Integer.parseInt((request.getParameter("reason")== null || request.getParameter("reason").equals("")) ? "0" : request.getParameter("reason")));
		gipiQuote.setCompSw(request.getParameter("compSw"));
		gipiQuote.setProrateFlag(request.getParameter("prorateFlag"));
		gipiQuote.setBankRefNo(request.getParameter("bankRefNo"));
		
		BigDecimal shorts = new BigDecimal((request.getParameter("shortRatePercent") == null || request.getParameter("shortRatePercent").equals("")) ? "0" : request.getParameter("shortRatePercent"));
		
		// DO NOT REMOVE THE 1.0 ADDED HERE, IT WILL BE CANCELLED OUT IN THE ORACLE STATEMENT IN IBATIS
		shorts = shorts.add(new BigDecimal("1.000000000")).setScale(9, BigDecimal.ROUND_HALF_UP); 
		// ERRONEOUS DATA WILL BE ENTERED TO THE DATABASE IF THIS CODE IS DELETED 
		
		gipiQuote.setShortRatePercent(shorts);
		log.info("SHORT RATE PERCENT: " + gipiQuote.getShortRatePercent());

		/*
		 * to set additional attributes...
		 * gipiQuote.setAcctOfCdSw(null); gipiQuote.setAnnPremAmt(null); gipiQuote.setAnnTsiAmt(null); gipiQuote.setCompSw(null);
		 * gipiQuote.setCpiBranchCd(null); gipiQuote.setInspNo(0); gipiQuote.setOrigin(null); gipiQuote.setPackPolFlag(null);
		 * gipiQuote.setPackQuoteId(0); gipiQuote.setPremAmt(null); gipiQuote.setPrintTag(null); gipiQuote.setProrateFlag(null);
		 * gipiQuote.setShortRtPercent(null); gipiQuote.setTsiAmt(null); gipiQuote.setWithTariffSw(null);
		 */
		try {			
			gipiQuote.setExpiryDate(sdf.parse(request.getParameter("doe")));
			gipiQuote.setInceptDate(sdf.parse(request.getParameter("doi")));
			//gipiQuote.setLastUpdate(new Date());
			//gipiQuote.setLastUpdate(sdfWithTime.parse(DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.MEDIUM).format(new Date())));
			//gipiQuote.setLastUpdate(null);
			gipiQuote.setValidDate((request.getParameter("validDate")== null || request.getParameter("validDate").equals("")) ? null : sdf.parse(request.getParameter("validDate")));
			gipiQuote.setAcceptDt((request.getParameter("acceptDate")== null || request.getParameter("acceptDate").equals("")) ? null : sdf.parse(request.getParameter("acceptDate")));
			/*String validDate = request.getParameter("validDate");
			if (NullChecker.ifNullOrBlank(validDate) == true) {
				gipiQuote.setValidDate(null);
			} else {
				gipiQuote.setValidDate(sdf.parse(validDate));
			}
			String acceptDate = request.getParameter("acceptDate");
			if (NullChecker.ifNullOrBlank(acceptDate) == true) {
				gipiQuote.setAcceptDt(null);
			} else {
				gipiQuote.setAcceptDt(sdf.parse(acceptDate));
			}*/		
		} catch (ParseException e1) {			
			e1.printStackTrace();
		}		
		
		return gipiQuote;
	}	

	/**
	 * Zero pad.
	 * 
	 * @param input the input
	 * @param padding the padding
	 * @return the string
	 */
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
	
	/**
	 * Prepare quotation for editing.
	 * 
	 * @param request the request
	 * @param gipiQuote the gipi quote
	 * @return the http servlet request
	 * @throws SQLException the sQL exception
	 * @throws ServletException the servlet exception
	 * @throws Exception the exception
	 */
	private HttpServletRequest prepareQuotationForEditing(HttpServletRequest request, GIPIQuote gipiQuote) // , String env
		throws SQLException, ServletException, Exception {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		HttpServletRequest newRequest = request;
		
		String quotationNo = null;
		
        LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); //  + env

        quotationNo = zeroPad(String.valueOf(gipiQuote.getQuotationNo()), 6);
        newRequest.setAttribute("quotationNo", quotationNo);

        String args[] = { gipiQuote.getLineCd() };
        List<LOV> sublineList = helper.getList(LOVHelper.SUB_LINE_LISTING, args);
        newRequest.setAttribute("sublineListing", sublineList);

        List<LOV> branchSourceList = helper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
        newRequest.setAttribute("branchSourceListing", branchSourceList);

        List<LOV> reasonList = helper.getList(LOVHelper.REASON_LISTING, args);
        newRequest.setAttribute("reasonListing", reasonList);
        
        //emsy09042012
		String[] parameters = {gipiQuote.getLineCd() , "GIIMM001", gipiQuote.getUserId() };
		List<LOV> issSourceList = helper.getList(LOVHelper.ISSUING_SOURCE_LISTING, parameters);
		request.setAttribute("issSourceListing", issSourceList);
		//emsy09042012
        return newRequest;
	}
}