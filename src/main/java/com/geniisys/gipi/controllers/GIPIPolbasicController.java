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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISReports;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISDocumentService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.pack.service.GIPIPackPolbasicService;
import com.geniisys.gipi.service.GIPIItemPerilService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIPolbasicController.
 */
public class GIPIPolbasicController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPolbasicController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings({ "deprecation" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
			GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
			
			if ("extractExpiry".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId") == null ? "0" : request.getParameter("parId"));
				Date expiryDate = gipiPolbasicService.extractExpiryDate(parId);
				request.setAttribute("expiryDate", expiryDate);
			} else if("getBackEndtEffectivityDate".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId") == null ? "0" : request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo") == null ? "0" : request.getParameter("itemNo"));
				message = gipiPolbasicService.getBackEndtEffectivityDate(parId, itemNo);
				if (message == null) {
					message = "";
				} else if (message.trim().length() > 0){
					message = "SUCCESS " + message;
				}
				
				PAGE = "/pages/genericMessage.jsp";	
			} else if("populateGixxTables".equals(ACTION)){
				log.info("Populating related GIXX tables...");
				int parId = Integer.parseInt(request.getParameter("parId")==""? "0":request.getParameter("parId"));
				int policyId = Integer.parseInt(request.getParameter("policyId")==""? "0":request.getParameter("policyId"));
				int extractId = Integer.parseInt(request.getParameter("extractId")==""? "0":request.getParameter("extractId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("policyId", policyId);
				params.put("extractId", extractId);
				log.info("Populate Gixx Tables : " + params.toString());
				gipiPolbasicService.populateGixxTables(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("populateGixxTableWPolDoc".equals(ACTION)){
				log.info("Populating related GIXX tables...");
				int parId = Integer.parseInt(request.getParameter("globalParId") == null ? "0" : request.getParameter("globalParId"));
				int extractId = Integer.parseInt(request.getParameter("extractId")==""? "0":request.getParameter("extractId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("extractId", extractId);
				gipiPolbasicService.populateGixxTableWPolDoc(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("populatePackGixxTables".equals(ACTION)){
				int policyId = Integer.parseInt(request.getParameter("policyId")==""? "0":request.getParameter("policyId"));
				int extractId = Integer.parseInt(request.getParameter("extractId")==""? "0":request.getParameter("extractId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("packPolicyId", policyId);
				params.put("extractId", extractId);
				gipiPolbasicService.populatePackGixxTables(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("populatePackGixxTableWPolDoc".equals(ACTION)){
				log.info("Populating related GIXX tables for Package Policy Document...");
				int packParId = Integer.parseInt(request.getParameter("globalPackParId") == null ? "0" : request.getParameter("globalPackParId"));
				int extractId = Integer.parseInt(request.getParameter("extractId")==""? "0":request.getParameter("extractId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("packParId", packParId);
				params.put("extractId", extractId);
				gipiPolbasicService.populatePackGixxTableWPolDoc(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getExtractId".equals(ACTION)){
				log.info("Getting a new extract id for policy extraction...");
				int extractId = gipiPolbasicService.getExtractId();
				message = extractId+"";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updatePrintedCount".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("appUser", USER.getUserId());
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));				
				
				gipiPolbasicService.updatePrintedCount(params);
			} else if ("getMaxEndtItemNo".equals(ACTION)){
				String lineCd = request.getParameter("globalLineCd");
				String sublineCd = request.getParameter("globalSublineCd");
				String issCd = request.getParameter("globalIssCd");
				Integer issueYy = Integer.parseInt(request.getParameter("globalIssueYy"));
				Integer polSeqNo = Integer.parseInt(request.getParameter("globalPolSeqNo"));
				Integer renewNo = Integer.parseInt(request.getParameter("globalRenewNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				params.put("issCd", issCd);
				params.put("issueYy", issueYy);
				params.put("polSeqNo", polSeqNo);
				params.put("renewNo", renewNo);
				message = "" + gipiPolbasicService.getMaxEndtItemNo(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("getPolicyNoForEndt".equals(ACTION)) {
				log.info("Getting list of Policies for Endorsement...");
				String lineCd = request.getParameter("lineCd");
				String issCd = request.getParameter("issCd");
				String sublineCd = request.getParameter("sublineCd");
			
				int pageNo = Integer.parseInt((request.getParameter("polPageNo") == "" || request.getParameter("polPageNo") == null) ? "1" : request.getParameter("polPageNo"));
				System.out.println("Page obtained: " + pageNo);
				Map<String, String> params = new HashMap<String, String>();
				params.put("lineCd", lineCd);
				params.put("issCd", issCd);
				params.put("sublineCd", sublineCd);
				params.put("keyword", "");
				
				PaginatedList policies = gipiPolbasicService.getPolicyForEndt(params, 1);
				policies.gotoPage(pageNo-1);
				//System.out.println("attrib2: " + lineCd + "+" + issCd + "+" + sublineCd + "totalpageNo: " + policies.getNoOfPages() + " - " + pageNo);
				
				request.setAttribute("curLine", lineCd);
				request.setAttribute("curIss", issCd);
				request.setAttribute("curSubline", sublineCd);
				
				request.setAttribute("polPageNo", pageNo);
				request.setAttribute("policies", policies);
				request.setAttribute("noOfPolPages", policies.getNoOfPages());
				PAGE = "/pages/underwriting/endt/basicInfo/subPages/policyNoForEndtSubPages/selectPolicyNo.jsp";
			} else if("filterPolicyForEndt".equals(ACTION)) {
				log.info("Filtering list of Policies...");
				String lineCd = request.getParameter("curLine");
				String issCd = request.getParameter("curIss");
				String sublineCd = request.getParameter("curSubline");
				String keyword = request.getParameter("keywordPol");
				
				int pageNo = Integer.parseInt(request.getParameter("polPageNo"));
				System.out.println("pageNumber: " + pageNo);
				Map<String, String> params = new HashMap<String, String>();
				params.put("lineCd", lineCd);
				params.put("issCd", issCd);
				params.put("sublineCd", sublineCd);
				params.put("keyword", keyword);
				
				PaginatedList policies = gipiPolbasicService.getPolicyForEndt(params, pageNo);
				policies.gotoPage(pageNo-1);
				System.out.println("filterPolicyForEndt: " + lineCd + "+" + issCd + "+" + sublineCd + "totalpageNo: " + policies.getNoOfPages() + " - " + pageNo);
				request.setAttribute("polPageNo", pageNo);
				request.setAttribute("policies", policies);
				request.setAttribute("noOfPolPages", policies.getNoOfPages());
				PAGE = "/pages/underwriting/endt/basicInfo/subPages/policyNoForEndtSubPages/selectPolicyNoTable.jsp";
			} else if ("getPolicyTableGridListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);	
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("endtLineCd", request.getParameter("endtLineCd"));
				params.put("endtSublineCd", request.getParameter("endtSublineCd"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
				params.put("assdName", request.getParameter("assdName"));
				Map<String, Object> policyTableGrid = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(policyTableGrid);	
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("polbasicListing", json);
					PAGE = "/pages/underwriting/overlay/policyTableGridListing.jsp";
				}
			} else if ("getPolicyListing".equals(ACTION) || "filterPolicyListing".equals(ACTION)){ // for deletion - andrew - 01.09.2012 - replaced with getPolicyTableGridListing ACTION 
				Integer pageNo = Integer.parseInt(request.getParameter("pageNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("lineCd2", request.getParameter("lineCd2"));
				params.put("sublineCd2", request.getParameter("sublineCd2"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
				params.put("assdName", request.getParameter("assdName"));
				params.put("pageNo", pageNo);
				PaginatedList policyList = gipiPolbasicService.getPolicyListing(params);
				StringFormatter.replaceQuotesInList(policyList);
				policyList.gotoPage(pageNo-1);
				message = "";
				if ("getPolicyListing".equals(ACTION)){
					log.info("Getting policy listing...");
					log.info("Number of pages: "+policyList.getNoOfPages());
					request.setAttribute("pageNo", pageNo);
					request.setAttribute("noOfPages", policyList.getNoOfPages());
					request.setAttribute("polbasicListing", new JSONArray(policyList));
					PAGE = "/pages/underwriting/overlay/policyListing.jsp";
				} else {
					log.info("Getting page "+pageNo+"...");
					request.setAttribute("object", new JSONArray(policyList));
					PAGE = "/pages/genericObject.jsp";
				}
			} else if("getOtherPolicyDetails".equals(ACTION)){				
				GIPIItemPerilService gipiItemPerilService = (GIPIItemPerilService) APPLICATION_CONTEXT.getBean("gipiItemPerilService");			
				GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); //Dren 02.02.2016 SR-5266
				GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService"); //Dren 02.02.2016 SR-5266				
				GIISDocumentService docServ = (GIISDocumentService) APPLICATION_CONTEXT.getBean("giisDocumentService");
				int policyId = Integer.parseInt(request.getParameter("policyId") == null ? "0" : request.getParameter("policyId"));
				String polFlag = request.getParameter("polFlag");
				String lineCd = request.getParameter("lineCd");				
				String compulsoryDeath = gipiItemPerilService.checkCompulsoryDeath(policyId);
				Integer perilCount = gipiItemPerilService.getItemPerilCount(policyId);
				String billNotPrinted = gipiPolbasicService.getBillNotPrinted(policyId, polFlag, lineCd);
				String endtTax2 = gipiPolbasicService.getEndtTax2GIPIS091(policyId);
				String printPremDetails = docServ.checkPrintPremiumDetails(lineCd);
				String menuLineCd = giisLineService.getMenuLineCd(lineCd); //Dren 02.02.2016 SR-5266
				
				String vWarcla2 = "N";
				if (lineCd.equals("SU") || menuLineCd.equals("SU") || request.getParameter("packPolFlag").equals("Y")) {
					vWarcla2 = "N"; 
				} else {
					vWarcla2 = serv.getParamValueV2("ALLOW_PRINT_WARCLA_ATTACHMENT"); 
				}; //Dren 02.02.2016 SR-5266
				
				String withMc = "N";
				if(request.getParameter("packPolFlag").equals("Y")){
					GIPIPackPolbasicService gipiPackPolbasicService = (GIPIPackPolbasicService) APPLICATION_CONTEXT.getBean("gipiPackPolbasicService");
					int parId = Integer.parseInt(request.getParameter("parId") == null ? "0" : request.getParameter("parId"));
					withMc = gipiPackPolbasicService.checkIfWithMc(parId);
				}
				
				//message = compulsoryDeath + "," + perilCount + "," + billNotPrinted + ","+ endtTax2 + "," + printPremDetails+ "," + withMc; //Dren 02.02.2016 SR-5266
				message = compulsoryDeath + "," + perilCount + "," + billNotPrinted + ","+ endtTax2 + "," + printPremDetails+ "," + withMc + "," + vWarcla2; //Dren 02.02.2016 SR-5266				
				PAGE = "/pages/genericMessage.jsp";
			} else if("getReportsListingForPolicy".equals(ACTION)){
				GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String lineCd = request.getParameter("lineCd");
				List<GIISReports> reportsListing = giisReportsService.getReportsPerLineCd(lineCd);
				StringFormatter.replaceQuotesInList(reportsListing);
				request.setAttribute("object", new JSONArray(reportsListing));	
				PAGE = "/pages/genericObject.jsp";
			} else if ("openSearchGipdLineCdLovListing".equals(ACTION)) {
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchPolicyNo.jsp";
			} else if ("getGipdLineCdLovListing".equals(ACTION)) {
				String keyword = request.getParameter("keyword");
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if (!"undefined".equals(request.getParameter("pageNo"))) {
						pageNo = new Integer(request.getParameter("pageNo")) - 1;
					}
				}
				
				searchResult = gipiPolbasicService.getGipdLineCdLov(pageNo, keyword);
				
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", pageNo + 1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchPolicyNoAjaxResult.jsp";
				
			} else if ("showViewPolicyInformationPage".equals(ACTION)){
				if(request.getParameter("policyId") != null && !request.getParameter("policyId").trim().equals("")){ // andrew 04.23.2012 - added to load policy information based on policyId parameter
					Map<String, Object> policy = gipiPolbasicService.getPolicyInformation(Integer.parseInt(request.getParameter("policyId")));
					System.out.println(":::::::" + policy + "::::::");
					request.setAttribute("jsonPolicy", new JSONObject(StringFormatter.escapeHTMLInMap(policy)));
				}
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/viewPolicyInformation.jsp";
				
			} else if ("getPolicyInformationFirstPage".equals(ACTION)||"getPolicyInformationOtherPage".equals(ACTION)){
				log.info("Loading list of policies...");
				Integer pageNo = Integer.parseInt(request.getParameter("pageNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("pageNo", pageNo);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("refPolNo", request.getParameter("refPolNo"));
				params.put("nbtLineCd", request.getParameter("nbtLineCd"));
				params.put("nbtIssCd", request.getParameter("nbtIssCd"));
				params.put("nbtParYy", request.getParameter("nbtParYy"));
				params.put("nbtParSeqNo", request.getParameter("nbtParSeqNo"));
				params.put("nbtQuoteSeqNo", request.getParameter("nbtQuoteSeqNo"));
				params.put("userId", USER.getUserId());
				params.put("moduleId", "GIPIS100");
				System.out.println("polbasic controller"+"lineCd"+params.get("lineCd"));
				
				PaginatedList policyList = gipiPolbasicService.getPolicyInformation(params);
				//StringFormatter.replaceQuotesInList(policyList);
				policyList.gotoPage(pageNo-1);
				
				if("getPolicyInformationFirstPage".equals(ACTION)){
					request.setAttribute("pageNo", pageNo);
					request.setAttribute("noOfPages", policyList.getNoOfPages());
					request.setAttribute("polBasicList", new JSONArray(policyList));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyInformationList.jsp";
				}else{
					log.info("Getting page "+pageNo+"...");
					request.setAttribute("object", new JSONArray(policyList));
					PAGE = "/pages/genericObject.jsp";
				}
			}else if ("getRelatedPolicies".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				
				//modified by apollo cruz 03.18.2015 - replaced by codes below.
				/*params = gipiPolbasicService.getRelatedPolicies(params);
				request.setAttribute("gipiRelatedPoliciesTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));*/
				
				params.put("ACTION", "getRelatedPoliciesForViewPolicyInformation");
				Map<String, Object> relatedPoliciesTableGrid = TableGridUtil.getTableGrid(request, params);
				request.setAttribute("gipiRelatedPoliciesTableGrid", new JSONObject(relatedPoliciesTableGrid));
				request.setAttribute("issCdRI", gipiPolbasicService.getIssCdRI()); //hdrtagudin 07232015 SR 19751
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedPoliciesTable.jsp";
				
			}else if ("refreshRelatedPoliciesTableGrid".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getRelatedPoliciesForViewPolicyInformation");
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy")== "" ? null : Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", request.getParameter("polSeqNo")== "" ? null : Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", request.getParameter("renewNo")== "" ? null : Integer.parseInt(request.getParameter("renewNo")));
				Map<String, Object> relatedPoliciesTableGrid = TableGridUtil.getTableGrid(request, params);
				log.info("Getting page "+params.get("currentPage")+"...");
				JSONObject json = new JSONObject(relatedPoliciesTableGrid);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("showPolicyMainInfo".equals(ACTION)){
				log.info("Loading policy main information...");
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				HashMap<String, Object> policyMainInfo = gipiPolbasicService.getPolicyMainInformation(policyId);
				System.out.println("policyMainInfo: "+policyMainInfo);
				//request.setAttribute("policyMainInfo", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(policyMainInfo))); replaced by: Nica 05.22.2013
				request.setAttribute("policyMainInfo", new JSONObject((HashMap<String, Object>)StringFormatter.escapeHTMLInMap(policyMainInfo)));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/policyMainInformation.jsp";
				
			}else if ("showInfoBasic".equals(ACTION)){
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				String lineCd = request.getParameter("lineCd");
				GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService"); //robert 11.03.14
				String menuLineCd = giisLineService.getMenuLineCd(lineCd); //robert 11.03.14
				log.info("Loading policy basic information (policyId="+policyId+")...");
				request.setAttribute("moduleId", "GIPIS100"); // added by Kris 02.18.2013
				if("SU".equals(lineCd) || "SU".equals(menuLineCd)){ //robert 11.03.14 
					HashMap<String, Object> policyBasicInfoSu = gipiPolbasicService.getPolicyBasicInformationSu(policyId);
					//request.setAttribute("policyBasicInfoSu", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(policyBasicInfoSu))); replaced by: Nica 05.22.2013
					request.setAttribute("policyBasicInfoSu", new JSONObject((HashMap<String, Object>)StringFormatter.escapeHTMLInMap(policyBasicInfoSu)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyInfoBasicSu.jsp";
				}else{
					HashMap<String, Object> policyBasicInfo = gipiPolbasicService.getPolicyBasicInformation(policyId);
					request.setAttribute("policyBasicInfo", new JSONObject((HashMap<String, Object>)StringFormatter.escapeHTMLInMap(policyBasicInfo)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyInfoBasic.jsp";
				}
				
			}else if ("bondPolicyData".equals(ACTION)){ //Rey 08.16.2011 bond policy data
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));				
				GIPIPolbasic bondPolicyData = gipiPolbasicService.getBondPolicyData(policyId);
				
				if(bondPolicyData == null){
					request.setAttribute("bondPolicyData", new JSONObject());
				}
				else{
					request.setAttribute("bondPolicyData", new JSONObject(StringFormatter.escapeHTMLInObject(bondPolicyData)));
				}				
				request.setAttribute("policyId", policyId); //hdrtagudin 07232015 SR 19824
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/bondPolicyDetails.jsp";	
				
			}else if("getCoSignors".equals(ACTION)){ //Rey 08.16.2011 get co signors
				String polId = request.getParameter("policyId");
				Integer policyId = null;
				
				if((polId == null)||(polId == "")){
					policyId = null;
				}
				else{
					policyId = Integer.parseInt(request.getParameter("policyId"));
				}
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getCosignList");
				params.put("policyId", policyId);				
				System.out.println("polID="+params);
				System.out.println(params);
				Map<String, Object> coSignorsList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(coSignorsList);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "pages/genericMessage.jsp";
				}
				else{				
					request.setAttribute("coSignorsList", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/coSignors.jsp";
				}	
			}else if("getBondBill".equals(ACTION)){ //Rey Jadlocon 10-06-2011
				String polId = request.getParameter("policyId");
				Integer policyId = null;
				
				if((polId == null)||(polId == "")){
					policyId = null;
				}
				else{
					policyId = Integer.parseInt(request.getParameter("policyId"));
				}
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getBondBillTaxList");
				params.put("policyId", policyId);				
				
				Map<String, Object> bondBillTaxList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(bondBillTaxList);
				
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "pages/genericMessage.jsp";
				}
				else{				
					request.setAttribute("bondBillTaxList", json);
					request.setAttribute("policyId", policyId); //hdrtagudin 07232015 SR 19824
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/bondBillDetails.jsp";
				}
			}else if("getBondDetails".equals(ACTION)){ //Rey 10-11-2011
				String polId = request.getParameter("policyId");
				Integer policyId = null;
				
				if((polId == null)||(polId == "")){
					policyId = null;
				}
				else{
					policyId = Integer.parseInt(request.getParameter("policyId"));
				}
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getBondBillDetails");
				params.put("policyId", policyId);				
				
				Map<String, Object> bondDetails = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(bondDetails);
				
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "pages/genericMessage.jsp";
				}
				else{				
					request.setAttribute("bondDetails", json);
					request.setAttribute("policyId", policyId); //hdrtagudin 07232015 SR 19824
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/bondBillDetails2.jsp";
				}
				//START hdrtagudin 07232015 SR 19824	
			}else if ("getCommissionDetailsSu".equals(ACTION)){
							Integer policyId = Integer.parseInt(request.getParameter("policyId"));
							Integer premSeqNo = Integer.parseInt(request.getParameter("premSeqNo"));
							String lineCd = request.getParameter("lineCd");
						
							Map<String, Object> params = new HashMap<String, Object>();
							params.put("ACTION", "getBondIntermediaries");
							params.put("policyId", policyId);	
							params.put("premSeqNo", premSeqNo);	
							params.put("lineCd", lineCd);	
							log.info(params);
							Map<String, Object> bondCommissionDtls = TableGridUtil.getTableGrid(request, params);
							JSONObject json = new JSONObject(bondCommissionDtls);
							
							if("1".equals(request.getParameter("refresh"))){
								message = json.toString();
								PAGE = "pages/genericMessage.jsp";
							}
							else
							{
								log.info(json);
								request.setAttribute("commissionDtls", json);
								request.setAttribute("policyId", policyId);
								request.setAttribute("premSeqNo", premSeqNo);
								request.setAttribute("lineCd", lineCd);
								PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/bondCommissionDetails.jsp";
							}
			 //END hdrtagudin 07232015 SR 19824
			}else if ("showPolicyBillGroup".equals(ACTION)){
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyBillGroup.jsp";
				
			}else if ("getBankPaymentDtl".equals(ACTION)){
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				GIPIPolbasic polBankPaymentDtl = gipiPolbasicService.getBankPaymentDtl(policyId);
				
				if(polBankPaymentDtl != null){
					request.setAttribute("polBankPaymentDtl", new JSONObject(polBankPaymentDtl));
				}
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyBankPaymentDtl.jsp";
				
			}else if ("getBancassuranceDtl".equals(ACTION)){
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				GIPIPolbasic polBancassuranceDtl = gipiPolbasicService.getBancassuranceDtl(policyId);
				
				if(polBancassuranceDtl != null){
					request.setAttribute("polBancassuranceDtl", new JSONObject(polBancassuranceDtl));
				}
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyBancassuranceDtl.jsp";
				
			}else if ("getPlanDtl".equals(ACTION)){
				log.info("Getting plan details");
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				GIPIPolbasic polPlanDtl	= gipiPolbasicService.getPlanDtl(policyId);
				
				if(polPlanDtl != null){
					request.setAttribute("polPlanDtl", new JSONObject(polPlanDtl));
				}
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyPlanDtl.jsp";
				
			}else if("getPolicyEndtSeq0".equals(ACTION)){
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				HashMap<String, Object> policyEndtSeq0 = gipiPolbasicService.getPolicyEndtSeq0(policyId);
				StringFormatter.escapeHTMLInMap(policyEndtSeq0);
				request.setAttribute("policyEndtSeq0", new JSONObject(policyEndtSeq0));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/viewPolicyInformation.jsp";
				
			}else if("showPolicyDiscountTab".equals(ACTION)){ //Rey 08-08-2011 policy discount tab 
				Integer policyId = request.getParameter("policyId").equals("") ? 0 : Integer.parseInt(request.getParameter("policyId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "policyDiscountSurchargeList");
				params.put("policyId", policyId);
				
				Map<String, Object> policyDiscountList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(policyDiscountList); 
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
					request.setAttribute("policyDiscountList", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/subTab/policyDiscountSurchargeTab.jsp";					
				}			
			}else if("showItemDiscountTab".equals(ACTION)){ //Rey 08-08-2011 item discount tab 
				Integer policyId = request.getParameter("policyId").equals("") ? 0 : Integer.parseInt(request.getParameter("policyId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "itemDiscountSurchargeList");
				params.put("policyId", policyId);
				
				Map<String, Object> itemDiscountList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(itemDiscountList);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
					request.setAttribute("itemDiscountList", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/subTab/itemDiscountSurchargeTab.jsp";
				}				
			}else if("showPerilDiscountTab".equals(ACTION)){ //Rey 08-08-2011 peril discount tab 
				Integer policyId = request.getParameter("policyId").equals("") ? 0 : Integer.parseInt(request.getParameter("policyId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "perilDiscountSurchargeList");
				params.put("policyId", policyId);
				
				Map<String, Object> perilDiscountList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(perilDiscountList);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
					request.setAttribute("perilDiscountList", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/subTab/perilDiscountSurchargeTab.jsp";
				}
			}else if ("showCommissionDetails".equals(ACTION)){ //Rey 08-08-2011 commission details
				String lineCd = request.getParameter("lineCd");
				String issCd = request.getParameter("issCd");
				Integer premSeqNo = request.getParameter("premSeqNo").equals("") ? 0 : Integer.parseInt(request.getParameter("premSeqNo"));
				Integer intmNo = request.getParameter("intmNo").equals("") ? 0 : Integer.parseInt(request.getParameter("intmNo"));
				Integer perilCd = request.getParameter("perilCd").equals("") ? 0 : Integer.parseInt(request.getParameter("perilCd"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getCommissionDetails");
				params.put("lineCd", lineCd);
				params.put("issCd", issCd);
				params.put("premSeqNo", premSeqNo);
				params.put("intmNo", intmNo);
				params.put("perilCd", perilCd);
				
				Map<String, Object> commissionDetails = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(commissionDetails);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
					request.setAttribute("commissionDetailsList", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/commissionDetails.jsp";	
				}
			}else if("showByAssuredPage".equals(ACTION)){
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/byAssured.jsp";
			
			}else if("showByEndorsementTypePage".equals(ACTION)){ //Rey 07-19-2011
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/byEndorsementType.jsp";
			
			}else if("showPolicyAssuredOverLay".equals(ACTION)){
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyAssuredOverlay.jsp";
				
			}else if("showPolicyEndorsementTypeOverLay".equals(ACTION)){ //Rey 07-19-2011
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyEndorsementTypeOverlay.jsp";
				
			}else if("getPolicyListByAssured".equals(ACTION)){
				log.info("Getting policies by Assured");				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("userId", USER.getUserId()); // added by Gab 07.22.15
				params.put("moduleId", "GIPIS100");
				
				//modified by apollo cruz 03.18.2015 - replaced by codes below
				//params = gipiPolbasicService.getPolicyListByAssured(params);
				params.put("ACTION", "getPolicyPerAssured");
				params = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					//request.setAttribute("policyListByAssured", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params))); //apollo cruz 03.18.2015
					request.setAttribute("policyListByAssured", new JSONObject(params));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyByAssuredTable.jsp";
				}
			}else if("getPolicyListByEndorsementType".equals(ACTION)){ //Rey 07-19-2011
				log.info("Getting policies by Endorsement");				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("endtType", request.getParameter("endtType"));
				params = gipiPolbasicService.getPolicyListByEndorsementType(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("policyListByEndorsementType", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyByEndorsementTypeTable.jsp";
				}
			}else if ("showByAssuredAcctOfPage".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getPolicyByAssuredInAcctOf");
				
				Map<String, Object> policybyAssuredInAcctOf = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(policybyAssuredInAcctOf);

				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
					request.setAttribute("policyByAssureActOf", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/byAssuredAcctOf.jsp";	
				}
			}else if("showByObligeePage".equals(ACTION)){
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/byObligee.jsp";
			}else if("getPolicyListByObligee".equals(ACTION)){
				log.info("Getting policies by Obligee");				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("obligeeNo", request.getParameter("obligeeNo"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params = gipiPolbasicService.getPolicyListByObligee(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();		
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("policyListByObligee", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyByObligeeTable.jsp";
				}
			}else if ("showAnnualizedAmounts".equals(ACTION)){
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyAnnualizedAmounts.jsp";
				
			}else if ("getPolicyRenewals".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params = gipiPolbasicService.getPolicyRenewals(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("policyRenewalsList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyRenewalsList.jsp";
				}
				
			}else if ("getPolicyListingForCertPrinting".equals(ACTION) || "filterPolicyListingForCertPrinting".equals(ACTION)){
				Integer pageNo = Integer.parseInt(request.getParameter("pageNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("lineCd2", request.getParameter("lineCd2"));
				params.put("sublineCd2", request.getParameter("sublineCd2"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
				params.put("assdName", request.getParameter("assdName"));
				params.put("pageNo", pageNo);
				PaginatedList policyList = gipiPolbasicService.getPolicyListingForCertPrinting(params);
				StringFormatter.replaceQuotesInList(policyList);
				policyList.gotoPage(pageNo-1);
				message = "";
				if ("getPolicyListingForCertPrinting".equals(ACTION)){
					request.setAttribute("pageNo", pageNo);
					request.setAttribute("noOfPages", policyList.getNoOfPages());
					request.setAttribute("polbasicListing", new JSONArray(policyList));
					PAGE = "/pages/underwriting/reportsPrinting/policyCertificates/policyListingForCertPrinting.jsp";
				} else {
					request.setAttribute("object", new JSONArray(policyList));
					PAGE = "/pages/genericObject.jsp";
				}
			}else if ("getCertPolicyTableGridListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);	
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("endtLineCd", request.getParameter("endtLineCd"));
				params.put("endtSublineCd", request.getParameter("endtSublineCd"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
				params.put("assdName", request.getParameter("assdName"));
				Map<String, Object> policyTableGrid = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(policyTableGrid);	
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("certPolicyListing", json);
					PAGE = "/pages/underwriting/reportsPrinting/policyCertificates/policyTableGridForCert.jsp";
				}
			}else if ("getMarineDetails".equals(ACTION)){
				HashMap<String, Object> marineDetails = new HashMap<String, Object>();
				marineDetails.put("surveyAgentCd", request.getParameter("surveyAgentCd"));
				marineDetails.put("surveyAgent", request.getParameter("surveyAgent"));
				marineDetails.put("settlingAgentCd", request.getParameter("settlingAgentCd"));
				marineDetails.put("settlingAgent", request.getParameter("settlingAgent"));
				request.setAttribute("marineDetails", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(marineDetails)));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyMarineDetails.jsp";
				
			}else if ("getAdditionalInfo".equals(ACTION)){
				request.setAttribute("policyAdditionalInfo", new JSONObject(request.getParameter("paramPolicyBasicInfo")));
				//added by robert SR 20307 10.27.15
				if(request.getParameter("displayPrincipal").equals("Y")){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getAddlInfoPrincipalListing");
					params.put("summarySw", request.getParameter("summarySw"));
					params.put("policyId", request.getParameter("policyId"));
					params.put("extractId", request.getParameter("extractId"));
					params.put("pageSize", 3);
					params.put("principalType", "P");
					Map<String, Object> principalTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject principalTG = new JSONObject(principalTableGrid);
					request.setAttribute("principalTG", principalTG);
					params.put("principalType", "C");
					Map<String, Object> contractorTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject contractorTG = new JSONObject(contractorTableGrid);
					request.setAttribute("contractorTG", contractorTG);
				}
				//end robert SR 20307 10.27.15
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyAdditionalInfo.jsp";
				
			}else if ("showSUAddtlInfo".equals(ACTION)) {
				String reportId = request.getParameter("reportId");
				request.setAttribute("sublineCd", request.getParameter("sublineCd"));
				request.setAttribute("reportId", reportId);
				
				if(reportId.equals("POLICY_SU")){
					GIISParameterFacadeService giisParameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					request.setAttribute("sysdate", giisParameterService.getFormattedSysdate());
					request.setAttribute("regDeedNo", request.getParameter("regDeedNo"));
					request.setAttribute("regDeed", request.getParameter("regDeed"));
					request.setAttribute("dateIssued", request.getParameter("dateIssued"));
					request.setAttribute("bondTitle", request.getParameter("bondTitle"));
					request.setAttribute("reason", request.getParameter("reason"));
					request.setAttribute("savingsAcctNo", request.getParameter("savingsAcctNo"));
					request.setAttribute("caseNo", request.getParameter("caseNo"));
					request.setAttribute("versusA", request.getParameter("versusA"));
					request.setAttribute("versusB", request.getParameter("versusB"));
					request.setAttribute("versusC", request.getParameter("versusC"));
					request.setAttribute("sheriffLoc", request.getParameter("sheriffLoc"));
					request.setAttribute("judge", request.getParameter("judge"));
					request.setAttribute("partA", request.getParameter("partA"));
					request.setAttribute("partB", request.getParameter("partB"));
					request.setAttribute("partC", request.getParameter("partC"));
					request.setAttribute("partD", request.getParameter("partD"));
					request.setAttribute("partE", request.getParameter("partE"));
					request.setAttribute("partF", request.getParameter("partF"));
					request.setAttribute("branch", request.getParameter("branch"));
					request.setAttribute("branchLoc", request.getParameter("branchLoc"));
					request.setAttribute("appDate", request.getParameter("appDate"));
					request.setAttribute("guardian", request.getParameter("guardian"));
					request.setAttribute("signAJCL5", request.getParameter("signAJCL5"));
					request.setAttribute("signBJCL5", request.getParameter("signBJCL5"));
					request.setAttribute("complainant", request.getParameter("complainant"));
					request.setAttribute("versus", request.getParameter("versus"));
					request.setAttribute("section", request.getParameter("section"));
					request.setAttribute("rule", request.getParameter("rule"));
					request.setAttribute("signatory", request.getParameter("signatory"));
				} else {
					request.setAttribute("period", request.getParameter("period"));
					request.setAttribute("signA", request.getParameter("signA"));
					request.setAttribute("signB", request.getParameter("signB"));
					request.setAttribute("ackLoc", request.getParameter("ackLoc"));
					request.setAttribute("docNo", request.getParameter("docNo"));
					request.setAttribute("ackDate", request.getParameter("ackDate"));
					request.setAttribute("pageNo", request.getParameter("pageNo"));
					request.setAttribute("bookNo", request.getParameter("bookNo"));
					request.setAttribute("series", request.getParameter("series"));
				}
				PAGE = "/pages/underwriting/reportsPrinting/policyPrintingAddtl/polPrintingAddtlInfo.jsp";

			}else if("getBillPerilList".equals(ACTION)){ //Rey 08-04-2011 bill peril list
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("ACTION", "getBillPerilList");
				params.put("policyId", policyId);
				params.put("itemNo", request.getParameter("itemNo").equals("") ? 0 : Integer.parseInt(request.getParameter("itemNo")));
				params.put("itemGrp", request.getParameter("itemGrp").equals("") ? 0 : Integer.parseInt(request.getParameter("itemGrp")));
				
				Map<String, Object> billPremium = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(billPremium);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
					request.setAttribute("billPremiumList", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyBillPerilList.jsp";				
				}				
			}else if("getBillTaxList".equals(ACTION)){ //Rey 08-04-2011 bill tax list
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("ACTION", "getBillTaxList");
				params.put("policyId", policyId);
				params.put("itemNo", request.getParameter("itemNo").equals("") ? 0 : Integer.parseInt(request.getParameter("itemNo")));
				params.put("itemGrp", request.getParameter("itemGrp").equals("") ? 0 : Integer.parseInt(request.getParameter("itemGrp")));
				
				Map<String, Object> billTaxList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(billTaxList);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
					request.setAttribute("billPremiumTaxList", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyBillTaxList.jsp";
				}

			}else if("getPaymentSchedule".equals(ACTION)){ //Rey 08-05-2011 payment schedule
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("ACTION", "getPaymentSchedule");
				params.put("policyId", policyId);
				params.put("itemNo", request.getParameter("itemNo").equals("") ? 0 : Integer.parseInt(request.getParameter("itemNo")));
				params.put("itemGrp", request.getParameter("itemGrp").equals("") ? 0 : Integer.parseInt(request.getParameter("itemGrp")));
				
				Map<String, Object> paymentSchedule = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(paymentSchedule);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
					request.setAttribute("billPaymentSchedule", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyPaymentSchedule.jsp";				
				}				
			}else if("getInvoiceCommission".equals(ACTION)){ //Rey 08-05-2011 invoice commission
				Integer policyId = request.getParameter("policyId").equals("") ? 0 : Integer.parseInt(request.getParameter("policyId"));
				Integer premSeqNo = request.getParameter("premSeqNo").equals("") ? 0 : Integer.parseInt(request.getParameter("premSeqNo"));
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getInvoiceCommission");
				params.put("policyId", policyId);
				params.put("premSeqNo", premSeqNo);
				params.put("lineCd", lineCd);
				params.put("intmNo", request.getParameter("intmNo").equals("") ? 0 : Integer.parseInt(request.getParameter("intmNo")));
				Map<String, Object> invoiceCommission = TableGridUtil.getTableGrid(request, params);
				
				JSONObject json = new JSONObject(invoiceCommission);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				else{
					request.setAttribute("invoiceCommissionList", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyInvoiceCommission.jsp";				
				}
			}else if("getInvoiceIntermediaries".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();	
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId").equals("") ? 0 : Integer.parseInt(request.getParameter("policyId")));
				params.put("premSeqNo", request.getParameter("premSeqNo").equals("") ? 0 : Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("lineCd", request.getParameter("lineCd"));
				Map<String, Object> invoiceIntermediary = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(invoiceIntermediary);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("lineCd", request.getParameter("lineCd"));
					request.setAttribute("invoiceIntmTableGrid", json);
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyInvoiceCommission.jsp";
				}
			}else if("getDiscountSurcharge".equals(ACTION)){ //Rey 08-03-2011 bill tax list
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyDiscountSurcharge.jsp";				

			}else if ("getPolicyNo".equals(ACTION)) {
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").toString().isEmpty() ? "0" : request.getParameter("policyId").toString()));
				message = gipiPolbasicService.getPolicyNo(policyId);
				PAGE = "/pages/genericMessage.jsp";

			}else if ("showRedistributionPage".equals(ACTION)) {
				PAGE = "/pages/underwriting/distribution/redistribution/redistribution.jsp";
			}else if("showPolicyListingForRedistribution".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = gipiPolbasicService.getPolicyListingForRedistribution(params);
				request.setAttribute("gipiPolbasicTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("refreshAction", "refreshRedistributionPolicyList");
				PAGE = "/pages/underwriting/distribution/redistribution/gipiPolbasicListing.jsp";
			}else if("refreshRedistributionPolicyList".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params = gipiPolbasicService.getPolicyListingForRedistribution(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("executeGIUWS012V370PostQuery".equals(ACTION)) {
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				
				gipiPolbasicService.executeGIUWS012V370PostQuery(params);
				
				message = new JSONObject(StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkReinsurancePaymentForRedistribution".equals(ACTION)) {
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				String lineCd = request.getParameter("lineCd");
				message = gipiPolbasicService.checkReinsurancePaymentForRedistribution(policyId, lineCd);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getRefPolNo".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				message = gipiPolbasicService.getRefPolNo(params);
				System.out.println("Retrieved Ref Pol No: "+message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkPolicyGiexs006".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				Debug.print("checkPolicyGiexs006 params:" + params);
				
				List<GIPIPolbasic> resultParams = gipiPolbasicService.checkPolicyGiexs006(params);
				Debug.print("getPolicyId resultParams:" + resultParams);
				
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGIPIS131".equals(ACTION)){ //Pol Cruz 4.11.2013
				//System.out.println("onSearch ::::: " + request.getParameter("onSearch"));
				if("1".equals(request.getParameter("onSearch"))){
					JSONObject jsonParStatus = gipiPolbasicService.showGIPIS131(request, USER);
					if("1".equals(request.getParameter("refresh"))){
						message = jsonParStatus.toString();
						PAGE = "/pages/genericMessage.jsp";
					}else{
						request.setAttribute("jsonParStatus", jsonParStatus);
						PAGE = "/pages/underwriting/policyInquiries/parStatus/parStatus.jsp";				
					}
				} else {
					JSONObject jsonParStatus = gipiPolbasicService.showGIPIS131(request, USER);
					request.setAttribute("jsonParStatus", jsonParStatus);
					//request.setAttribute("jsonParStatus", "[]");
					PAGE = "/pages/underwriting/policyInquiries/parStatus/parStatus.jsp";
				}
			} else if("showGipis131ParStatusHistory".equals(ACTION)) {
				JSONObject jsonParStatHistory = gipiPolbasicService.showGipis131ParStatusHistory(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonParStatHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonParStatHistory", jsonParStatHistory);
					PAGE = "/pages/underwriting/policyInquiries/parStatus/parHistory.jsp";				
				}
			} else if ("showGIPIS132".equals(ACTION)){ //Pol Cruz 04.16.2013
				if("1".equals(request.getParameter("onSearch"))){
					JSONObject jsonPolicyStatus = gipiPolbasicService.showGIPIS132(request, USER);
					if("1".equals(request.getParameter("refresh"))){
						message = jsonPolicyStatus.toString();
						PAGE = "/pages/genericMessage.jsp";
					}else{
						request.setAttribute("jsonPolicyStatus", jsonPolicyStatus);
						PAGE = "/pages/underwriting/policyInquiries/policyStatus/policyStatus.jsp";				
					}
				} else {
					request.setAttribute("jsonPolicyStatus", "[]");
					PAGE = "/pages/underwriting/policyInquiries/policyStatus/policyStatus.jsp";
				}
			} else if("showViewDistributionStatus".equals(ACTION)){ //Joms Diago 04.29.2013
				JSONObject json = gipiPolbasicService.showViewDistributionStatus(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatus.jsp";					
				}
				request.setAttribute("userId", USER.getUserId());
			} else if("viewHistory".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewHistory(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonParStatHistory", json);
					PAGE = "/pages/pop-ups/policyHistory.jsp";					
				}
				request.setAttribute("parId", request.getParameter("parId"));
			} else if("viewDistribution".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewDistribution(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatusOverlay/policyDistributionOverlay.jsp";					
				} 
				request.setAttribute("parId", request.getParameter("parId"));
				request.setAttribute("distNo", request.getParameter("distNo"));
				request.setAttribute("distFlag", request.getParameter("distFlag"));
				request.setAttribute("policyNo", request.getParameter("policyNo"));
				request.setAttribute("policyStatus", request.getParameter("policyStatus"));
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				request.setAttribute("sublineCd", request.getParameter("sublineCd"));
				request.setAttribute("issCd", request.getParameter("issCd"));
				request.setAttribute("issueYy", request.getParameter("issueYy"));
				request.setAttribute("polSeqNo", request.getParameter("polSeqNo"));
				request.setAttribute("renewNo", request.getParameter("renewNo"));
			} else if("viewDistributionPerItem".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewDistribution(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatusOverlay/policyDistributionItem.jsp";					
				} 
				request.setAttribute("parId", request.getParameter("parId"));
				request.setAttribute("distNo", request.getParameter("distNo"));
				request.setAttribute("distFlag", request.getParameter("distFlag"));
				request.setAttribute("policyNo", request.getParameter("policyNo"));
				request.setAttribute("policyStatus", request.getParameter("policyStatus"));
			} else if("viewRIPlacement".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewRIPlacement(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatusOverlay/policyRIPlacement.jsp";					
				} 
				request.setAttribute("distNo", request.getParameter("distNo"));
				request.setAttribute("distSeqNo", request.getParameter("distSeqNo"));
				request.setAttribute("placementSource", request.getParameter("placementSource"));
			} else if("getDistDtl".equals(ACTION)){
				JSONObject json = gipiPolbasicService.getDistDtl(request, USER);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getDistDtl2".equals(ACTION)){
				JSONObject json = gipiPolbasicService.getDistDtl2(request, USER);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getMainPolicyId".equals(ACTION)){
				request.setAttribute("object", gipiPolbasicService.getMainPolicyId(request));
				PAGE = "/pages/genericObject.jsp";
			}else if("gipis100ExtractSummary".equals(ACTION)){
				Map<String, Object> params = gipiPolbasicService.gipis100ExtractSummary(request, USER);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(params));
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			} else if("viewSummarizedDist".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewSummarizedDist(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatusOverlay/summarizedDistribution.jsp";					
				}
			} else if("callExtractDistGipis130".equals(ACTION)){
				message = gipiPolbasicService.callExtractDistGipis130(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("onLoadSummarizedDist".equals(ACTION)){
				message = gipiPolbasicService.onLoadSummarizedDist(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("viewRiPlacement".equals(ACTION)){
				PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatusOverlay/summarizedDistOverlay/riPlacement.jsp";					
			} else if("viewSummDistRiPlacement".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewSummDistRiPlacement(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatusOverlay/summarizedDistOverlay/riPlacement.jsp";					
				}
			} else if("viewBinder".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewBinder(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatusOverlay/summarizedDistOverlay/binder.jsp";					
				}
			} else if("viewDistPerItem".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewDistPerItem(request, USER);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("viewDistItem".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewDistItem(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatusOverlay/summarizedDistOverlay/distributionPerItem.jsp";					
				}
			} else if("viewDistPeril".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewDistPeril(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/distributionStatus/distributionStatusOverlay/summarizedDistOverlay/distributionPerPeril.jsp";					
				}
			} else if("viewDistPerPeril".equals(ACTION)){
				JSONObject json = gipiPolbasicService.viewDistPerPeril(request, USER);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("insertSummDist".equals(ACTION)){
				message = gipiPolbasicService.insertSummDist(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("showReinstateHistory".equals(ACTION)) {
				JSONObject jsonReinstatementHistory = gipiPolbasicService.showReinstateHistory(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonReinstatementHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonReinstatementHistory", jsonReinstatementHistory);
					request.setAttribute("policyId", request.getParameter("policyId"));
					PAGE = "/pages/underwriting/utilities/spoilageReinstatement/policyReinstatement/reinstatementHistory.jsp";				
				}
			} else if ("getGIPIS156BasicInfo".equals(ACTION)){
				request.setAttribute("object", gipiPolbasicService.getGIPIS156BasicInfo(request));
				PAGE = "/pages/genericObject.jsp";
			}else if("showViewVesselAccumulation".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showViewVesselAccumulation(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonVesselAccumulation", jsonObj);
					PAGE = "/pages/underwriting/policyInquiries/vesselAccumulation/vesselAccumulation.jsp";				
				}
			}else if("showVesselAccumulationDtl".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showVesselAccumulationDtl(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonExposures", jsonObj);
					PAGE = "/pages/underwriting/policyInquiries/vesselAccumulation/pop-ups/vesselAccumulationDtl.jsp";				
				}
			}else if("showShareExposures".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showShareExposures(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonShareExposures", jsonObj);
					request.setAttribute("shareMode", request.getParameter("shareMode"));
					request.setAttribute("rvLowValue", request.getParameter("rvLowValue"));
					PAGE = "/pages/underwriting/policyInquiries/vesselAccumulation/pop-ups/vesselShareExposures.jsp";				
				}
			}else if("showItemActualExposures".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showActualExposures(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonItemActualExposures", jsonObj);
					request.setAttribute("shareCd", request.getParameter("shareCd"));
					request.setAttribute("all", request.getParameter("all"));
					request.setAttribute("mode", request.getParameter("mode"));
					PAGE = "/pages/underwriting/policyInquiries/vesselAccumulation/pop-ups/vesselItemActualExposures.jsp";				
				}
			}else if("showItemTemporaryExposures".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showTemporaryExposures(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonItemTemporaryExposures", jsonObj);
					request.setAttribute("shareCd", request.getParameter("shareCd"));
					request.setAttribute("all", request.getParameter("all"));
					request.setAttribute("mode", request.getParameter("mode"));
					PAGE = "/pages/underwriting/policyInquiries/vesselAccumulation/pop-ups/vesselItemTemporaryExposures.jsp";				
				}
			} else if("showRecapsVI".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				
				PAGE = "/pages/accounting/generalLedger/report/recapsVI/recapitulationVI.jsp";
			} else if("extractRecapsVI".equals(ACTION)){
				message = gipiPolbasicService.extractRecapsVI(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkExtractedRecordsBeforePrint".equals(ACTION)){
				message = gipiPolbasicService.checkExtractedRecordsBeforePrint(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkRecapsVIBeforeExtract".equals(ACTION)){ /* benjo 06.01.2015 GENQA AFPGEN_IMPLEM SR 4150 */
				request.setAttribute("object", new JSONObject(gipiPolbasicService.checkRecapsVIBeforeExtract(request, USER)));
				PAGE = "/pages/genericObject.jsp";
			} else if("showRecapRegionDetails".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String type = request.getParameter("type");
				
				params.put("ACTION", "getGipis203RegionList");
				params.put("recapDtlType", type);
				Map<String, Object> regionTableGrid = TableGridUtil.getTableGrid(request, params);			
				JSONObject jsonRegion = new JSONObject(regionTableGrid);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonRegion.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("recapRegionList", jsonRegion);
					PAGE = "/pages/accounting/generalLedger/report/recapsVI/popups/recapPremDetails.jsp";
				}
			} else if("showRecapDetails".equals(ACTION)){
				String type = request.getParameter("type");
				Map<String, Object> params = new HashMap<String, Object>();
				
				if(type.equals("premium")){
					params.put("ACTION", "getGipis203RecapPremList");
				} else if(type.equals("losses")){
					params.put("ACTION", "getGipis203RecapLossList");
				}
				params.put("regionCd", request.getParameter("regionCd"));
				params.put("indGrpCd", request.getParameter("indGrpCd"));
				
				Map<String, Object> recapList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = recapList != null ? new JSONObject(recapList) : new JSONObject();
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					params.put("ACTION", "getGipis203RegionList");
					params.put("recapDtlType", type);
					Map<String, Object> regionTableGrid = TableGridUtil.getTableGrid(request, params);			
					JSONObject jsonRegion = new JSONObject(regionTableGrid);
					
					request.setAttribute("recapRegionList", jsonRegion);
					request.setAttribute("recapDtlList", json);
					request.setAttribute("recapDtlType", type);
					
					PAGE = "/pages/accounting/generalLedger/report/recapsVI/popups/recapPremDetails.jsp";
				}				
			} else if("showPackagePolicyInformation".equals(ACTION)){ //John Dolon 9.2.2013
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("packPolId", request.getParameter("packPolId"));
				JSONObject jsonpackagePolicyTable = gipiPolbasicService.showPackagePolicyInformation(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonpackagePolicyTable.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonpackagePolicyTable", jsonpackagePolicyTable);
					PAGE = "/pages/underwriting/policyInquiries/packagePolicyInformation/packagePolicyInformation.jsp";						
				}
			} else if("showPackagePolicyItem".equals(ACTION)){ //John Dolon 9.2.2013
				request.setAttribute("packPolId", request.getParameter("packPolId"));
				JSONObject json = gipiPolbasicService.showPackagePolicyItem(request, USER);
				request.setAttribute("json", json);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/packagePolicyInformation/overlay/packagePolicyItem.jsp";					
				}
			//START hdrtagudin 07302015 SR 18751
			} else if("showInitialAcceptance".equals(ACTION)){
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").isEmpty() ? "0" : request.getParameter("policyId")));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", policyId);
				JSONObject json = gipiPolbasicService.getInitialAcceptance(params);
				request.setAttribute("json", json);
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/viewInitialAcceptance.jsp";
			//END hdrtagudin 07302015 SR 18751
			} else if("showViewExposuresPerPAEnrollees".equals(ACTION)){
				JSONObject json = gipiPolbasicService.showViewExposuresPerPAEnrollees(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("exposureList", json);
					PAGE = "/pages/underwriting/policyInquiries/paInquiries/viewExposuresPerPAEnrollees.jsp";
				}
			}else if("showViewIntermediaryCommission".equals(ACTION)){
				JSONObject json = gipiPolbasicService.showViewIntermediaryCommission(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonIntermediaryComm", json);
					request.setAttribute("dispOverridingComm", giisParametersService.getParamValueV2("DISPLAY_OVERRIDING_COMM"));
					PAGE = "/pages/underwriting/policyInquiries/intermediaryCommission/intermediaryCommission.jsp";
				}	
			}else if("getGipis139PerilDetail".equals(ACTION)){
				JSONObject json = gipiPolbasicService.showIntermediaryCommissionlOverlay(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonPerilDtl", json);
					PAGE = "/pages/underwriting/policyInquiries/intermediaryCommission/pop-ups/perilDtlOverlay.jsp";
				}		
			}else if("getGipis139CommDetail".equals(ACTION)){
				JSONObject json = gipiPolbasicService.showIntermediaryCommissionlOverlay(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonCommDtl", json);
					PAGE = "/pages/underwriting/policyInquiries/intermediaryCommission/pop-ups/commDtlOverlay.jsp";
				}		
			} else if ("getMotorCarInquiryRecords".equals(ACTION)){ //Kenneth L. 09.11.2013
				JSONObject jsonMotorTable = gipiPolbasicService.getMotorCarInquiryRecords(request, USER);
					if("1".equals(request.getParameter("refresh"))){
						message = jsonMotorTable.toString();
						PAGE = "/pages/genericMessage.jsp";
					}else{
						request.setAttribute("jsonMotorTable", jsonMotorTable);
						PAGE = "/pages/underwriting/policyInquiries/motorCarInquiries/motorCarPolicy/motorCarInquiry.jsp";
					}
			} else if ("getMotorCarPolicyInfo".equals(ACTION)){ //Kenneth L. 09.11.2013
				PAGE = "/pages/underwriting/policyInquiries/motorCarInquiries/motorCarPolicy/motorCarPolicyInformation.jsp";
			} else if ("showUpdateInwardRIComm".equals(ACTION)){
				PAGE = "/pages/underwriting/reInsurance/updateInwardRIComm/updateInwardRIComm.jsp";
			} else if ("saveGIPIS175".equals(ACTION)) {
				gipiPolbasicService.saveGIPIS175(request, USER.getUserId());
			} else if("showViewCasualtyAccumulation".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showViewCasualtyAccumulation(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonCasualtyAccumulation", jsonObj);
					PAGE = "/pages/underwriting/policyInquiries/propertyFloaterAccumulation/propertyFloaterAccumulation.jsp";				
				}
			}else if("showCasualtyAccumulationDtl".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showCasualtyAccumulationDtl(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonExposures", jsonObj);
					PAGE = "/pages/underwriting/policyInquiries/propertyFloaterAccumulation/pop-ups/propertyFloaterAccumulationDtl.jsp";				
				}
			}else if("showGipis111ActualExposures".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showGipis111ActualExposures(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonItemActualExposures", jsonObj);
					request.setAttribute("mode", request.getParameter("mode"));
					PAGE = "/pages/underwriting/policyInquiries/propertyFloaterAccumulation/pop-ups/propertyFloaterActualExposures.jsp";				
				}
			}else if("showGipis111TemporaryExposures".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showGipis111TemporaryExposures(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonItemTemporaryExposures", jsonObj);
					request.setAttribute("mode", request.getParameter("mode"));
					PAGE = "/pages/underwriting/policyInquiries/propertyFloaterAccumulation/pop-ups/propertyFloaterTemporaryExposures.jsp";				
				}
			}  else if ("showViewUserInformation".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getUserInformationList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/userInformation/viewUserInformation.jsp";
				}
			} else if ("getTranList".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getTranList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/userInformation/subPages/userInfoTransactions.jsp";
				}
			} else if ("getTranIssList".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getTranIssList(request, USER);
				//if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				//}
			} else if ("getTranLineList".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getTranLineList(request, USER);
				//if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				//}
			} else if ("getModuleList".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getModuleList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/userInformation/subPages/userInfoModules.jsp";
				}	
			} else if ("getGrpTranList".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getGrpTranList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/userInformation/subPages/userInfoTransactions.jsp";
				}	
			} else if ("getGrpTranIssList".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getGrpTranIssList(request, USER);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getGrpTranLineList".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getGrpTranLineList(request, USER);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";		
			} else if ("getGrpModuleList".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getGrpModuleList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/userInformation/subPages/userInfoModules.jsp";
				}		
			} else if ("getHistoryList".equals(ACTION)) {
				JSONObject json = gipiPolbasicService.getHistoryList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/userInformation/subPages/userInfoHistory.jsp";
				}				
			}else if("showViewBlockAccumulation".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showViewBlockAccumulation(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonBlockAccumulation", jsonObj);
					request.setAttribute("fiAccess", gipiPolbasicService.gipis110CheckFiAccess(USER.getUserId()));
					PAGE = "/pages/underwriting/policyInquiries/blockAccumulation/blockAccumulation.jsp";				
				}
			}else if("showBlockAccumulationDtl".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showBlockAccumulationDtl(request,USER.getUserId());
				JSONObject jsonObj1 = gipiPolbasicService.showBlockRisk(request,USER.getUserId()); //nieko 07132016 kb 894
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					message = jsonObj1.toString(); //nieko 07132016 kb 894
					PAGE = "/pages/genericMessage.jsp";
				}else{
					//request.setAttribute("jsonExposures", jsonObj); //nieko 07132016 kb 894
					request.setAttribute("jsonBlockRisk", jsonObj1); //nieko 07132016 kb 894
					PAGE = "/pages/underwriting/policyInquiries/blockAccumulation/pop-ups/blockAccumulationDtl.jsp";				
				}
			}else if("showBlockRiskDtl".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGipis110GiisBlocRiskkDtl");	
				
				params.put("blockId", request.getParameter("blockId"));
				params.put("excludeNotEff", request.getParameter("excludeNotEff"));
				params.put("exclude", request.getParameter("exclude"));
				params.put("userId", USER.getUserId());
				params.put("districtNo", request.getParameter("districtNo"));
				params.put("blockNo", request.getParameter("blockNo"));
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("city", request.getParameter("city"));
				params.put("riskCd", request.getParameter("riskCd"));
				params.put("busType", request.getParameter("busType"));
				
				params = TableGridUtil.getTableGrid(request, params);
				String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				message = grid;
			}else if("showBlockShareExposures".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showBlockShareExposures(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonShareExposures", jsonObj);
					request.setAttribute("shareMode", request.getParameter("shareMode"));
					request.setAttribute("rvLowValue", request.getParameter("rvLowValue"));
					PAGE = "/pages/underwriting/policyInquiries/blockAccumulation/pop-ups/blockShareExposures.jsp";				
				}
			}else if("showGipis110ActualExposures".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showGipis110ActualExposures(request,USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonItemActualExposures", jsonObj);
					request.setAttribute("shareType", request.getParameter("shareType"));
					request.setAttribute("all", request.getParameter("all"));
					request.setAttribute("mode", request.getParameter("mode"));
					PAGE = "/pages/underwriting/policyInquiries/blockAccumulation/pop-ups/blockActualExposures.jsp";				
				}
			}else if("showGipis110TemporaryExposures".equals(ACTION)) {
				JSONObject jsonObj = gipiPolbasicService.showGipis110TemporaryExposures(request,USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = jsonObj.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonItemTemporaryExposures", jsonObj);
					request.setAttribute("shareType", request.getParameter("shareType"));
					request.setAttribute("all", request.getParameter("all"));
					request.setAttribute("mode", request.getParameter("mode"));
					PAGE = "/pages/underwriting/policyInquiries/blockAccumulation/pop-ups/blockTemporaryExposures.jsp";				
				}
			} else if ("getProductionList".equals(ACTION)) {				
				PAGE = "/pages/underwriting/policyInquiries/production/production.jsp";						
			}else if("showDiscountSurcharge".equals(ACTION)){
				JSONObject jsonDiscSurc = gipiPolbasicService.getDiscountSurcharge(request, USER);				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonDiscSurc.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonDiscSurc", jsonDiscSurc);
					PAGE = "/pages/underwriting/policyInquiries/discountSurcharge/viewDiscountSurcharge.jsp";
				}	
			}else if ("getProductionDetails".equals(ACTION)) {				
				JSONObject jsonProductionDetails = gipiPolbasicService.getProductionDetails(request, USER);				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonProductionDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonProductionDetails", jsonProductionDetails);
					PAGE = "/pages/underwriting/policyInquiries/production/productionDetails/productionDetails.jsp";
				}		
			}else if("validateGIPIS201Access".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = gipiPolbasicService.validateGIPIS201Access(request,USER);	
				JSONObject result = new JSONObject(params);
				message = result.toString();		
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getProdPolicyDetails".equals(ACTION)) {				
				JSONObject jsonProdPolicyDetails = gipiPolbasicService.getProdPolicyDetails(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonProdPolicyDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonProdPolicyDetails", jsonProdPolicyDetails);
					PAGE = "/pages/underwriting/policyInquiries/production/productionDetails/policyDetails/policyDetails.jsp";
				}		
			}else if("validateGIPIS201DisplayORC".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = gipiPolbasicService.validateGIPIS201DisplayORC(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();		
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGIPIS201CommDtls".equals(ACTION)){				
				JSONObject jsonCommDetails = gipiPolbasicService.getGIPIS201CommDtls(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCommDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{					
					request.setAttribute("jsonCommDetails", jsonCommDetails);	
					request.setAttribute("issCd", request.getParameter("issCd"));
					request.setAttribute("lineCd", request.getParameter("lineCd"));
					request.setAttribute("policyId", request.getParameter("policyId"));
					request.setAttribute("intmNo", request.getParameter("intmNo"));
					PAGE = "/pages/underwriting/policyInquiries/production/productionDetails/policyDetails/commissionDetails.jsp";
				}		
			}else if("showDiscSurcDetail".equals(ACTION)){
				JSONObject jsonDiscSurcDtl = gipiPolbasicService.getDiscSurcDetails(request, USER);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonDiscSurcDtl.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{					
					request.setAttribute("jsonDiscSurcDtl", jsonDiscSurcDtl);	
					String pge = request.getParameter("pge");
					PAGE = "/pages/underwriting/policyInquiries/discountSurcharge/subPages/"+pge+".jsp";
				}		
			}else if("getEndtTypeList".equals(ACTION)){
				JSONObject jsonEndtTypeList = gipiPolbasicService.showEndtTypeList(request);
				message = jsonEndtTypeList.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkViewProdDtls".equals(ACTION)) {				
				log.info("Processing information, please wait...");				
				JSONObject result = gipiPolbasicService.checkViewProdDtls(request, USER.getUserId());
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";			
			}else if ("extractProduction".equals(ACTION)) {				
				log.info("Extracting records...");				
				JSONObject result = gipiPolbasicService.extractProduction(request, USER.getUserId());
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";		
			} else if("getEndtPolicyDatesAfterCancel".equals(ACTION)){
				JSONObject json = gipiPolbasicService.getEndtPolicyDates(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getGIPIS156BasicInfo".equals(ACTION)){
				request.setAttribute("object", gipiPolbasicService.getGIPIS156BasicInfo(request));
				PAGE = "/pages/genericObject.jsp";
			} else if("refreshEnPrincipalContractorTG".equals(ACTION)){ //added by robert SR 20307 10.27.15
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getAddlInfoPrincipalListing");
				params.put("policyId", request.getParameter("policyId"));
				params.put("extractId", request.getParameter("extractId"));
				params.put("principalType", request.getParameter("principalType"));
				params.put("summarySw", request.getParameter("summarySw"));
				params.put("pageSize", 3);
				Map<String, Object> principalTableGrid = TableGridUtil.getTableGrid(request, params);	
				JSONObject json = new JSONObject(principalTableGrid);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";	
		} catch (NullPointerException e) {
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
}
