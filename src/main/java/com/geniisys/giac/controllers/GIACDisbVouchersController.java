package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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

import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISUserIssCdService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACChkDisbursement;
import com.geniisys.giac.entity.GIACChkReleaseInfo;
import com.geniisys.giac.entity.GIACDisbVouchers;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.entity.GIACPaytRequests;
import com.geniisys.giac.service.GIACAccTransService;
import com.geniisys.giac.service.GIACChkDisbursementService;
import com.geniisys.giac.service.GIACChkReleaseInfoService;
import com.geniisys.giac.service.GIACDisbVouchersService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACPaytRequestsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIACDisbVouchersController", urlPatterns="/GIACDisbVouchersController")
public class GIACDisbVouchersController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACDisbVouchersController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		try {
			log.info("Initilaizing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIACDisbVouchersService giacDisbVouchersService = (GIACDisbVouchersService) APPLICATION_CONTEXT.getBean("giacDisbVouchersService");
			GIACPaytRequestsService giacPaytRequestsService = (GIACPaytRequestsService) APPLICATION_CONTEXT.getBean("giacPaytRequestsService");
			GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService"); 
			GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
			GIACChkReleaseInfoService giacChkReleaseInfoService = (GIACChkReleaseInfoService) APPLICATION_CONTEXT.getBean("giacChkReleaseInfoService");
			
			if("showGenerateDisbursementVoucher".equals(ACTION)){
				String defaultFundCd = giacParamService.getParamValueV2("FUND_CD");
				String defaultBranchCd = giacDisbVouchersService.getDefaultBranchCd(USER.getUserId());
				
				Map<String, Object> params = new HashMap<String, Object>();
				//params.put("fundCd", defaultFundCd);
				//params.put("branchCd", defaultBranchCd);
				
				params.put("fundCd", request.getParameter("fundCd").equals("") || request.getParameter("fundCd").equals(null) ? defaultFundCd : request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd").equals("") || request.getParameter("branchCd").equals(null) ? defaultBranchCd : request.getParameter("branchCd"));
				params.put("userId", USER.getUserId());
				
				GIACDisbVouchers defaultVoucher = giacDisbVouchersService.getDefaultVoucher(params);
				System.out.println("fundCd: " + defaultVoucher.getGibrGfunFundCd());
				request.setAttribute("defaultFundCd", defaultFundCd);
				request.setAttribute("defaultBranchCd", defaultBranchCd);
				request.setAttribute("disbVoucherInfo", new JSONObject(StringFormatter.escapeHTMLInObject(defaultVoucher)));				
				request.setAttribute("userId", USER.getUserId()); //added by robert 12.13.2013
				PAGE = "/pages/accounting/generalDisbursements/disbursementVoucher/disbursementVoucher.jsp";
			} else if("getGIACS002DisbVoucherList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				String defaultFundCd = giacParamService.getParamValueV2("FUND_CD");
				String defaultBranchCd = giacDisbVouchersService.getDefaultBranchCd(USER.getUserId());
				System.out.println("defaultBranchCd: " + defaultBranchCd+"\tdefaultFundCd: "+defaultFundCd);
				
				params.put("fundCd", (request.getParameter("fundCd").equals(null) || request.getParameter("fundCd").equals("")) ? defaultFundCd : request.getParameter("fundCd"));
				params.put("branchCd", (request.getParameter("branchCd").equals(null) || request.getParameter("branchCd").equals("")) ? defaultBranchCd : request.getParameter("branchCd"));
				params.put("dvFlagParam", (request.getParameter("dvFlagParam").equals(null) || request.getParameter("dvFlagParam").equals("")) ? "N" : request.getParameter("dvFlagParam"));
				
				params.put("userId", USER.getUserId());
				if(request.getParameter("cancelFlag").equals("Y")){
					params.put("cancelFlag",request.getParameter("cancelFlag"));
				}
				//params.put("gaccTranId", request.getParameter("gaccTranId") == null ? 0 : Integer.parseInt(request.getParameter("gaccTranId")));
				System.out.println("params for dv listing: " + params);
				params = TableGridUtil.getTableGrid(request, params);
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // shan 11.04.2014
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					String[] domainDesignation = {"GIAC_DISB_VOUCHERS.DV_FLAG"};
					request.setAttribute("dvFlagList", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainDesignation));
					request.setAttribute("disbVoucherList", new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params)));
					PAGE = "/pages/accounting/generalDisbursements/disbursementVoucher/disbursementVoucherTable.jsp";
				}
				
			} else if("getDisbVoucherInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals(null) ? 0 : Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("itemNo", request.getParameter("itemNo") == null ? 1 : request.getParameter("gaccTranId"));
				params.put("userId", USER.getUserId());
				
				GIACDisbVouchers disbVoucher = giacDisbVouchersService.getDisbVoucherInfo(params);
				//System.out.println("funddesc: " + disbVoucher.getFundDesc() + "\tbranchname: " + disbVoucher.getBranchName());
				
				//condition added by shan for GIACS070, 08.29.2013
				String moduleId = request.getParameter("moduleId") == null ? "" : request.getParameter("moduleId");				
				if(moduleId.equals("GIACS070")){
					JSONObject json = disbVoucher == null ? new JSONObject() : new JSONObject(StringFormatter.escapeHTMLInObject(disbVoucher));
					json.put("tranSeqNo", giacDisbVouchersService.getTranSeqNo(Integer.parseInt(request.getParameter("gaccTranId"))));
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("disbVoucherInfo", disbVoucher == null ? new JSONObject() : new JSONObject(StringFormatter.escapeHTMLInObject(disbVoucher)));
					if (disbVoucher != null){
						request.setAttribute("tranFlag", accTransService.getTranFlag(disbVoucher.getGaccTranId()));
					}
					request.setAttribute("tranSeqNo", giacDisbVouchersService.getTranSeqNo(Integer.parseInt(request.getParameter("gaccTranId"))));
					
					PAGE = "/pages/accounting/generalDisbursements/disbursementVoucher/disbursementVoucher.jsp";
				}
				request.setAttribute("userId", USER.getUserId()); //added by robert 12.13.2013
			} else if("getChkReleaseInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				GIACChkReleaseInfo chkReleaseInfo = giacChkReleaseInfoService.getGIACS002ChkReleaseInfo(params);
				JSONObject json = chkReleaseInfo == null ? new JSONObject() : new JSONObject(chkReleaseInfo);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
				
				//request.setAttribute("chkReleaseInfo", chkReleaseInfo == null ? new JSONObject() : new JSONObject(chkReleaseInfo));
			} else if("checkFundBranchFK".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				
				params = giacDisbVouchersService.checkFundBranchFK(params);
				request.setAttribute("fundBranchFK", params == null ? new JSONObject() : new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				PAGE = "/pages/genericMessage.jsp";
			} else if("getPrintTagMean".equals(ACTION)){
				String printTag = request.getParameter("printTag");
				message = giacDisbVouchersService.getPrintTagMean(printTag);
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateAcctEntriesBeforeApproving".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId") == null ? null : Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("creditDebitTotalAmount", new BigDecimal("0"));
				
				params = giacDisbVouchersService.validateAcctEntriesBeforeApproving(params);
				System.out.println("params returned: " + params);
				//request.setAttribute("totalAmount", new JSONObject(params));
				JSONObject json = new JSONObject((Map<String, Object>) params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("approveValidatedDV".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId") == null ? null : Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("dvFlag", request.getParameter("dvFlag"));
				params.put("dvFlagMean", "");
				params.put("approvedBy", "");
				params.put("approveDate", null);
				params.put("approveDateStr", "");
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));  //GIACS002
				params.put("eventDesc", request.getParameter("eventDesc")); //APPROVE DV
				params.put("colValue", request.getParameter("colValue") == null ? null : Integer.parseInt(request.getParameter("colValue")));  // gaccTranId
				
				params = giacDisbVouchersService.approveValidatedDV(params);
				JSONObject json = params == null ? new JSONObject() : new JSONObject((Map<String, Object>)StringFormatter.escapeHTMLInMap(params));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getPaytReqNumberingScheme".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("documentCd", request.getParameter("documentCd"));
				
				GIACPaytReqDocs scheme = giacDisbVouchersService.getPaytReqNumberingScheme(params);
				JSONObject json = scheme == null ? new JSONObject() : new JSONObject(StringFormatter.escapeHTMLInObject(scheme));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveVoucher".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				//params = 
				//Map<String, Object> params = FormInputUtil.getFormInputs(request);	
				GIACDisbVouchers voucher = createVoucher(request);
				//params.put("voucher", voucher);
				params.putAll(FormInputUtil.formMapFromEntity(voucher));
				params.put("callingForm", request.getParameter("callingForm"));
				params.put("globalDVTag", request.getParameter("globalDVTag"));
				params.put("appUser", USER.getUserId());
				params.put("userId", USER.getUserId());
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("message", "");
				params.put("workflowMsgr", "");
				System.out.println("params in save: " + params.get("lastUpdate"));
				
				params = giacDisbVouchersService.saveVocuher(params);
				System.out.println("returned params in controller: " + params);
				params.put("clmDocCd", giacParamService.getParamValueV2("CLM_PAYT_REQ_DOC"));
				params.put("riDocCd", giacParamService.getParamValueV2("FACUL_RI_PREM_PAYT_DOC"));
				params.put("commDocCd", giacParamService.getParamValueV2("COMM_PAYT_DOC"));
				params.put("bcsrDocCd", giacParamService.getParamValueV2("BATCH_CSR_DOC"));
				
				GIACDisbVouchers disbVoucher = giacDisbVouchersService.getDisbVoucherInfo(params);
				params.putAll(FormInputUtil.formMapFromEntity(disbVoucher));
				params.put("tranSeqNo", giacDisbVouchersService.getTranSeqNo((Integer) params.get("gaccTranId")));
				
				JSONObject json = params == null ? new JSONObject() : new JSONObject(StringFormatter.escapeHTMLInMap(params));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateGIACS002DocCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("documentCd", request.getParameter("documentCd"));
				
				giacDisbVouchersService.validateGIACS002DocCd(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("validatePaytDocYear".equals(ACTION) || "validatePaytDocMm".equals(ACTION) || "validatePaytLineCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				
				if("validatePaytLineCd".equals(ACTION)){
					params.put("lineCdTag", request.getParameter("lineCdTag"));
					
					giacPaytRequestsService.validatePaytLineCd(params);
				} else if("validatePaytDocYear".equals(ACTION)){
					params.put("docYear", Integer.parseInt(request.getParameter("docYear")));
					params.put("nbtYyTag", request.getParameter("nbtYyTag"));
					
					giacPaytRequestsService.validatePaytDocYear(params);
				} else if("validatePaytDocMm".equals(ACTION)){
					params.put("docYear", Integer.parseInt(request.getParameter("docYear")));
					params.put("docMm", Integer.parseInt(request.getParameter("docMm")));
					params.put("nbtMmTag", request.getParameter("nbtMmTag"));
					
					giacPaytRequestsService.validatePaytDocMm(params);
				} 
				
				PAGE = "/pages/genericMessage.jsp";
			} 		//else if ("showCheckDetailsPage".equals(ACTION)){
				else if ("getGIACS002ChkDisbursementTG".equals(ACTION)){
				GIACChkDisbursementService chkDisbursementService = (GIACChkDisbursementService) APPLICATION_CONTEXT.getBean("giacChkDisbursementService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("userId", USER.getUserId());
				
				GIACChkDisbursement chkDisb = chkDisbursementService.getGiacs002ChkDisbursement(params);
				
					/*request.setAttribute("chkDisbInfo", chkDisb == null ? new JSONObject() : new JSONObject(StringFormatter.escapeHTMLInObject(chkDisb)));
					request.setAttribute("disbVoucherInfo", new JSONObject(request.getParameter("dvItem")));
					request.setAttribute("paramCheckPref", giacParamService.getParamValueV2("CHECK_PREF"));
					request.setAttribute("paramUpdatePayeeName", giacParamService.getParamValueV2("UPDATE_PAYEE_NAME"));
					request.setAttribute("paramGenBankTransferNo", giacParamService.getParamValueV2("GEN_BANK_TRANSFER_NO"));
					request.setAttribute("paramCheckDVPrint", giacParamService.getParamValueV2("CHECK_DV_PRINT"));
					request.setAttribute("userId", USER.getUserId());
					request.setAttribute("tranFlag", accTransService.getTranFlag(Integer.parseInt(request.getParameter("gaccTranId"))));*/
				
				params.put("userId", USER.getUserId());
				params.put("ACTION", "getGIACS002ChkDisbursementTG");
				params = TableGridUtil.getTableGrid(request, params);
				params.remove("from");
				params.remove("to");
				params.remove("pages");
				
					//PAGE = "/pages/accounting/generalDisbursements/disbursementVoucher/checkDetails.jsp";
				
					//params.put("userId", USER.getUserId());
					//params.put("ACTION", "getGIACS002ChkDisbursementTG");
					//params = TableGridUtil.getTableGrid(request, params);
					//request.setAttribute("checkList", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("chkDisbInfo", chkDisb == null ? new JSONObject() : new JSONObject((Object)StringFormatter.escapeHTMLInObject(chkDisb)));
					//request.setAttribute("disbVoucherInfo", new JSONObject(request.getParameter("dvItem")));
					request.setAttribute("paramCheckPref", giacParamService.getParamValueV2("CHECK_PREF"));
					request.setAttribute("paramUpdatePayeeName", giacParamService.getParamValueV2("UPDATE_PAYEE_NAME"));
					request.setAttribute("paramGenBankTransferNo", giacParamService.getParamValueV2("GEN_BANK_TRANSFER_NO"));
					request.setAttribute("paramCheckDVPrint", giacParamService.getParamValueV2("CHECK_DV_PRINT"));
					request.setAttribute("paramAllowDVPrinting", giacParamService.getParamValueV2("ALLOW_DV_PRINTING"));
					request.setAttribute("userId", USER.getUserId());
					request.setAttribute("tranFlag", accTransService.getTranFlag(Integer.parseInt(request.getParameter("gaccTranId"))));
					request.setAttribute("checkDVPrintColumn", chkDisbursementService.checkDVPrintColumn(request)); //added by steven 09.15.2014
					
					request.setAttribute("checkList", new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params)));
					PAGE = "/pages/accounting/generalDisbursements/disbursementVoucher/checkDetails.jsp";
				}
			} /*else if("getGIACS002ChkDisbursementTG".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("userId", USER.getUserId());
				params.put("ACTION", ACTION);
				params = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("checkList", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/accounting/generalDisbursements/disbursementVoucher/checkDetails.jsp";
				}
			} */else if("getTranFlag".equals(ACTION)){
				Integer gaccTranId = Integer.parseInt(request.getParameter("gaccTranId"));
				message = accTransService.getTranFlag(gaccTranId);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkIfOfppr".equals(ACTION)){
				Integer gaccTranId = Integer.parseInt(request.getParameter("gaccTranId"));
				message = giacDisbVouchersService.checkIfOfppr(gaccTranId);
				PAGE = "/pages/genericMessage.jsp";
			} else if("verifyOfpprTrans".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("memoType", "");
				params.put("memoYear", null);
				params.put("memoSeqNo", null);
				params.put("exists", "");
				params.put("userId", USER.getUserId());
				
				params = giacDisbVouchersService.verifyOfpprTrans(params);
				JSONObject json = new JSONObject((Map<String, Object>) params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkCollectionDtl".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("memoType", "");
				params.put("memoYear", null);
				params.put("memoSeqNo", null);
				params.put("memoType", "");
				params.put("orFound", "");
				params.put("message", "");

				params = giacDisbVouchersService.checkCollectionDtl(params);
				JSONObject json = new JSONObject((Map<String, Object>) params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}  else if("preCancelDV".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("memoType", request.getParameter("memoType"));
				params.put("memoYear", Integer.parseInt(request.getParameter("memoYear")));
				params.put("memoSeqNo", Integer.parseInt(request.getParameter("memoSeqNo")));
				
				giacDisbVouchersService.preCancelDV(params);
				// call the method here
			} else if("cancelDV".equals(ACTION)){
				SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("dvDate", sdf.parse(request.getParameter("dvDate")));
				params.put("dvFlag", request.getParameter("dvFlag"));
				params.put("dvPref", request.getParameter("dvPref"));
				params.put("dvNo", Integer.parseInt(request.getParameter("dvNo")));
				params.put("dvStatus", "");
				params.put("dvStatusMean", "");
				params.put("dvLastUpdate", null);
				params.put("dvLastUpdateStr", "");
				
				params = giacDisbVouchersService.cancelDV(params);
				JSONObject json = new JSONObject((Map<String, Object>) params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkUserPerIssCdAcctgGIACS002".equals(ACTION)){
				GIISUserIssCdService userIssService = (GIISUserIssCdService) APPLICATION_CONTEXT.getBean("giisUserIssCdService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", "");
				params.put("issCd", request.getParameter("branchCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				message = userIssService.checkUserPerIssCdAcctg2(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateIfReleasedCheck".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("checkPrefSuf", request.getParameter("checkPrefSuf"));
				params.put("checkNo", (request.getParameter("checkNo")));
				
				message = giacDisbVouchersService.validateIfReleasedCheck(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateAcctEntriesBeforePrint".equals(ACTION)){
				Integer gaccTranId = Integer.parseInt(request.getParameter("gaccTranId"));
				message = giacDisbVouchersService.validateAcctgEntriesBeforePrint(gaccTranId);
				PAGE = "/pages/genericMessage.jsp";
			} else if("deleteWorkflowRecords".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId") == null ? 0 : Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("appUser", USER.getUserId());
				
				giacDisbVouchersService.deleteWorkflowRecords(params);
				PAGE = "/pages/genericMessage.jsp";
			}
			
			// moved from GIACPaytRequestsController
			else if("getDocLineList".equals(ACTION)){
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
			} else if("getDocSeqNoList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("documentCd", request.getParameter("documentCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("docYear", Integer.parseInt(request.getParameter("docYear")));
				params.put("docMm",Integer.parseInt( request.getParameter("docMm")));
				
				List<GIACPaytRequests> docSeqNoList = giacDisbVouchersService.getDocSeqNoList(params);
				
				@SuppressWarnings("unchecked")
				JSONObject json = docSeqNoList == null ? new JSONObject() : new JSONObject((List<GIACPaytRequests>) StringFormatter.escapeHTMLInList(docSeqNoList));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";				
			}
		} catch(SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e) {
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
	
	private GIACDisbVouchers createVoucher(HttpServletRequest request){
		log.info("Parsing request parameters to voucher entity...");
		
		GIACDisbVouchers voucher = new GIACDisbVouchers();
		
		voucher.setGaccTranId(Integer.parseInt(request.getParameter("hidGaccTranId")));
		voucher.setGibrGfunFundCd(request.getParameter("txtFundCd"));
		voucher.setGibrBranchCd(request.getParameter("hidBranchCd"));
		voucher.setGoucOucId(Integer.parseInt(request.getParameter("hidGoucOucId")));
		voucher.setGprqRefId(request.getParameter("hidRefId").equals(null) || request.getParameter("hidRefId").equals("") ? null : Integer.parseInt(request.getParameter("hidRefId")));
		voucher.setReqDtlNo(request.getParameter("hidReqDtlNo").equals(null) || request.getParameter("hidReqDtlNo").equals("") ? null : Integer.parseInt(request.getParameter("hidReqDtlNo")));
		voucher.setParticulars(request.getParameter("txtParticulars"));
		voucher.setDvAmt(new BigDecimal(request.getParameter("localAmount").equals("") ? "0" : request.getParameter("localAmount"))); //same as localAmount
		voucher.setDvCreatedBy(request.getParameter("txtCreatedBy"));
		voucher.setDvFlag(request.getParameter("txtDVFlag"));
		System.out.println("dvFlag: " + voucher.getDvFlag());
		voucher.setPayee(request.getParameter("txtPayeeName"));
		voucher.setCurrencyCd((request.getParameter("hidCurrencyCd").equals("") || request.getParameter("hidCurrencyCd").equals(null)) ? null : Integer.parseInt(request.getParameter("hidCurrencyCd")));
		voucher.setDvNo((request.getParameter("txtDVNo").equals("") || request.getParameter("txtDVNo").equals(null)) ? null : Integer.parseInt(request.getParameter("txtDVNo")));
		voucher.setDvApprovedBy(request.getParameter("txtApprovedBy"));
		voucher.setDvTag((request.getParameter("dvTag").equals(null) || request.getParameter("dvTag").equals("")) ? request.getParameter("hidDVTag") : request.getParameter("dvTag"));
		voucher.setDvPref(request.getParameter("txtDVPref"));
		voucher.setPrintTag((request.getParameter("txtPrintTag").equals(null) || request.getParameter("txtPrintTag").equals("")) ? null : Integer.parseInt(request.getParameter("txtPrintTag")));
		voucher.setRefNo(request.getParameter("txtDVRefNo"));
		voucher.setPayeeNo((request.getParameter("hidPayeeNo").equals(null) || request.getParameter("hidPayeeNo").equals("")) ? null : Integer.parseInt(request.getParameter("hidPayeeNo")));
		voucher.setPayeeClassCd(request.getParameter("txtPayeeClassCd"));
		voucher.setDvFcurrencyAmt(new BigDecimal(request.getParameter("foreignAmount").equals("") ? "0" : request.getParameter("foreignAmount"))); //same as foreignCurrency
		voucher.setCurrencyRt(new BigDecimal(request.getParameter("txtCurrencyRt").equals("") ? "0" : request.getParameter("txtCurrencyRt")));
		voucher.setReplnishedTag(request.getParameter("hidReplenishedTag"));
		voucher.setGprqDocumentCd(request.getParameter("txtDocumentCd"));
		voucher.setGprqBranchCd(request.getParameter("txtBranchCd"));
		voucher.setGprqLineCd(request.getParameter("selLineCd"));
		voucher.setGprqDocYear(Integer.parseInt(request.getParameter("selDocYear")));
		voucher.setGprqDocMonth(Integer.parseInt(request.getParameter("selDocMonth")));
		voucher.setGprqDocSeqNo(Integer.parseInt(request.getParameter("txtDocSeqNo")));
		voucher.setOucCd(Integer.parseInt(request.getParameter("txtOucCd")));
		voucher.setOucName(request.getParameter("txtOucName"));
		voucher.setStrPrintDate(request.getParameter("txtPrintDate") + " " + request.getParameter("txtPrintTime"));
		voucher.setSeqFundCd(request.getParameter(""));
		voucher.setSeqBranchCd(request.getParameter(""));
		
		
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy K:mm:ss a");
			SimpleDateFormat sdf1 = new SimpleDateFormat("MM-dd-yyyy K:mm a");
			
			if(!(request.getParameter("txtDVDate").equals(null) || request.getParameter("txtDVDate").equals("") )){
				voucher.setDvDate(new SimpleDateFormat("MM-dd-yyyy").parse(request.getParameter("txtDVDate")));				
			}
			
			if(!(request.getParameter("txtCreateDate").equals(null) || request.getParameter("txtCreateDate").equals("") )){
				voucher.setCreateDate(sdf.parse(request.getParameter("txtCreateDate")));				
				voucher.setDvCreateDate(sdf.parse(request.getParameter("txtCreateDate")));
			}
			
			
			if(!(request.getParameter("txtPrintDate").equals(null) || request.getParameter("txtPrintDate").equals("") )){
				String printDate = request.getParameter("txtPrintDate") +" "+ request.getParameter("txtPrintTime");
				voucher.setPrintDate(sdf1.parse(printDate));				
			} 
			
			/*if(!(request.getParameter("hidApproveDate").equals(null) || request.getParameter("hidApproveDate").equals("") )){
				voucher.setDvApproveDate(sdf.parse(request.getParameter("hidApproveDate")));				
			} else */
			if(!(request.getParameter("txtApproveDate").equals(null) || request.getParameter("txtApproveDate").equals("") )){
				voucher.setDvApproveDate(sdf.parse(request.getParameter("txtApproveDate")));				
			} 
			
			if(!(request.getParameter("txtLastUpdate").equals(null) || request.getParameter("txtLastUpdate").equals("") )){
				voucher.setLastUpdate(sdf.parse(request.getParameter("txtLastUpdate")));				
			}
				
			System.out.println("dvDate: " + voucher.getDvDate());
			System.out.println("createDate: " + voucher.getCreateDate());
			System.out.println("printDate: " + voucher.getPrintDate());
			System.out.println("approvedate: " + voucher.getDvApproveDate());
			System.out.println("lastupdate: " + voucher.getLastUpdate());
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return voucher;
		
	}
		
}


