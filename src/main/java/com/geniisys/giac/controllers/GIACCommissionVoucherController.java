package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACCommissionVoucherService;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACCommissionVoucherController", urlPatterns="/GIACCommissionVoucherController")
public class GIACCommissionVoucherController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACCommissionVoucherService giacCommissionVoucherService = (GIACCommissionVoucherService) APPLICATION_CONTEXT.getBean("giacCommissionVoucherService");
			GIACModulesService giacModulesService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
			
			if("showGIACS155".equals(ACTION)) {
				PAGE = "/pages/accounting/generalDisbursements/reports/commissionVoucher/commissionVoucher.jsp";
			} else if ("populateCommVoucherTableGrid".equals(ACTION)) {
				JSONObject jsonCommVoucher = giacCommissionVoucherService.populateCommVoucherTableGrid(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCommVoucher.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonCommVoucher", jsonCommVoucher);
					PAGE = "/pages/accounting/generalDisbursements/reports/commissionVoucher/commissionVoucher.jsp";					
				}
			} else if ("showCommInvoice".equals(ACTION)) {
				JSONObject jsonCommInvoice = giacCommissionVoucherService.getGIACS155CommInvoiceDetails(request, USER);
				JSONObject jsonCommInvoiceTG = giacCommissionVoucherService.populateCommInvoiceTableGrid(request, USER);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCommInvoiceTG.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonCommInvoice", jsonCommInvoice);
					request.setAttribute("jsonCommInvoiceTG", jsonCommInvoiceTG);
					PAGE = "/pages/accounting/generalDisbursements/reports/commissionVoucher/commInvoice.jsp";					
				}
				
			} else if ("showCommPayables".equals(ACTION)) {
				JSONObject jsonCommPayables = giacCommissionVoucherService.getGIACS155CommPayables(request);
				request.setAttribute("jsonCommPayables", jsonCommPayables);
				PAGE = "/pages/accounting/generalDisbursements/reports/commissionVoucher/commPayables.jsp";
			} else if ("showCommPayments".equals(ACTION)) {
				JSONObject jsonCommPayments = giacCommissionVoucherService.getGIACS155CommPayments(request);
				System.out.println(jsonCommPayments);								
				if("1".equals(request.getParameter("refresh"))){
					message = jsonCommPayments.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonCommPayments", jsonCommPayments);
					PAGE = "/pages/accounting/generalDisbursements/reports/commissionVoucher/commPayments.jsp";					
				}
			} else if ("updateGIACS155CommVoucherExt".equals(ACTION)) {
				request.setAttribute("object", giacCommissionVoucherService.updateGIACS155CommVoucherExt(request, USER));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateUserFunc".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("user", USER.getUserId());
				params.put("funcCode", "OV");
				params.put("moduleName", "GIACS155");
				request.setAttribute("object", giacModulesService.validateUserFunc(params));			
			} else if ("getGIACS155GrpIssCd".equals(ACTION)) {
				String repId = request.getParameter("repId");
				request.setAttribute("object", giacCommissionVoucherService.getGIACS155GrpIssCd(USER.getUserId(), repId));
				PAGE = "/pages/genericObject.jsp";
			} else if ("saveCVNo".equals(ACTION)) {
				giacCommissionVoucherService.GIACS155SaveCVNo(request, USER);
			} else if ("removeIncludeTag".equals(ACTION)) {
				giacCommissionVoucherService.GIACS155RemoveIncludeTag(USER);
			}else if("showBatchCommVoucherPrinting".equals(ACTION)){
				GIACParameterFacadeService giacp = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("user", USER.getUserId());
				params.put("funcCode", "OV");
				params.put("moduleName", "GIACS155");
				
				request.setAttribute("printers", printers);
				request.setAttribute("cvOverrideTag", giacp.getParamValueV2("COMM_VOUCHER_OVERRIDE_TAG"));
				request.setAttribute("userHasOverride", giacModulesService.validateUserFunc(params));
				
				giacCommissionVoucherService.clearTempTable();
				if (request.getParameter("bankFileNo") != null){	// AFP SR-18481 : shan 05.21.2015
					JSONObject fundDetails = giacCommissionVoucherService.getGIACS251Fund();
					request.setAttribute("fundCd", fundDetails.get("fundCd"));
					request.setAttribute("fundDesc", fundDetails.get("fundDesc"));	
					request.setAttribute("bankFileNo", request.getParameter("bankFileNo"));
					
					JSONObject jsonCommDue = giacCommissionVoucherService.getCommDueList(request);
					request.setAttribute("commDueList", jsonCommDue);
				}
				PAGE = "/pages/accounting/generalDisbursements/reports/batchCommVoucherPrinting/batchCommVoucherPrinting.jsp";
			}else if("getBatchCV".equals(ACTION)){
				JSONObject json = giacCommissionVoucherService.getBatchCV(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCVSeqNo".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacCommissionVoucherService.getCVSeqNo(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			}else if("showCvDetailsOverlay".equals(ACTION)){
				JSONObject json = giacCommissionVoucherService.getCvDetails(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("cvDetailsJSON", json);
					request.setAttribute("cvPref", request.getParameter("cvPref"));
					request.setAttribute("cvNo", request.getParameter("cvNo"));
					PAGE = "/pages/accounting/generalDisbursements/reports/batchCommVoucherPrinting/overlay/cvDetailsOverlay.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("saveGenerateFlag".equals(ACTION)){
				giacCommissionVoucherService.saveGenerateFlag(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateCVNo".equals(ACTION)){
				giacCommissionVoucherService.generateCVNo(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBatchCVReports".equals(ACTION)){
				request.setAttribute("object", new JSONArray(giacCommissionVoucherService.getBatchReports()));
				PAGE = "/pages/genericObject.jsp";
			}else if("tagAll".equals(ACTION)){
				giacCommissionVoucherService.tagAll(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("untagAll".equals(ACTION)){
				giacCommissionVoucherService.untagAll();
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateTags".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacCommissionVoucherService.updateTags(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			}else if("checkPolicyStatus".equals(ACTION)){
				request.setAttribute("object", giacCommissionVoucherService.checkPolicyStatus(request));
				PAGE = "/pages/genericObject.jsp";
			}else if("getCommDueList".equals(ACTION)){	// start AFP SR-18481 : shan 05.21.2015
				JSONObject jsonCommDue = giacCommissionVoucherService.getCommDueList(request);
				
				message = jsonCommDue.toString();
				PAGE = "/pages/genericMessage.jsp";				
			}else if("getCommDueTotal".equals(ACTION)){
				BigDecimal totalNetCommDue = giacCommissionVoucherService.getCommDueTotal(request);
				message = totalNetCommDue.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCommDueListByParam".equals(ACTION)){
				JSONArray jsonCommDue = giacCommissionVoucherService.getCommDueListByParam(request);
				
				message = jsonCommDue.toString();
				PAGE = "/pages/genericMessage.jsp";				
			}else if("showCommDueDetailsOverlay".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIACS251CommDueDtl");
				params.put("intmNo", request.getParameter("intmNo"));
				
				Map<String, Object> commDueTG = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonCommDue = new JSONObject(commDueTG);
				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("commDueDetailsJSON", jsonCommDue);
					request.setAttribute("intmName", request.getParameter("intmName"));
					request.setAttribute("intmNo", request.getParameter("intmNo"));
					PAGE = "/pages/accounting/generalDisbursements/reports/batchCommVoucherPrinting/overlay/commDueDetailsOverlay.jsp";
				} else {					
					message = jsonCommDue.toString();
					PAGE = "/pages/genericMessage.jsp";	
				}			
			}else if("generateCVNoCommDue".equals(ACTION)){
				JSONObject json = giacCommissionVoucherService.generateCVNoCommDue(request);
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateCommDueCVToNull".equals(ACTION)){
				giacCommissionVoucherService.updateCommDueCVToNull(request);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCommDueDtlTotals".equals(ACTION)){
				JSONObject json = giacCommissionVoucherService.getCommDueDtlTotals(request);
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateCommDueTags".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacCommissionVoucherService.updateCommDueTags(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			}else if("showLastCVNoOverlay".equals(ACTION)){
				PAGE = "/pages/accounting/generalDisbursements/reports/batchCommVoucherPrinting/overlay/enterLastPrintedCV.jsp";
			}else if ("getNullCommDueCount".equals(ACTION)){
				message = giacCommissionVoucherService.getNullCommDueCount(request).toString();
				PAGE = "/pages/genericMessage.jsp";	// end AFP SR-18481 : shan 05.21.2015
			}else if("getTotalForPrintedCV".equals(ACTION)){ // bonok :: 1.16.2017 :: RSIC SR 23713
				JSONObject json = giacCommissionVoucherService.getTotalForPrintedCV(request, USER.getUserId());
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e){
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
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
		
	}

}
