package com.geniisys.giac.controllers;

import java.io.File;
import java.io.IOException;
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

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACGeneralDisbReportService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIACGeneralDisbursementReportsController", urlPatterns={"/GIACGeneralDisbursementReportsController"})
public class GIACGeneralDisbursementReportsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private PrintServiceLookup printServiceLookup;
	
	@SuppressWarnings("static-access")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACGeneralDisbReportService giacGeneralDisbReportService = (GIACGeneralDisbReportService) APPLICATION_CONTEXT.getBean("giacGeneralDisbReportService");
			
			PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
			
			if("showDisbursementRegisterPage".equals(ACTION)){				
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/disbursementRegister/cashDisbursementRegister.jsp";
			} else if("showCheckRegisterPage".equals(ACTION)){
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/checkRegister/checkRegister.jsp";
			} else if("validateReportId".equals(ACTION)){
				GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				message = giisReportsService.validateReportId(request.getParameter("reportId"));
				PAGE = "/pages/genericMessage.jsp";
			} else if("showCheckReleaseReportPage".equals(ACTION)){
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/checkRelease/checkReleaseReport.jsp";
			} else if("showCommissionsPaidRegisterPage".equals(ACTION)){
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/commissionsPaidRegister/commissionsPaidRegister.jsp";
			} else if("showContingentProfitCommission".equals(ACTION)){
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/contingentProfitCommission/contingentProfitCommission.jsp";
			} else if("getGiacs512CutOffDate".equals(ACTION)){
				message = giacGeneralDisbReportService.getGiacs512CutOffDate(request.getParameter("year"));
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGiacs512BeforeExtract".equals(ACTION)){
				message = giacGeneralDisbReportService.validateGiacs512BeforeExtract(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGiacs512BeforePrint".equals(ACTION)){
				message = giacGeneralDisbReportService.validateGiacs512BeforePrint(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("cpcExtractPremComm".equals(ACTION)){
				Map<String, Object> extractedPremComm = new HashMap<String, Object>();
				extractedPremComm = giacGeneralDisbReportService.cpcExtractPremComm(request, USER.getUserId());
				JSONObject json = extractedPremComm != null ? new JSONObject(extractedPremComm) : new JSONObject();
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("cpcExtractOsDtl".equals(ACTION)){
				Map<String, Object> extractedOsDtl = new HashMap<String, Object>();
				extractedOsDtl = giacGeneralDisbReportService.cpcExtractOsDtl(request, USER.getUserId());
				JSONObject json = extractedOsDtl != null ? new JSONObject(extractedOsDtl) : new JSONObject();
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("cpcExtractLossPaid".equals(ACTION)){
				Map<String, Object> extractedLossPaid = new HashMap<String, Object>();
				extractedLossPaid = giacGeneralDisbReportService.cpcExtractLossPaid(request, USER.getUserId());
				JSONObject json = extractedLossPaid != null ? new JSONObject(extractedLossPaid) : new JSONObject();
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showExpenseReportPerDept".equals(ACTION)){
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/expenseReportPerDept/expenseReportPerDept.jsp";
			}else if("getGiacs190SlTypeCd".equals(ACTION)){
				message = giacGeneralDisbReportService.getGiacs190SlTypeCd();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showCommissionsDue".equals(ACTION)) {
				PAGE = "/pages/accounting/generalDisbursements/reports/commissionsDue/commissionsDue.jsp";
			}else if ("showViewBankFiles".equals(ACTION)) {
				JSONObject json = giacGeneralDisbReportService.showBankFiles(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonBankFilesList", json);
					PAGE = "/pages/accounting/generalDisbursements/reports/commissionsDue/subPages/viewBankFiles.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("checkViewRecords".equals(ACTION)) {
				message = giacGeneralDisbReportService.checkViewRecords(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("invalidateBankFile".equals(ACTION)) {
				giacGeneralDisbReportService.invalidateBankFile(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("processViewRecords".equals(ACTION)) {
				//JSONObject json = giacGeneralDisbReportService.showViewRecords(request);	// AFP SR-18481 : shan 05.21.2015
				request.setAttribute("action", ACTION);
				if(request.getParameter("refresh") == null) {
					giacGeneralDisbReportService.processViewRecords(request, USER);	// start AFP SR-18481 : shan 05.21.2015
					JSONObject json = giacGeneralDisbReportService.showViewRecords(request);
					request.setAttribute("jsonRecordsList", json);	// end AFP SR-18481 : shan 05.21.2015
					PAGE = "/pages/accounting/generalDisbursements/reports/commissionsDue/subPages/viewRecords.jsp";
				} else {
					JSONObject json = giacGeneralDisbReportService.showViewRecords(request);	// AFP SR-18481 : shan 05.21.2015
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("viewRecordsViaBankFile".equals(ACTION)) {
				JSONObject json = giacGeneralDisbReportService.showViewRecordsViaBankFile(request);
				request.setAttribute("action", ACTION);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonRecordsList", json);
					PAGE = "/pages/accounting/generalDisbursements/reports/commissionsDue/subPages/viewRecords.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("viewDetailsViaRecords".equals(ACTION)) {
				JSONObject json = giacGeneralDisbReportService.showViewDetailsViaRecords(request);
				request.setAttribute("action", ACTION);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonDetailsList", json);
					PAGE = "/pages/accounting/generalDisbursements/reports/commissionsDue/subPages/viewDetails.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}				
			}else if ("viewDetailsViaBankFiles".equals(ACTION)) {
				JSONObject json = giacGeneralDisbReportService.showViewDetailsViaBankFiles(request);
				request.setAttribute("action", ACTION);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonDetailsList", json);
					PAGE = "/pages/accounting/generalDisbursements/reports/commissionsDue/subPages/viewDetails.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("generateBankFile".equals(ACTION)) {
				message = giacGeneralDisbReportService.generateBankFile(request, USER);
				PAGE = "/pages/genericMessage.jsp";				
			}else if ("getDetailsTotalViaRecords".equals(ACTION)) {
				message = (new JSONObject(giacGeneralDisbReportService.getDetailsTotal(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("generateSummaryForBank".equals(ACTION)) {
				message = giacGeneralDisbReportService.generateSummaryForBank(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("deleteSummaryForBankFile".equals(ACTION)) {
				String realPath = request.getSession().getServletContext().getRealPath("");
				String url = request.getParameter("url");
				String fileName = url.substring(url.lastIndexOf("/") + 1, url.length());
				(new File(realPath + "\\ups\\" + fileName)).delete();
			}else if ("getTotal".equals(ACTION)) {
				message = (new JSONObject(giacGeneralDisbReportService.getTotal(request))).toString();
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
