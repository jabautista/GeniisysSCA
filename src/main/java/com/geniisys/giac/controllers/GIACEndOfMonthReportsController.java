package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;

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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.giac.service.GIACEndOfMonthReportsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name= "GIACEndOfMonthReportsController", urlPatterns={"/GIACEndOfMonthReportsController"})
public class GIACEndOfMonthReportsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3239149713002866160L;
	
	private PrintServiceLookup printServiceLookup;

	@Override
	@SuppressWarnings("static-access")
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACEndOfMonthReportsService giacEndOfMonthReportsService = (GIACEndOfMonthReportsService) APPLICATION_CONTEXT.getBean("giacEndOfMonthReportsService");
			if ("showDistRegisterPerTreaty".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/distRegisterPerTreaty/distRegisterPerTreaty.jsp";
			}else if ("giacs138ExtractRecord".equals(ACTION)) {
				giacEndOfMonthReportsService.giacs138ExtractRecord(request,USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showProdRegisterPerPeril".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/prodRegisterPerPeril/prodRegisterPerPeril.jsp";
			}else if ("showSpecialReports".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/specialReports/specialReports.jsp";
			}else if ("showTaxDetailsRegister".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/taxDetailsRegister/taxDetailsRegister.jsp";
			}else if("showUndistributedPolicies".equals(ACTION)){
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/undistributedPolicies/undistributedPolicies.jsp";
			} else if("showIntermediaryProdPerIntm".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/intmProdRegister/intmProdRegPerIntm.jsp";
			} else if("showIntermediaryProdPerLine".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/intmProdRegister/intmProdRegPerLine.jsp";
			} else if("showDistRegisterPolicyPerPeril".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/distRegisterPolicyPerPeril/distRegisterPolicyPerPeril.jsp";
			} else if ("giacs128ExtractRecord".equals(ACTION)) {
				giacEndOfMonthReportsService.giacs128ExtractRecord(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showBatchReports".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/batchReports/batchReports.jsp";
			}else if ("getBatchBranchList".equals(ACTION)) {
				GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				JSONObject batchBranchList = giacBranchService.getBatchBranchList(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = batchBranchList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/endOfMonth/reports/batchReports/batchReportsBranchList.jsp";					
				}
			} else if ("showAcctgProdReports".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/endOfMonth/reports/batchReports/subPages/acctgProdReports.jsp";
			} else if("deleteGiacProdExt".equals(ACTION)){
				message = giacEndOfMonthReportsService.deleteGiacProdExt();
				PAGE = "/pages/genericMessage.jsp";
			} else if("insertGiacProdExt".equals(ACTION)){
				message = giacEndOfMonthReportsService.insertGiacProdExt(request, USER);
				PAGE = "/pages/genericMessage.jsp";	
			} else if("checkPrevExt".equals(ACTION)){
				message = giacEndOfMonthReportsService.checkPrevExt(USER);
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
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
