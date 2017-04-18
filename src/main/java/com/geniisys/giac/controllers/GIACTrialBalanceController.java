package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACTrialBalanceService;
import com.seer.framework.util.ApplicationContextReader;


@WebServlet (name="GIACTrialBalanceController", urlPatterns="/GIACTrialBalanceController")
public class GIACTrialBalanceController extends BaseController{

	private static final long serialVersionUID = 1L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACTrialBalanceService giacTrialBalanceService = (GIACTrialBalanceService) APPLICATION_CONTEXT.getBean("giacTrialBalanceService");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		try {
			
			if ("showTrialBalanceProcessing".equals(ACTION)) {
				PAGE = "/pages/accounting/endOfMonth/trialBalanceProcessing/trialBalanceProcessing.jsp";
			} else if ("validateTransactionDate".equals(ACTION)) {
				message = giacTrialBalanceService.validateTransactionDate(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkTranOpen".equals(ACTION)) {
				message = giacTrialBalanceService.checkTranOpen(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkDate".equals(ACTION)) {
				message = giacTrialBalanceService.checkDate(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("backUpGiacMonthlyTotals".equals(ACTION)) {
				String transactionDate = request.getParameter("transactionDate");
				giacTrialBalanceService.backUpGiacMonthlyTotals(transactionDate, USER.getUserId());
				message =  "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updateAcctransAe".equals(ACTION)) {
				String transactionDate = request.getParameter("transactionDate");
				String updateActionOpt = request.getParameter("updateActionOpt");
				giacTrialBalanceService.updateAcctransAe(transactionDate, updateActionOpt, USER.getUserId());
				message =  "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("genTrialBalance".equals(ACTION)) {
				String transactionDate = request.getParameter("transactionDate");
				message =  giacTrialBalanceService.genTrialBalance(transactionDate, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("printReportGiacs500".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_MONTH", request.getParameter("pMonth"));
				params.put("P_YEAR", request.getParameter("pYear"));
				
				System.out.println("Printing GIACR500/A parameters :::::::::::::::::: " + params);
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				
				//added by clperello | 06.06.2014
				params.put("packageName", "CSV_MONTHLY_TB");
				if("GIACR500".equals(reportId)) {
					params.put("functionName", "standard_report");
					params.put("csvAction", "printGIACR500");
				} else if ("GIACR500A".equals(reportId)) {
					params.put("functionName", "con_branches");
					params.put("csvAction", "printGIACR500A");
				}
				
				this.doPrintReport(request, response, params, reportDir);
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
			if(!"printReportGiacs500".equals(ACTION)){
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			}
		}
		
	}

}
