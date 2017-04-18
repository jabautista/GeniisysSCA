package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISCurrencyService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISUserIssCdService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACChkDisbursement;
import com.geniisys.giac.entity.GIACChkReleaseInfo;
import com.geniisys.giac.entity.GIACDisbVouchers;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.service.GIACAccTransService;
import com.geniisys.giac.service.GIACChkDisbursementService;
import com.geniisys.giac.service.GIACChkReleaseInfoService;
import com.geniisys.giac.service.GIACDisbVouchersService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACPaytRequestsDtlService;
import com.geniisys.giac.service.GIACPaytRequestsService;
import com.geniisys.giac.service.GIACUserFunctionsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIACPaytRequestsController", urlPatterns="/GIACPaytRequestsController")
public class GIACPaytRequestsController extends BaseController {

	private Logger log = Logger.getLogger(GIACPaytRequestsController.class);
	private static final long serialVersionUID = 432876507529519977L;
	public static String workflowMsgr = "";
	public static String pMessageAlert = "";
	public static Integer refId = null;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACPaytRequestsService giacPaytRequestsService = (GIACPaytRequestsService) APPLICATION_CONTEXT.getBean("giacPaytRequestsService");
			
			if("showDisbursementRequests".equals(ACTION)){
				String disbursement = request.getParameter("disbursement");
				Map<String, Object> params = new HashMap<String, Object>();
				
				if("CPR".equals(disbursement)){
					params.put("ACTION", "getClmPaytReqListing");
				}else if("FPP".equals(disbursement)){
					params.put("ACTION", "getFaculPremPaytListing");
				}else if("CP".equals(disbursement)){
					params.put("ACTION", "getCommPaytListing");
				}else if("OP".equals(disbursement)){
					params.put("ACTION", "getOtherPaytListing");
				}else if("CR".equals(disbursement)){
					params.put("ACTION", "getCancelReqListing");
				}
				
				GIACDisbVouchersService giacDisbVouchersService = (GIACDisbVouchersService) APPLICATION_CONTEXT.getBean("giacDisbVouchersService");
				String defaultBranchCd = giacDisbVouchersService.getDefaultBranchCd(USER.getUserId());
				
				params.put("userId", USER.getUserId());
				params.put("branchCd", request.getParameter("branchCd") == "" || request.getParameter("branchCd").equals(null) ? defaultBranchCd : request.getParameter("branchCd"));
				params.put("paytReqFlag", request.getParameter("paytReqFlag") == "" ? null : request.getParameter("paytReqFlag"));
				
				Map<String, Object> disbRequestsTG = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(disbRequestsTG);
				System.out.println(">>>>>>>>>>>>" + json);
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // shan 11.04.2014
					String[] domainDesignation = {"GIAC_PAYT_REQUESTS_DTL.PAYT_REQ_FLAG"};
					request.setAttribute("paytReqFlagList", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainDesignation));
					request.setAttribute("disbursement", disbursement);
					request.setAttribute("disbRequestsJSON", json);
					request.setAttribute("otherBranch",  request.getParameter("branchCd") == "" ? null : request.getParameter("branchCd"));
					PAGE = "/pages/accounting/generalDisbursements/disbursementReqList/disbursementReqListing.jsp";
				}
			}else if("showMainDisbursementPage".equals(ACTION)){
				log.info("Getting Disbursement Details...");
				GIACPaytRequestsDtlService giacPaytRequestsDtlService = (GIACPaytRequestsDtlService) APPLICATION_CONTEXT.getBean("giacPaytRequestsDtlService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIISParameterFacadeService giisParameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				String disbursement = request.getParameter("disbursement");
				GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT.getBean("giisCurrencyService");
				GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT.getBean("giacUserFunctionsService");
				
				JSONObject payt = giacPaytRequestsService.getGiacPaytRequests(request, USER);
				JSONObject paytDtl = giacPaytRequestsDtlService.getGiacPaytRequestsDtl(request, USER);
				String docLovAction = "";
				Map<String, Object> params = new HashMap<String, Object>();
				if("CPR".equals(disbursement)){
					request.setAttribute("globalDocCd", giacParamService.getParamValueV2("CLM_PAYT_REQ_DOC"));
					docLovAction = "getRgDocumentCdClaimLOV";
				}else if("FPP".equals(disbursement)){
					request.setAttribute("globalDocCd", giacParamService.getParamValueV2("FACUL_RI_PREM_PAYT_DOC"));
					params.put("paramName", "FACUL_RI_PREM_PAYT_DOC");
					docLovAction = "getRgDocumentCdNonClaimLOV";
				}else if("CP".equals(disbursement)){
					request.setAttribute("globalDocCd", giacParamService.getParamValueV2("COMM_PAYT_DOC"));
					docLovAction = "getRgDocumentCdNonClaimLOV";
					params.put("paramName", "COMM_PAYT_DOC");
				}else if("OP".equals(disbursement)){
					request.setAttribute("globalDocCd", "");
					docLovAction = "getRgDocumentCdOtherLOV";
				}else if("CR".equals(disbursement)){
					request.setAttribute("globalDocCd", "");
					docLovAction = "getRgDocumentCdAllLOV";
				}
				String fundCd = giacParamService.getParamValueV2("FUND_CD");
				String allowPrint = giacParamService.getParamValueV2("PRINT_REQ_WO_DETAILS");
				String branchCd = giacParamService.getGlobalBranchCdByUserId(USER.getUserId());
				String otherBranch = request.getParameter("branch"); //to obtain selected branch in GIACS055 - Halley 11.13.13
				
				params.put("fundCd", fundCd);
				//added condition; when otherBranch has a value, it means calling module is GIACS055 - Halley 11.13.13
				if(otherBranch == null || otherBranch == ""){ 
					params.put("branchCd", branchCd);
				}else{
					params.put("branchCd", otherBranch);  
				}
				params.put("branchName", "");
				params.put("fundDesc", "");
				params.put("allowPrint", allowPrint);
				params.put("docLovAction", docLovAction);
				// checks if there is only 1 available doc cd - irwin
				List<GIACPaytReqDocs> docList = giacPaytRequestsService.getGIACPaytReqDocsList(params);
				request.setAttribute("setInitialDoc", "N");
				if(docList.size() == 1){
					request.setAttribute("setInitialDoc", "Y");
					request.setAttribute("docObj", new JSONObject(docList.get(0)));
				}
				
				giacPaytRequestsService.getFundBranchDesc(params);
				
				String defaultCurrency = giacParamService.getParamValueV2("DEFAULT_CURRENCY");
				request.setAttribute("defaultCurrencyRt", giisCurrencyService.getCurrencyByShortname(defaultCurrency));
				request.setAttribute("defaultCurrency", defaultCurrency);
				request.setAttribute("globalPFundDesc", params.get("fundDesc"));
				request.setAttribute("globalPBrancName", params.get("branchName"));
				request.setAttribute("globalPFundCd", fundCd);
				//added condition; when otherBranch has a value, it means calling module is GIACS055 - Halley 11.13.13
				if(otherBranch == null || otherBranch == ""){
					request.setAttribute("globalPBranchCd", branchCd);
				}else{
					request.setAttribute("globalPBranchCd", otherBranch);
				}
				request.setAttribute("newRec", request.getParameter("newRec"));
				request.setAttribute("allUserSw", USER.getAllUserSw());
				request.setAttribute("uploadTagSw", giacParamService.getParamValueV2("UPLOAD_IMPLEMENTATION_SW"));
				request.setAttribute("allowTranForClosedMonth", giacParamService.getParamValueV2("ALLOW_TRAN_FOR_CLOSED_MONTH"));
				request.setAttribute("disbursement", disbursement);
				//request.setAttribute("userIsValid", giacUserFunctionsService.checkIfUserHasFunction("CR", "GIACS016", USER.getUserId())); // replaced with codes below : shan 09.09.2014
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("userId", USER.getUserId());
				param.put("functionCd", "CR");
				param.put("moduleName", "GIACS016");
				param.put("validTag", "Y");
				request.setAttribute("userIsValid", giacUserFunctionsService.checkIfUserHasFunction3(param));
				request.setAttribute("sysdate", giisParameterService.getFormattedSysdate());
				
				// added by shan 04.08.2015
				if (!paytDtl.get("tranId").equals(null)){
					GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
					Integer tranId = paytDtl.getInt("tranId");
					request.setAttribute("tranFlag", accTransService.getTranFlag(tranId));
				}
				// end 04.08.2015
				
				// added by shan 08.29.2013
				String moduleId = request.getParameter("moduleId") == null ? "" : request.getParameter("moduleId");
				if(moduleId.equals("GIACS070")){
					JSONArray json = new JSONArray();
					json.put(payt);
					json.put(paytDtl);
					
					message = json.toString();
					System.out.println(json.toString());
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalDisbursements/mainDisbursement/mainDisbursementPage.jsp";
				}
				
			}else if ("saveDisbursmentRequest".equals(ACTION)) {
				System.out.println("NEW REC: "+request.getParameter("newRec"));
				giacPaytRequestsService.saveDisbursmentRequest(request, USER.getUserId());
				
				if ((!GIACPaytRequestsController.workflowMsgr.equals(""))||(GIACPaytRequestsController.workflowMsgr.equals(null))){
					Runtime rt=Runtime.getRuntime();
					rt.exec(GIACPaytRequestsController.workflowMsgr);
				}	
				
				message = GIACPaytRequestsController.refId.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getClosedTag".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				message = giacPaytRequestsService.getClosedTag(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showDvInfo".equals(ACTION)) {
				Integer refId = Integer.parseInt(request.getParameter("refId"));
				GIACDisbVouchersService giacDisbVouchersService = (GIACDisbVouchersService) APPLICATION_CONTEXT.getBean("giacDisbVouchersService");
				GIACChkDisbursementService giacChkDisbursementService = (GIACChkDisbursementService) APPLICATION_CONTEXT.getBean("giacChkDisbursementService");
				GIACChkReleaseInfoService giacChkReleaseInfoService = (GIACChkReleaseInfoService) APPLICATION_CONTEXT.getBean("giacChkReleaseInfoService");
				System.out.println("RefID: "+refId);
				
				GIACDisbVouchers giacDisbVouchers = giacDisbVouchersService.getGiacs016GiacDisb(refId);
				GIACChkDisbursement giacChkDisbursement = giacChkDisbursementService.getGiacs016GiacDisb(giacDisbVouchers.getGaccTranId());

				//Lara 12/13/2013 SR#1332
				GIACChkReleaseInfo giacChkReleaseInfo = null;
				if(giacChkDisbursement != null){
					giacChkReleaseInfo = giacChkReleaseInfoService.getgiacs016ChkReleaseInfo(giacChkDisbursement.getGaccTranId(), giacChkDisbursement.getItemNo());
				}
				
				StringFormatter.escapeHTMLInObject(giacDisbVouchers);
				StringFormatter.escapeHTMLInObject(giacChkDisbursement);
				//StringFormatter.escapeHTMLInObject(giacChkReleaseInfo); //marco - 04.21.2014 - comment out - object was escaped twice
				
				request.setAttribute("giacDisbVouchers", giacDisbVouchers == null ? "[]" : new JSONObject(StringFormatter.escapeHTMLInObject(giacDisbVouchers)));
				request.setAttribute("giacChkDisbursement", giacChkDisbursement == null ? "[]" : new JSONObject(StringFormatter.escapeHTMLInObject(giacChkDisbursement)));
				request.setAttribute("giacChkReleaseInfo", giacChkReleaseInfo == null ? "[]" : new JSONObject(StringFormatter.escapeHTMLInObject(giacChkReleaseInfo)));
				PAGE = "/pages/accounting/generalDisbursements/mainDisbursement/subpages/dvInfo.jsp";
			}else if ("valAmtBeforeClosing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", request.getParameter("tranId") == "" ? null : Integer.parseInt(request.getParameter("tranId")));
				params.put("paytAmt", request.getParameter("paytAmt").equals("") ? null : new BigDecimal(request.getParameter("paytAmt")) );
				giacPaytRequestsService.valAmtBeforeClosing(params);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("populateChkTags".equals(ACTION)) {
				Map<String, Object> params = giacPaytRequestsService.populateChkTags(FormInputUtil.getFormInputs(request));
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("closeRequest".equals(ACTION)) {
				giacPaytRequestsService.closeRequest(request, USER.getUserId());
				
				if ((!GIACPaytRequestsController.workflowMsgr.equals(""))||(GIACPaytRequestsController.workflowMsgr.equals(null))){
					Runtime rt=Runtime.getRuntime();
					rt.exec(GIACPaytRequestsController.workflowMsgr);
				}
			}else if("checkUserAccessForBranch".equals(ACTION)){
				GIISUserIssCdService userIssService = (GIISUserIssCdService) APPLICATION_CONTEXT.getBean("giisUserIssCdService");
				GIACDisbVouchersService giacDisbVouchersService = (GIACDisbVouchersService) APPLICATION_CONTEXT.getBean("giacDisbVouchersService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				
				GIACDisbVouchers giacDisbVouchers = giacDisbVouchersService.getGiacs016GiacDisb(Integer.parseInt((String) params.get("refId")));
				String withDv = "N";
				if(giacDisbVouchers != null){
					withDv = "Y";
				}
				message = userIssService.checkUserPerIssCdAcctg2(params)+","+withDv;
			}else if ("cancelPaymentRequest".equals(ACTION)) {
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				giacPaytRequestsService.cancelPaymentRequest(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGIACS002PaytRequests".equals(ACTION)){
				giacPaytRequestsService.getGiacPaytRequests(request, USER);
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGIACS016PayReqOtherDetails".equals(ACTION)){
				JSONObject json = giacPaytRequestsService.getGIACS016PaytReqOtherDetails(request);
				message = json.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCommFundListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("userId", USER.getUserId());
				
				giacPaytRequestsService.extractCommFund(params);
				Map<String, Object> commFundTg = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(commFundTg);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("commFundJSON", json);
					PAGE = "/pages/accounting/generalDisbursements/mainDisbursement/subpages/commFundSlip.jsp";
				}
			}else if("getAllCommFundListing".equals(ACTION)){ //added by steven 07.31.2014
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("userId", USER.getUserId());
				Map<String, Object> commFundTg = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(commFundTg);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkCommFundSlip".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacPaytRequestsService.checkCommFundSlip(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			}else if("processAFterPrinting".equals(ACTION)){
				/*
				 * Added by reymon 06182013
				 * process after printing comm fund slip
				 */
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("userId", USER.getUserId());
				params.put("sw", request.getParameter("sw"));
				giacPaytRequestsService.processAfterPrinting(params);
				PAGE = "/pages/genericMessage.jsp";
			}
			/*else if("getDocLineList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				
				List<GIISLine> lineList = giacPaytRequestsService.getPaymentLinesList(params);
				@SuppressWarnings("unchecked")
				JSONArray json = new JSONArray((List<GIISLine>) StringFormatter.escapeHTMLInList(lineList));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getDocYearList".equals(ACTION) || "getDocMonthList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("docYear", (request.getParameter("docYear").equals(null) || request.getParameter("docYear").equals("")) ? 0 : Integer.parseInt(request.getParameter("docYear")));
				
				List<GIACPaytRequests> docList = ACTION.equals("getDocYearList") ? giacPaytRequestsService.getPaymentDocYear(params) : giacPaytRequestsService.getPaymentDocMm(params);
				for(GIACPaytRequests d : docList ){
					System.out.println("year: " + d.getDocYear() +"\tmonth: " + d.getDocMm());	
				}
				
				@SuppressWarnings("unchecked")
				JSONArray json = new JSONArray((List<GIACPaytRequests>) StringFormatter.replaceQuotesInList(docList));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateDocSeqNo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("docYear", (request.getParameter("docYear").equals(null) || request.getParameter("docYear").equals("")) ? 0 : Integer.parseInt(request.getParameter("docYear")));
				params.put("docMm", request.getParameter("docMm"));
				params.put("docSeqNo",request.getParameter("docSeqNo"));
				
				GIACPaytRequests doc = giacPaytRequestsService.validateDocSeqNo(params);
				JSONObject json = new JSONObject(doc);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("validatePaytLineCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("lineCdTag", request.getParameter("lineCdTag"));
				
				giacPaytRequestsService.validatePaytLineCd(params);
				PAGE = "/pages/genericMessage.jsp";
			}*/
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e); 
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}  finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
