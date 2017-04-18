package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
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
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="SchedOfAppliedCommPrintController", urlPatterns="/SchedOfAppliedCommPrintController")
public class SchedOfAppliedCommPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8284500172317149193L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/cashreceipt/reports")+"/";
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_MODULE_ID", "GIACS414");
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_FROM", request.getParameter("fromDate"));
				params.put("P_TO", request.getParameter("toDate"));
				params.put("csvAction", "printGIACR414CSV");//added by carlo rubenecia SR-5354 -START
				params.put("packageName", "CSV_AC_RCPT_REPORTS");
				params.put("functionName", "csv_giacr414");//added by carlo rubenecia SR-5354 -end
				
				reportName = reportId;
				System.out.println(params);
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				
				this.doPrintReport(request, response, params, reportDir);
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
