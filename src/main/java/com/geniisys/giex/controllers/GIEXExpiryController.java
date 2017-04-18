package com.geniisys.giex.controllers;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
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

import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISISSource;
import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISSubline;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISAssuredFacadeService;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISIntermediaryService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISParameterService;		 //Gzelle 06242015 SR3920
import com.geniisys.common.service.GIISSublineFacadeService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.entity.GIEXExpiry;
import com.geniisys.giex.service.GIEXExpiryService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIEXExpiryController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIEXExpiryController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIEXExpiryService giexExpiryService = (GIEXExpiryService) APPLICATION_CONTEXT.getBean("giexExpiryService");
			GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
			
			if ("showExtractExpiringPoliciesPage".equals(ACTION)){
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");	 //Gzelle 06242015 SR3920
				request.setAttribute("allowRenCredBrExtrct", giisParameterService.getParamValueV2("ALLOW_REN_CRED_BR_EXTRACT")); 		 //Gzelle 06242015 SR3920
				PAGE = "/pages/underwriting/renewalProcessing/extractExpiringPolicies/extractExpiringPolicies.jsp";
			}else if("getExtractionHistory".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("userId", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				Map<String, Object> extractionHistoryTableGrid = TableGridUtil.getTableGrid(request, params);				
				
				JSONObject json = new JSONObject(extractionHistoryTableGrid);				
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("extractionHistoryTableGrid", json);
					request.setAttribute("refreshAction","getExtractionHistory&refresh=1");
					PAGE = "/pages/underwriting/renewalProcessing/extractExpiringPolicies/subPages/extractionHistoryListing.jsp";
				}
			}else if("getAllExtractionHistory".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("userId", "");
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				Map<String, Object> extractionHistoryTableGrid = TableGridUtil.getTableGrid(request, params);				
				
				JSONObject json = new JSONObject(extractionHistoryTableGrid);				
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("extractionHistoryTableGrid", json);
					request.setAttribute("refreshAction","getAllExtractionHistory&refresh=1");
					PAGE = "/pages/underwriting/renewalProcessing/extractExpiringPolicies/subPages/extractionHistoryListing.jsp";
				}
			} else if ("getLastExtractionHistory".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				String moduleId = request.getParameter("moduleId") == null ? "" : request.getParameter("moduleId");
				params.put("moduleId", moduleId);
				params = giexExpiryService.getLastExtractionHistory(params);
				String extractUser = (String) (params.get("extractUser") == null ? "" : params.get("extractUser"));
				String extractDate = (String) (params.get("extractDate") == null ? "" : params.get("extractDate"));
				String issRi = (String) (params.get("issRi") == null ? "" : params.get("issRi"));
				message= extractUser + "," + extractDate + "," +issRi;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("extractExpiringPolicies".equals(ACTION) || "extractExpiringPoliciesFinal".equals(ACTION) ) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fmMon", request.getParameter("fmMon") == null ? "" : request.getParameter("fmMon"));
				params.put("fmYear", request.getParameter("fmYear") == null ? "" : request.getParameter("fmYear"));
				params.put("toMon", request.getParameter("toMon") == null ? "" : request.getParameter("toMon"));
				params.put("toYear", request.getParameter("toYear") == null ? "" : request.getParameter("toYear"));
				params.put("fmDate", request.getParameter("fmDate") == null ? "" : request.getParameter("fmDate"));
				params.put("toDate", request.getParameter("toDate") == null ? "" : request.getParameter("toDate"));
				params.put("rangeType", request.getParameter("rangeType") == null ? "" : request.getParameter("rangeType"));
				params.put("range", request.getParameter("range") == null ? "" : request.getParameter("range"));
				params.put("polLineCd", request.getParameter("polLineCd") == null ? "" : request.getParameter("polLineCd"));
				params.put("polSublineCd", request.getParameter("polSublineCd") == null ? "" : request.getParameter("polSublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd") == null ? "" : request.getParameter("polIssCd"));
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd") == null ? "" : request.getParameter("issCd"));
				params.put("credBranch", request.getParameter("credBranch") == null ? "" : request.getParameter("credBranch")); //benjo 11.12.2015 UW-SPECS-2015-087
				params.put("intmNo", request.getParameter("intmNo") == null ? "" : request.getParameter("intmNo"));
				params.put("plateNo", request.getParameter("plateNo") == null ? "" : request.getParameter("plateNo"));
				params.put("packPolFlag", request.getParameter("packPolFlag") == null ? "" : request.getParameter("packPolFlag"));
				params.put("includePackage", request.getParameter("includePackage") == null ? "" : request.getParameter("includePackage"));
				params.put("polIssueYy", request.getParameter("polIssueYy") == null ? "" : request.getParameter("polIssueYy"));
				params.put("polPolSeqNo", request.getParameter("polPolSeqNo") == null ? "" : request.getParameter("polPolSeqNo"));
				params.put("polRenewNo", request.getParameter("polRenewNo") == null ? "" : request.getParameter("polRenewNo"));
				params.put("incSpecialSw", request.getParameter("incSpecialSw") == null ? "" : request.getParameter("incSpecialSw"));
				params.put("defIsPolSummSw", request.getParameter("defIsPolSummSw") == null ? "" : request.getParameter("defIsPolSummSw"));
				params.put("defSamePolNoSw", request.getParameter("defSamePolNoSw") == null ? "" : request.getParameter("defSamePolNoSw"));
				params.put("userId", USER.getUserId());
				params.put("msg", "");
				params.put("policyCount", "");
				if("extractExpiringPolicies".equals(ACTION)){
					params = giexExpiryService.extractExpiringPolicies(params);
				}else{
					params = giexExpiryService.extractExpiringPoliciesFinal(params);
				}
				Debug.print("extractExpiringPolicies PARAMS:" + params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				String policyCount = (String) (params.get("policyCount") == null ? "" : params.get("policyCount"));
				message=msg+","+policyCount;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validatePolLineCd".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("polLineCd", request.getParameter("polLineCd") == null ? "" : request.getParameter("polLineCd"));
				params.put("polSublineCd", request.getParameter("polSublineCd") == null ? "" : request.getParameter("polSublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd") == null ? "" : request.getParameter("polIssCd"));
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd") == null ? "" : request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId") == null ? "" : request.getParameter("moduleId"));
				params.put("packPolFlag", "");
				params.put("msg", "");
				params = giisLineService.validatePolLineCd(params);
				String packPolFlag = (String) (params.get("packPolFlag") == null ? "" : params.get("packPolFlag"));
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				message= packPolFlag + "," + msg;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validatePolIssCd".equals(ACTION)) {
				GIISISSourceFacadeService giisIsSourceService = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("polLineCd", request.getParameter("polLineCd") == null ? "" : request.getParameter("polLineCd"));
				params.put("polIssCd", request.getParameter("polIssCd") == null ? "" : request.getParameter("polIssCd"));
				params.put("issRi", request.getParameter("issRi") == null ? "" : request.getParameter("issRi"));
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId") == null ? "" : request.getParameter("moduleId"));
				params.put("msg", "");
				params = giisIsSourceService.validatePolIssCd(params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				message=msg;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateSublineCd".equals(ACTION)) {
				GIISSublineFacadeService giisSublineFacadeService = (GIISSublineFacadeService) APPLICATION_CONTEXT.getBean("giisSublineFacadeService");				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd") == null ? "" : request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd"));
				params.put("msg", "");
				params = giisSublineFacadeService.validateSublineCd(params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				message= msg;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("initializeParamsGIEXS001".equals(ACTION)) {
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("incSpecialSw", "");
				params.put("defIsPolSummSw", "");
				params.put("defSamePolNoSw", "");
				params = giisParametersService.initializeParamsGIEXS001(params);
				String incSpecialSw = (String) (params.get("incSpecialSw") == null ? "" : params.get("incSpecialSw"));
				String defIsPolSummSw = (String) (params.get("defIsPolSummSw") == null ? "" : params.get("defIsPolSummSw"));
				String defSamePolNoSw = (String) (params.get("defSamePolNoSw") == null ? "" : params.get("defSamePolNoSw"));
				String otherBranchRenewal = (String) (params.get("otherBranchRenewal") == null ? "" : params.get("otherBranchRenewal"));
				message= incSpecialSw + "," +defIsPolSummSw + "," +defSamePolNoSw + "," + otherBranchRenewal;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateUserGIEXS001".equals(ACTION)) {
				GIISUserFacadeService giisUserFacadeService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService"); // +env
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd") == null ? "" : request.getParameter("issCd"));
				params.put("msg", "");
				params = giisUserFacadeService.validateUserGIEXS001(params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				message=msg;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updateBalanceClaimFlag".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("allUser",request.getParameter("allUser") == null ? "" : request.getParameter("allUser"));
				params.put("userId", USER.getUserId());
				params = giexExpiryService.updateBalanceClaimFlag(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("arValidationGIEXS004".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giexExpiryService.arValidationGIEXS004(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updateF000Field".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				params = giexExpiryService.updateF000Field(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showEditPerilInformationPage".equals(ACTION)){
				Integer packPolicyId = Integer.parseInt(request.getParameter("packPolicyId") == null || "".equals(request.getParameter("packPolicyId"))? "0" : request.getParameter("packPolicyId"));
				Integer policyId = Integer.parseInt(request.getParameter("policyId") == null || "".equals(request.getParameter("policyId"))? "0" : request.getParameter("policyId"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("packPolicyId", packPolicyId);
				params.put("policyId", policyId);
				GIEXExpiry expiry = giexExpiryService.getGIEXS007B240Info(params);
				request.setAttribute("b240Dtls", new JSONObject(expiry != null ? StringFormatter.escapeHTMLInObject(expiry) :new GIEXExpiry()));
				request.setAttribute("isPack", expiry.getIsPack());
				request.setAttribute("isGpa", expiry.getIsGpa());
				PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/editPerilInfo/editPerilInformation.jsp";
			}else if("showPrintExpiryReportRenewalsPage".equals(ACTION)){
				Map<String, Object> params = new HashMap<String,Object>();
				params.put("ACTION", "getGIEXS006Reports");
				params.put("pageSize", 20);
				Map<String, Object> giexs006TableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(giexs006TableGrid);
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);	
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("giexs006ReportsTableGrid", json);
					PAGE = "/pages/underwriting/renewalProcessing/printExpiryReportRenewals/printExpiryReportRenewals.jsp";
				}
			}else if("checkRecordUser".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				
				DateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
				String sDate = request.getParameter("startDate");
				String startDate;
				if(sDate.equals("")){
					startDate = "";
				}else{
					Date strtDate = df.parse(request.getParameter("startDate"));
					startDate = df.format(strtDate);
				}	
				
				String eDate = request.getParameter("endDate");
				String endDate;
				if(eDate.equals("")){
					endDate = "";
				}else{
					Date ndDate = df.parse(request.getParameter("endDate"));
					endDate = df.format(ndDate);
				}
				
				//Date eDate = df.parse(request.getParameter("endDate"));
				//String endDate = df.format(eDate);
				params.put("startDate", startDate);
				params.put("endDate", endDate);
				
				params.put("frRnSeqNo", request.getParameter("frRnSeqNo"));
				params.put("toRnSeqNo", request.getParameter("toRnSeqNo"));
				params.put("userId", USER.getUserId());
				
				Debug.print("checkRecordUser params:" + params);
				message = giexExpiryService.checkRecordUser(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getRenewalNoticePolicyId".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("frRnSeqNo", request.getParameter("frRnSeqNo"));
				params.put("toRnSeqNo", request.getParameter("toRnSeqNo"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				
				DateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
				String sDate = request.getParameter("startDate");
				String startDate;
				if(sDate.equals("")){
					startDate = "";
				}else{
					Date strtDate = df.parse(request.getParameter("startDate"));
					startDate = df.format(strtDate);
				}	
				
				String eDate = request.getParameter("endDate");
				String endDate;
				if(eDate.equals("")){
					endDate = "";
				}else{
					Date ndDate = df.parse(request.getParameter("endDate"));
					endDate = df.format(ndDate);
				}
				
				//Date eDate = df.parse(request.getParameter("endDate"));
				//String endDate = df.format(eDate);
				params.put("startDate", startDate);
				params.put("endDate", endDate);
				
				Integer renewFlag = request.getParameter("renewFlag") == null ? 0 : Integer.parseInt(request.getParameter("renewFlag"));
				params.put("renewFlag", renewFlag);
				params.put("userId", USER.getUserId());
				params.put("reqRenewalNo", request.getParameter("reqRenewalNo"));
				//added by Gzelle 05202015 SR3698, 3703
				params.put("premBalanceOnly", request.getParameter("premBalanceOnly"));
				params.put("claimsOnly", request.getParameter("claimsOnly"));
				
				Debug.print("getRenewalNoticePolicyId params:" + params);
				
				List<String> resultParams = (List<String>) giexExpiryService.getRenewalNoticePolicyId(params);
				if(renewFlag == 2){
					Debug.print("getRenewalNoticePolicyId resultParams:" + resultParams);
				}else{
					Debug.print("getNonRenewalNoticePolicyId resultParams:" + resultParams);
				}
				
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showExpiryReportInfoDialog".equals(ACTION)){
				PAGE = "/pages/underwriting/renewalProcessing/printExpiryReportRenewals/expiryReportInfoDialog.jsp";
			}else if("showExpiryReportRenewalDialog".equals(ACTION)){
				PAGE = "/pages/underwriting/renewalProcessing/printExpiryReportRenewals/expiryReportRenewalDialog.jsp";
			}else if("showExpiryReportReasonDialog".equals(ACTION)){
				PAGE = "/pages/underwriting/renewalProcessing/printExpiryReportRenewals/expiryReportReasonDialog.jsp";
			}else if("checkPolicyIdGiexs006".equals(ACTION)){
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				message = giexExpiryService.checkPolicyIdGiexs006(policyId);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateLineCdGiexs006".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				
				GIISLineFacadeService giisLineFacadeService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				List<GIISLine> resultParams = giisLineFacadeService.validateLineCdGiexs006(params);
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateSublineCdGiexs006".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				
				GIISSublineFacadeService giisSublineFacadeService = (GIISSublineFacadeService) APPLICATION_CONTEXT.getBean("giisSublineFacadeService");
				List<GIISSubline> resultParams = giisSublineFacadeService.validateSublineCdGiexs006(params);
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateIssCdGiexs006".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				
				GIISISSourceFacadeService giisIssourceFacadeService = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				List<GIISISSource> resultParams = giisIssourceFacadeService.validateIssCdGiexs006(params); 
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateAssdNoGiexs006".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("assdNo", request.getParameter("assdNo"));
				
				GIISAssuredFacadeService giisAssuredFacadeService = (GIISAssuredFacadeService) APPLICATION_CONTEXT.getBean("giisAssuredFacadeService");
				List<GIISAssured> resultParams = giisAssuredFacadeService.validateAssdNoGiexs006(params);
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateIntmNoGiexs006".equals(ACTION)){
				Integer intmNo = Integer.parseInt(request.getParameter("intmNo"));
				
				GIISIntermediaryService giisIntermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				List<GIISIntermediary> resultParams = giisIntermediaryService.validateIntmNoGiexs006(intmNo);
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateRenewalNo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String lineLOV = request.getParameter("lineLOV");
				String lineCd = request.getParameter("lineCd") == "" ? request.getParameter("lineLOV") : request.getParameter("lineCd");
				params.put("lineLOV", lineLOV);
				params.put("sublineLOV", request.getParameter("sublineLOV"));
				params.put("issLOV", request.getParameter("issLOV"));
				params.put("intmLOV", request.getParameter("intmLOV"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("frDate", request.getParameter("frDate"));
				params.put("toDate", request.getParameter("toDate"));
				params.put("userId", USER.getUserId());
				Debug.print("generateRenewalNo params:" + params);
				
				String packPolFlag; //Modified by Jerome Bautista 07.30.2015 SR 19629/19781
				packPolFlag = giisLineService.getPackPolFlag(lineCd); //Modified by Jerome Bautista 07.30.2015 SR 19629/19781

				if(packPolFlag.equals("Y")){ //Modified by Jerome Bautista 07.30.2015 SR 19629/19781
					giexExpiryService.generatePackRenewalNo(params);
				}else{
					giexExpiryService.generateRenewalNo(params);
				}
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkGenRnNo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineLOV", request.getParameter("lineLOV"));
				params.put("sublineLOV", request.getParameter("sublineLOV"));
				params.put("issLOV", request.getParameter("issLOV"));
				params.put("intmLOV", request.getParameter("intmLOV"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("frDate", request.getParameter("frDate"));
				params.put("toDate", request.getParameter("toDate"));
				
				Debug.print("checkGenRnNo params:" + params);
	
				message = giexExpiryService.checkGenRnNo(params).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkRecordUserNr".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				
				DateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
				String sDate = request.getParameter("startDate");
				String startDate;
				if(sDate.equals("")){
					startDate = "";
				}else{
					Date strtDate = df.parse(request.getParameter("startDate"));
					startDate = df.format(strtDate);
				}	
				
				String eDate = request.getParameter("endDate");
				String endDate;
				if(eDate.equals("")){
					endDate = "";
				}else{
					Date ndDate = df.parse(request.getParameter("endDate"));
					endDate = df.format(ndDate);
				}
				
				//Date eDate = df.parse(request.getParameter("endDate"));
				//String endDate = df.format(eDate);
				params.put("startDate", startDate);
				params.put("endDate", endDate);
				params.put("userId", USER.getUserId());
				
				Debug.print("checkRecordUser params:" + params);
				message = giexExpiryService.checkRecordUserNr(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGiispLineCdGiexs006".equals(ACTION)){
				String param = request.getParameter("param");
				message = giexExpiryService.getGiispLineCdGiexs006(param);
				PAGE = "/pages/genericMessage.jsp";
			}else if("changeIncludePackValue".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				message = giexExpiryService.changeIncludePackValue(lineCd);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showSMSRenewal".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getSMSRenewalPolicies");
				params.put("userId", USER.getUserId());
				Map<String, Object> smsRenewalTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(smsRenewalTableGrid);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("callingForm", request.getParameter("moduleId") == null ? "GISMS007" : request.getParameter("moduleId"));
					request.setAttribute("smsRenewalTableGrid", json);
					PAGE = "/pages/sms/sendMessageForRenewal/smsRenewal.jsp";
				}
			}
		}catch (NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
