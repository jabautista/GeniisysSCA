/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
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

import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.geniisys.giri.entity.GIRIWInPolbas;
import com.geniisys.giri.service.GIRIWInPolbasService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIPARListController.
 */
public class GIPIPARListController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPARListController.class);
	public static Map<String, Object> status = new HashMap<String, Object>();
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env

		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
		GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
		GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
		//GIPIQuoteFacadeService gipiQuote = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService");
		GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		//int parId = Integer.parseInt(request.getParameter("parId"));
		try{
			if ("showParListing".equals(ACTION)) {
				String lineCd = request.getParameter("lineCd");
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(lineCd));
				
				PAGE = "/pages/underwriting/par/parListing.jsp";
			} else if ("filterParListing".equals(ACTION)) {
				String keyword = request.getParameter("keyword");
				String lineCd = request.getParameter("lineCd");
				
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				
				PaginatedList parList = gipiParService.getGipiParList(lineCd, pageNo, keyword, USER.getUserId());
				request.setAttribute("searchResult", parList);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("noOfPages", parList.getNoOfPages());
				
				PAGE = "/pages/underwriting/par/subPages/parListingTable.jsp";
			} else if ("showPARCreationPage".equals(ACTION)){
				GIISISSourceFacadeService issServ = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				GIISLineFacadeService lineserv	= (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				GIISUserFacadeService userserv = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService"); 
				String userId = USER.getUserId();
				
				String riSwitch = request.getParameter("riSwitch");
				//modified by: nica 02.18.2011
				Map<String, Object> parameters = new HashMap<String, Object>();
				parameters.put("userId", userId);
				parameters.put("moduleId", "GIPIS050");
				request.setAttribute("defaultIssCd", issServ.getDefaultIssCd(riSwitch, USER.getUserId()));
				request.setAttribute("checkedLineIssourceListing", lineserv.getCheckedLineIssourceList(parameters));
				request.setAttribute("userValidated", userserv.giacValidateUser(userId, "OV", "GIPIS050"));
				request.setAttribute("riCd", giisParametersService.getParamValueV2("ISS_CD_RI"));
				request.setAttribute("selectedLineCd", request.getParameter("lineCd")); // added by: Nica 08.18.2012
				
				Calendar cal=Calendar.getInstance();
				int year = cal.get(Calendar.YEAR);
				request.setAttribute("year", year%100);
				log.info("Creating PAR creation form...");
				String[] params = {"GIPIS050", USER.getUserId()};
				request.setAttribute("lineListing", lovHelper.getList(LOVHelper.LINE_LISTING, params));
				if ("Y".equals(riSwitch)) {
					request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.RI_SOURCE_LISTING));
				} else {
					request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.GIPIS050_ISSUING_SOURCE_LISTING, params)); 	
				}
				PAGE ="/pages/underwriting/parCreation.jsp";
			} else if("saveCreatedPAR".equals(ACTION) || "saveEndtPar".equals(ACTION)){
				log.info("Saving PAR...");
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				
				GIPIPARList preparedPAR = preparePARList(request, response, USER);
				
				//this portion was added to allow null insertion of assd_no when creating endt_par
				if ("saveEndtPar".equals(ACTION) || (preparedPAR.getAssdNo()==0)){ 
					preparedPAR.setAssdNo(null);
				}
				GIPIPARList savedPAR = gipiParService.saveGIPIPAR(preparedPAR);
				
				//request.setAttribute("savedPAR", savedPAR);
				request.setAttribute("parSeqNo", savedPAR.getParSeqNo());
				request = GIPIPARUtil.setPARInfoFromSavedPAR(request, savedPAR);
				request.setAttribute("lineName", request.getParameter("vlineName"));
				JSONObject jsonGIPIPARList = new JSONObject(gipiParService.getGIPIPARDetails(savedPAR.getParId()));
				JSONObject jsonGIPIWPolbas = null;
				if (jsonGIPIPARList.getInt("parStatus") > 2){
					jsonGIPIWPolbas = new JSONObject(gipiWPolbasService.getGipiWPolbas(savedPAR.getParId()));
				}
				StringFormatter.replaceQuotesInObject(jsonGIPIPARList);
				StringFormatter.replaceQuotesInObject(jsonGIPIWPolbas);
				request.setAttribute("jsonGIPIPARList", jsonGIPIPARList);
				request.setAttribute("jsonGIPIWPolbas", jsonGIPIWPolbas == null ? "[]" : jsonGIPIWPolbas);
				message = "SUCCESS";
				PAGE = "/pages/underwriting/subPages/parParameters.jsp";
			} else if ("saveParCreationPageChanges".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String fromQuote = request.getParameter("fromQuote");
				String hasGIPIWPolBasDetails = request.getParameter("hasGIPIWPolBasDetails");
				
				//update quote status params
				GIPIPARList preparedPAR = preparePARList(request, response, USER);
								
				params.put("preparedPAR", preparedPAR);
				params.put("fromQuote", fromQuote);
				params.put("hasGIPIWPolBasDetails", hasGIPIWPolBasDetails);
				
				if ("Y".equals(fromQuote)){
					System.out.println(request.getCharacterEncoding());
					System.out.println(request.getParameter("selectedQuoteId"));
					Integer quoteId = Integer.parseInt(request.getParameter("selectedQuoteId") == ""? "0" : request.getParameter("selectedQuoteId"));
					Integer assdNo = request.getParameter("selectedAssdNo") == ""? null : Integer.parseInt(request.getParameter("selectedAssdNo"));
					String issCd = request.getParameter("selectedIssCd");
					String lineCd = request.getParameter("selectedLineCd");
					params.put("quoteId", quoteId);
					params.put("assdNo", assdNo);
					params.put("issCd", issCd);
					params.put("lineCd", lineCd);
					if ("N".equals(hasGIPIWPolBasDetails)){
						params.put("userId", USER.getUserId());
					}
				}
				
				params = gipiParService.saveParCreationPageChanges(params);
				GIPIPARList savedPAR = (GIPIPARList) params.get("savedPAR");
				
				//request.setAttribute("savedPAR", savedPAR);
				//request.setAttribute("parSeqNo", savedPAR.getParSeqNo());
				request = GIPIPARUtil.setPARInfoFromSavedPAR(request, savedPAR);
				JSONObject jsonGIPIPARList = new JSONObject(StringFormatter.replaceQuotesInObject(savedPAR));				
				request.setAttribute("jsonGIPIPARList", jsonGIPIPARList);
				GIPIWPolbasService serv = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				if ("Y".equals(hasGIPIWPolBasDetails)){
					request.setAttribute("jsonGIPIWPolbas", new JSONObject(StringFormatter.replaceQuotesInObject(serv.getGipiWPolbas(savedPAR.getParId()))));
				} else {
					request.setAttribute("jsonGIPIWPolbas", new JSONObject("{}"));
				}
				request.setAttribute("lineName", request.getParameter("vlineName"));
				request.setAttribute("riFlag", "Y");
				message = "SUCCESS";
				PAGE = "/pages/underwriting/subPages/parParameters.jsp";
			} else if("getParSeqNo".equals(ACTION)){
				String parSeqNoC = request.getParameter("globalParSeqNoC");
				//request.setAttribute("message", parSeqNoC );
				//PAGE = "/pages/genericMessage.jsp";
				message = parSeqNoC;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getSublineCds".equals(ACTION)){
				String lineCd = request.getParameter("vlineCd");
				String[] params = {lineCd};
				
				request.setAttribute("subLineListing", lovHelper.getList(LOVHelper.SUB_LINE_LISTING, params));
				PAGE = "/pages/underwriting/dynamicDropDown/subline.jsp";
			} else if ("getIssCds".equals(ACTION)){
				String lineCd = request.getParameter("vlineCd");
				String[] params = {lineCd, USER.getUserId(), "GIPIS050"};
				request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.PAR_ISSOURCE_LISTING, params));
				PAGE = "/pages/underwriting/dynamicDropDown/issource.jsp";
			} else if ("checkParQuote".equals(ACTION)){
				Integer parId = Integer.parseInt(request.getParameter("globalParId"));
				String quoteOrInfo = (gipiParService.checkParQuote(parId) == null)? "": gipiParService.checkParQuote(parId);
				message = ""+quoteOrInfo;
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("setParParameters".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				Integer parId = Integer.parseInt(request.getParameter("globalParId"));
				JSONObject jsonGIPIPARList = new JSONObject(gipiParService.getGIPIPARDetails(parId));
				JSONObject jsonGIPIWPolbas = null;
				System.out.println("Check status: "+jsonGIPIPARList.getInt("parStatus"));
				
				String formattedIssueDate = null;
				
				if (jsonGIPIPARList.getInt("parStatus") > 2){
					GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
					if(gipiWPolbas.getIssueDate() != null) {
						SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
						formattedIssueDate = sdf.format(gipiWPolbas.getIssueDate());
					}						
					jsonGIPIWPolbas = new JSONObject(gipiWPolbasService.getGipiWPolbas(parId));
				}
				System.out.println("jsonGIPIWPolbas: "+jsonGIPIWPolbas);
				StringFormatter.replaceQuotesInObject(jsonGIPIPARList);
				StringFormatter.replaceQuotesInObject(jsonGIPIWPolbas);
				request.setAttribute("jsonGIPIPARList", jsonGIPIPARList);
				request.setAttribute("jsonGIPIWPolbas", jsonGIPIWPolbas == null ? "[]" : jsonGIPIWPolbas);
				request.setAttribute("formattedIssueDate", formattedIssueDate); //apollo cruz 09.11.2015 sr#19975
				
				GIPIWInvoiceFacadeService gipiWInvoiceService = (GIPIWInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiWInvoiceFacadeService"); // +env
				@SuppressWarnings("rawtypes")
				Map parsWinvoice = new HashMap();
				parsWinvoice = gipiWInvoiceService.isExist2(parId);
				String isExistWinvoice = (String) parsWinvoice.get("exist");
				request.setAttribute("isExistGipiWInvoice", isExistWinvoice);
				
				String enablePost = gipiParService.getSharePercentageGipis085(parId);
				request.setAttribute("enablePost", enablePost);
				
				String lineCd = jsonGIPIPARList.getString("lineCd"); 
				String menuLineCd = giisLineService.getMenuLineCd(lineCd); //robert 10.10.14
				if(lineCd.equals("SU") || menuLineCd.equals("SU")){ //robert 10.10.14
					Integer enableDist = gipiParService.whenNewFormInstGipis017B(parId);
					request.setAttribute("enableDist", enableDist);
					System.out.println("Bonds");
				}
				
				GIISParameterFacadeService giisParameterFacadeService=(GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("issCdRI", giisParameterFacadeService.getParamValueV("ISS_CD_RI").getParamValueV());
				
				PAGE = "/pages/underwriting/subPages/parParameters.jsp";
				request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParService.getGIPIPARDetails(parId));
			} else if ("checkIfAssdIsSelected".equals(ACTION)){
				message = "Y";
				PAGE = "/pages/genericMessage.jsp";
			} else if (("updateStatusFromQuote".equals(ACTION)) || ("returnPARToQuotation".equals(ACTION))){
				log.info("Returning PAR into quotation...");
				int retQuoteId = Integer.parseInt(request.getParameter("retQuoteId"));
				gipiParService.returnPARToQuotation(retQuoteId);
				//gipiParService.updateStatusFromQuote(retQuoteId, 99);
				//gipiQuote.updateStatusFromPar(retQuoteId);
				message = "Return to quotation successful.";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showEndtPARCreationPage".equals(ACTION)){
				GIISISSourceFacadeService issServ = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				GIISLineFacadeService lineServ	= (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				String riSwitch = request.getParameter("riSwitch");
				Calendar cal=Calendar.getInstance();
				int year = cal.get(Calendar.YEAR);
				request.setAttribute("year", year);
				String userId = USER.getUserId();
				String[] params = {"", userId, "GIPIS056"};
				//String lineCd = request.getParameter("vlineCd");
				//String[] parameters = {lineCd, USER.getUserId(), "GIPIS056"};
				String[] parameters = {"GIPIS056", USER.getUserId()};
				
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("userId", USER.getUserId());
				paramMap.put("moduleId", "GIPIS056");
				
				List<GIISLine> lineIssue = lineServ.getCheckedLineIssourceList(paramMap);
				StringFormatter.replaceQuotesInList(lineIssue);
				
				request.setAttribute("validLineIssueSourceList", new JSONArray(lineIssue));
				request.setAttribute("defaultIssCd", issServ.getDefaultIssCd(riSwitch, USER.getUserId()));
				request.setAttribute("selectedLineCd", request.getParameter("lineCd")); // added by: Nica 08.18.2012
				
				if ("Y".equals(riSwitch)) {
					request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.RI_SOURCE_LISTING));
				} else {
					request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.PAR_ISSOURCE_LISTING, params));
				}   
				request.setAttribute("lineListing", lovHelper.getList(LOVHelper.LINE_LISTING, parameters));
				PAGE="/pages/underwriting/endtParCreation.jsp";
			} else if("showEndtParListing".equals(ACTION)){
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("lineCd", request.getParameter("lineCd")); 
				
				PAGE = "/pages/underwriting/par/endtParListing.jsp";
				
			} else if ("filterEndtParListing".equals(ACTION)) {
				String keyword = request.getParameter("keyword");
				String lineCd = request.getParameter("lineCd");
				//String parNo= request.getParameter("parNo");
			
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				
				System.out.println(lineCd);
				PaginatedList endtParList = gipiParService.getEndtParList(lineCd, pageNo, keyword, USER.getUserId());
				request.setAttribute("searchResult", endtParList);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("noOfPages", endtParList.getNoOfPages());
				
				PAGE = "/pages/underwriting/par/subPages/endtParListingTable.jsp";
				
			} else if ("setEndtParParameters".equals(ACTION)){
				Integer parId = Integer.parseInt(request.getParameter("globalParId"));
				PAGE = "/pages/underwriting/subPages/endtParParameters.jsp";
				request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParService.getGIPIPARDetails(parId));
				
			} else if ("insertGipiWPolbasicDetailsForPAR".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", Integer.parseInt(request.getParameter("quoteId")==""?"0":request.getParameter("quoteId")));
				params.put("parId", Integer.parseInt(request.getParameter("parId")==""?"0":request.getParameter("parId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("assdNo", Integer.parseInt(request.getParameter("assdNo")==""?"0":request.getParameter("assdNo")));
				params.put("userId", USER.getUserId());
				params = gipiWPolbasService.insertGipiWPolbasicDetailsForPAR(params);
				message = (String) params.get("pOut");
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("copyParList".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				String parNoCopied = request.getParameter("origParNo");
				Map<String, Object> status = new HashMap<String, Object>();
				status.put("message", "Started copying "+parId+" information...");
				GIPIPARListController.status.put(String.valueOf(parId), status);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("appUser", USER.getUserId());
				params.put("parId", parId);
				params.put("userId", USER.getUserId() /*request.getParameter("userId")*/);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("newParId", null);
				params.put("openFlag", null);
				params.put("menuLine", null);
				params.put("newParSeqNo", null);
				params.put("parNo", null);
				params.put("endtText01", "");
				params.put("endtText02", "");
				params.put("endtText03", "");
				params.put("endtText04", "");
				params.put("endtText05", "");
				params.put("endtText06", "");
				params.put("endtText07", "");
				params.put("endtText08", "");
				params.put("endtText09", "");
				params.put("endtText10", "");
				params.put("endtText11", "");
				params.put("endtText12", "");
				params.put("endtText13", "");
				params.put("endtText14", "");
				params.put("endtText15", "");
				params.put("endtText16", "");
				params.put("endtText17", "");
				//gipiParService.copyParList(params);
				String PARCopy = gipiParService.copyParList(params);
				
				message = "PAR No. " + parNoCopied + " has been copied to Par No. " + PARCopy + ".";
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getCopyParStatus".equals(ACTION)) {
				String parId = request.getParameter("parId");
				
				Map<String, Object> a = (Map<String, Object>) GIPIPARListController.status.get(parId);
				if (null == a) {
					a = new HashMap<String, Object>();
					a.put("message", "Started copying "+parId+" information...");
					GIPIPARListController.status.put(String.valueOf(parId), a);
				}
				
				message = (String) a.get("message");
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deletePAR".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("menuLineCd", request.getParameter("menuLineCd"));
				params.put("userId", USER.getUserId());
				gipiParService.deletePar(params);
				message = "PAR No. " + request.getParameter("parNo") + " has been deleted.";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("cancelPAR".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				String parStatus = request.getParameter("parStatus");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				//params.put("lineCd", request.getParameter("lineCd"));
				//params.put("menuLineCd", request.getParameter("menuLineCd"));
				params.put("userId", USER.getUserId());
				params.put("parStatus", parStatus);
				gipiParService.cancelPar(params);
				message = "PAR No. " + request.getParameter("parNo") + " has been canceled.";
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("showParListTableGrid".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				//String userId = USER.getAllUserSw().equals("Y") ? "" : USER.getUserId();
				String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
				String directParOpenAccess = giisParametersService.getParamValueV2("DIRECT_PAR_OPENACCESS");
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(lineCd));
				request.setAttribute("ora2010Sw", ora2010Sw);
				request.setAttribute("directParOpenAccess", directParOpenAccess);
				request.setAttribute("user", new JSONObject(USER));
								
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				//params.put("userId", userId);
				System.out.println("riSwitch parlist"+(request.getParameter("riSwitch")));
				params.put("riSwitch", request.getParameter("riSwitch"));
				params.put("userId", USER.getUserId());
				params.put("allUserSw", USER.getAllUserSw());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("parType", "P");
				params.put("moduleId", "GIPIS001");
				params = gipiParService.getGipiParListing(params);
				request.setAttribute("riSwitch", request.getParameter("riSwitch"));
				request.setAttribute("gipiParListTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/underwriting/par/parTableGridListing.jsp";
			}else if("refreshParListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				//String userId = USER.getAllUserSw().equals("Y") ? "" : USER.getUserId();
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				//params.put("userId", userId);
				params.put("riSwitch", request.getParameter("riSwitch"));
				params.put("userId", USER.getUserId());
				params.put("allUserSw", USER.getAllUserSw());
				params.put("parType", "P");
				params.put("moduleId", "GIPIS001");
				params.put("riSwitch", request.getParameter("riSwitch"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = gipiParService.getGipiParListing(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showEndtParListTableGrid".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				//String userId = USER.getAllUserSw().equals("Y") ? "" : USER.getUserId();
				String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("menuLineCd", giisLineService.getMenuLineCd(lineCd));
				request.setAttribute("ora2010Sw", ora2010Sw);
				request.setAttribute("riSwitch", request.getParameter("riSwitch")); // andrew - 05.30.2011
				request.setAttribute("user", new JSONObject(USER));
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				//params.put("userId", userId);
				params.put("userId", USER.getUserId());
				params.put("allUserSw", USER.getAllUserSw());
				params.put("riSwitch", request.getParameter("riSwitch"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("parType", "E");
				params.put("moduleId", "GIPIS058");
				params = gipiParService.getGipiParListing(params);
				request.setAttribute("gipiEndtParListTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				
				PAGE = "/pages/underwriting/par/endtParTableGridListing.jsp";
			}else if("refreshEndtParListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				//String userId = USER.getAllUserSw().equals("Y") ? "" : USER.getUserId();
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				//params.put("userId", userId);
				params.put("userId", USER.getUserId());
				params.put("allUserSw", USER.getAllUserSw());
				params.put("riSwitch", request.getParameter("riSwitch")); // andrew - 05.27.2011
				params.put("parType", "E");
				params.put("moduleId", "GIPIS058");
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = gipiParService.getGipiParListing(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkRIBeforePARDeletionOrCancel".equals(ACTION)){
				Integer parId = Integer.parseInt(request.getParameter("parId"));
				Map<String, Object> checkResult = new HashMap<String, Object>();
				checkResult = gipiParService.checkRITablesBeforePARDeletion(parId);
				String isExist = (String) checkResult.get("exist");
				System.out.println("Checking RI Tables...");
				if("".equals(isExist) || isExist == null){
					message = "Y";
				}else{
					message = isExist;
				}
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateParRemarks".equals(ACTION)){
				JSONObject rows = new JSONObject(request.getParameter("updatedRows"));
				JSONArray updatedRows = new JSONArray(rows.getString("setRows"));
				gipiParService.updateParRemarks(updatedRows);
				message= "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkParlistDependency".equals(ACTION)){ //angelo 04.13.11
				message = gipiParService.checkParlistDependency(Integer.parseInt(request.getParameter("inspNo")));
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("getAssuredList".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("keyword", request.getParameter("keyword"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params = gipiParService.getParAssuredList(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("assuredList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyAssuredList.jsp";
				}
			} else if("getEndorsementTypeList".equals(ACTION)){ //Rey 07-19-2011
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("keyword", request.getParameter("keyword"));
				params = gipiParService.getParEndorsementTypeList(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("endorsementList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyEndorsementTypeList.jsp";
				}
			}else if("showRIParCreationPage".equals(ACTION)) {
				GIISISSourceFacadeService issServ = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				GIISLineFacadeService lineserv	= (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				GIISUserFacadeService userserv = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService"); 
				String userId = USER.getUserId();
									
				Map<String, Object> parameters = new HashMap<String, Object>();
				parameters.put("userId", userId);
				parameters.put("moduleId", "GIRIS005");
								
				request.setAttribute("checkedLineIssourceListing", lineserv.getCheckedLineIssourceList(parameters));
				request.setAttribute("userValidated", userserv.giacValidateUser(userId, "OV", "GIRIS005"));
				Calendar cal=Calendar.getInstance();
				int year = cal.get(Calendar.YEAR);
				request.setAttribute("year", year%100);
				log.info("Creating PAR creation form...");
				
				request.setAttribute("moduleUser", userId);
				
				String mode = request.getParameter("mode");
				request.setAttribute("mode", mode);
				request.setAttribute("parType", request.getParameter("parType"));
				if(mode.equals("1")) {
					// initial acceptance -> access from Basic Menu
					GIRIWInPolbasService giriWInPolbasService = (GIRIWInPolbasService) APPLICATION_CONTEXT.getBean("giriWInPolbasService");
					GIRIWInPolbas giriWInPolbas = giriWInPolbasService.getWInPolbas(Integer.parseInt(request.getParameter("parId")));
					//System.out.println("TEst mode "+mode+" ----"+giriWInPolbas.getAcceptNo());
					if(giriWInPolbas == null) {
						request.setAttribute("winPolbas", new JSONObject("{}"));
					} else {
						request.setAttribute("winPolbas", new JSONObject(giriWInPolbas));
					}
				} else {
					// ri par creation
					request.setAttribute("defaultIssCd", issServ.getDefaultIssCd("Y", USER.getUserId()));
					String[] params = {"GIRIS005", USER.getUserId()};
					request.setAttribute("lineListing", lovHelper.getList(LOVHelper.LINE_LISTING, params));
					request.setAttribute("issourceListing", lovHelper.getList(LOVHelper.RI_SOURCE_LISTING));
				}
				PAGE = "/pages/underwriting/reInsurance/enterInitialAcceptance/enterInitialAcceptancePAR.jsp";
			} else if("saveRIPar".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				int mode = Integer.parseInt(request.getParameter("mode"));
					
				params = gipiParService.saveRIPar(request.getParameter("parameters"), USER.getUserId(), mode, request.getParameter("parType"));
				
				GIRIWInPolbas wInPolbas = (GIRIWInPolbas) params.get("savedWInPolbas");
				if(mode == 0) {
					GIPIPARList savedPAR = (GIPIPARList) params.get("savedPAR");	
					request = GIPIPARUtil.setPARInfoFromSavedPAR(request, savedPAR);
					StringFormatter.escapeHTMLInObject(savedPAR); // Nica 05.16.2012
					JSONObject jsonGIPIPARList = new JSONObject(savedPAR);
					//StringFormatter.replaceQuotesInObject(jsonGIPIPARList);
					JSONObject jsonGIRIWInPolbas = new JSONObject(StringFormatter.escapeHTMLInObject(wInPolbas));
					request.setAttribute("riFlag", "Y");
					request.setAttribute("jsonGIRIWInPolbas", jsonGIRIWInPolbas == null ? "[]" : jsonGIRIWInPolbas);
					request.setAttribute("jsonGIPIPARList", jsonGIPIPARList);
					/*if ("Y".equals(hasGIPIWPolBasDetails)){
						request.setAttribute("jsonGIPIWPolbas", new JSONObject(serv.getGipiWPolbas(savedPAR.getParId())));
					} else {*/
						request.setAttribute("jsonGIPIWPolbas", new JSONObject("{}"));
						request.setAttribute("isExistGipiWInvoice", "N");
					//}
					request.setAttribute("parId", savedPAR.getParId()); // - irwin july 16, 2012
					request.setAttribute("lineName", request.getParameter("vlineName"));
					System.out.println("TEST -- "+wInPolbas.getAcceptNo() + " - " + wInPolbas.getRiCd());
					System.out.println("jsonGIRIWInPolbas>>>>"+jsonGIRIWInPolbas);
					System.out.println("jsonGIPIPARList>>>>>"+jsonGIPIPARList);
					message = "SUCCESS";
					PAGE = "/pages/underwriting/subPages/parParameters.jsp";
				} else {
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("generateAcceptNo".equals(ACTION)) {
				GIRIWInPolbasService giriWInPolbasService = (GIRIWInPolbasService) APPLICATION_CONTEXT.getBean("giriWInPolbasService");
				String acceptNo = giriWInPolbasService.generateAcceptNo().toString();
				request.setAttribute("object", acceptNo);
				PAGE = "/pages/genericObject.jsp";
			} else if("getGIPIPARDetails".equals(ACTION)){
				message = (new JSONObject(gipiParService.getGIPIPARDetails(Integer.parseInt(request.getParameter("parId"))))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
			/*if ("getAssdFromParId".equals(ACTION)){
				System.out.println("in Controller, pardId: "+parId);
				GIPIPAR par = gipiParService.getGIPIPARDetails(parId);
				request.setAttribute("parNo", par.getParId());
				request.setAttribute("assuredName", par.getAssdName());
				PAGE = "/pages/underwriting/subPages/parInformation.jsp";
			}*/
			else if("showGIPIS211".equals(ACTION)){
				JSONObject jsonPar = gipiParService.getParListGIPIS211(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPar.toString();
					PAGE = "/pages/genericMessage.jsp";					
				}else{
					JSONObject jsonParVehicles = gipiParService.getParVehiclesGIPIS211(request);
					JSONObject jsonParVehicleItems = gipiParService.getParVehicleItemsGIPIS211(request);
					
					request.setAttribute("policiesParListing", jsonPar);
					request.setAttribute("parVehiclesListing", jsonParVehicles);
					request.setAttribute("parVehicleItems", jsonParVehicleItems);
					PAGE = "/pages/underwriting/policyInquiries/motorCarInquiries/motorcarPoliciesParListing/motorcarPoliciesParListing.jsp";
				}
			}else if("getParVehiclesGIPIS211".equals(ACTION)){
				JSONObject jsonParVehicles = gipiParService.getParVehiclesGIPIS211(request);
				message = jsonParVehicles.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getParVehicleItemsGIPIS211".equals(ACTION)){
				JSONObject jsonParVehicleItems = gipiParService.getParVehicleItemsGIPIS211(request);
				message = jsonParVehicleItems.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCoverNoteList".equals(ACTION)){	//added by shan 10.18.2013
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGipis213ParList");
				params.put("dateType", request.getParameter("dateType"));
				params.put("searchBy", request.getParameter("searchBy"));
				params.put("asOfDate", request.getParameter("asOfDate"));
				params.put("fromDate", request.getParameter("fromDate"));
				params.put("toDate", request.getParameter("toDate"));
				
				Map<String, Object> coverNoteGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonCovernote = new JSONObject(coverNoteGrid);
				
				if ("1".equals(request.getParameter("refresh"))){
					message = jsonCovernote.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("covernoteGrid", jsonCovernote);
					PAGE = "/pages/underwriting/par/coverNoteInquiry/coverNoteInquiry.jsp";
				}
			} else if("checkForPostedBinder".equals(ACTION)){
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) || request.getParameter("parId") == null ? "0" : request.getParameter("parId"));
				String exists = gipiParService.checkForPostedBinder(parId);
				message = exists;
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkIfInvoiceExistsRI".equals(ACTION)){//added ommited codes of Sir Joms : edgar 11/18/2014
				Integer parId = Integer.parseInt("".equals(request.getParameter("parId")) || request.getParameter("parId") == null ? "0" : request.getParameter("parId"));
				String exists = gipiParService.checkIfInvoiceExistsRI(parId);
				message = exists;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("recreateWInvoiceGiris005".equals(ACTION)){
				Integer parId = new Integer((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				gipiParService.recreateWInvoiceGiris005(parId);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			}//end of addition edgar 11/18/2014
			else if("checkAllowCancel".equals(ACTION)){//added edgar 02/16/2015
				Integer parId = Integer.parseInt(request.getParameter("parId"));
				Map<String, Object> checkResult = new HashMap<String, Object>();
				checkResult = gipiParService.checkAllowCancel(parId);
				String isAllowed = (String) checkResult.get("allowed");
				System.out.println("Checking Parameters...");
				if("Y".equals(isAllowed) || isAllowed == "Y"){
					message = "Y";
				}else{
					message = "N";
				}
				PAGE = "/pages/genericMessage.jsp";
			} else if("copyAttachmentsFromQuoteToPar".equals(ACTION)) {
				GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("quoteId", request.getParameter("quoteId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("parId", request.getParameter("parId"));
				params.put("parNo", request.getParameter("parNo"));
				params.put("mediaPathMK", giisParameterFacadeService.getParamValueV2("MEDIA_PATH_MK"));
				params.put("mediaPathUW", giisParameterFacadeService.getParamValueV2("MEDIA_PATH_UW"));				
				params.put("userId", USER.getUserId());
				
				message = gipiWPolbasService.copyAttachmentsFromQuoteToPar(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getParNo2".equals(ACTION)) {
				message = gipiParService.getParNo2(Integer.parseInt(request.getParameter("policyId")));
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (NumberFormatException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	/**
	 * Prepare par list.
	 * 
	 * @param request the request
	 * @param response the response
	 * @param USER the uSER
	 * @return the gIPIPAR list
	 */
	private GIPIPARList preparePARList(HttpServletRequest request, HttpServletResponse response, GIISUser USER){
		GIPIPARList par = new GIPIPARList();
		try{
			System.out.println("preparing PAR...");
			String lineCd = request.getParameter("vlineCd");
			System.out.println("lineCd: "+lineCd);
			System.out.println(request.getParameter("year"));
			String issCd = request.getParameter("vissCd");
			int parYy = (Integer.parseInt(request.getParameter("year"))%100);//to just get the last two digits of the year
			int quoteSeqNo = Integer.parseInt(request.getParameter("quoteSeqNo"));
			int assdNo = Integer.parseInt((request.getParameter("assuredNo")=="")? "0" : request.getParameter("assuredNo"));
			String remarks = request.getParameter("remarks");
			int parId = Integer.parseInt((request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
			int parSeqNo = Integer.parseInt((request.getParameter("parSeqNo") == "") ? "0" : request.getParameter("parSeqNo"));
			String parType = request.getParameter("parType");
			Integer quoteId = Integer.parseInt((request.getParameter("quoteId") == "")? "0" : (request.getParameter("quoteId")));
			String address1 = request.getParameter("address1");
			String address2 = request.getParameter("address2");
			String address3 = request.getParameter("address3");
			
			par.setIssCd(issCd);
			par.setLineCd(lineCd);
			par.setParYy(parYy);
			par.setQuoteSeqNo(quoteSeqNo);
			par.setUnderwriter(USER.getUserId());
			par.setAssdNo(assdNo);
			par.setRemarks(remarks);
			par.setParType(parType);
			par.setParId(parId);
			par.setParSeqNo(parSeqNo);
			if (quoteId != 0){
				par.setQuoteId(quoteId);
			}
			par.setAddress1(address1);
			par.setAddress2(address2);
			par.setAddress3(address3);
			par.setUserId(USER.getUserId());
			//return par;
		} catch (NumberFormatException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return par;
	}
}
