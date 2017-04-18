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
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="OfficialReceiptRegisterPrintController", urlPatterns="/OfficialReceiptRegisterPrintController")
public class OfficialReceiptRegisterPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3710504204012363466L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		DataSourceTransactionManager client = null;
		client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/reports")+"/";
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				
				Map<String, Object> params = new HashMap<String, Object>();
				/*params.put("packageName", "CSV_ACCTG");	Gzelle 12012015 moved below SR19822
				params.put("csvAction", "print"+reportId);*/
				
				if ("GIACR167".equals(reportId)) {
					params.put("functionName", "OFFICIALRECEIPTSREGISTER_AP");
					params.put("P_POSTED", 1);
				} else if ("GIACR168".equals(reportId)) {
					params.put("functionName", "OFFICIALRECEIPTSREGISTER_AP");
					params.put("P_POSTED", 2);
				} else if ("GIACR169".equals(reportId)) {
					params.put("functionName", "OFFICIALRECEIPTSREGISTER_U");
				}
				
				/* start - Gzelle 12012015 SR19822 */
				if (request.getParameter("displayTaxes").equals("Y")) {
					reportId = "GIACR168A";
					params.put("functionName", "OFFICIALRECEIPTSREGISTER_AP_A");
				}
				
				params.put("packageName", "CSV_ACCTG");
				params.put("csvAction", "print"+reportId);
				params.put("P_OR_TAG", request.getParameter("orTag"));
				/* end - Gzelle 12012015 SR19822 */				
				
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_MODULE_ID", "GIACS160");
				params.put("P_BRANCH_CODE", request.getParameter("branchCd"));
				params.put("P_DATE", request.getParameter("fromDate"));
				params.put("P_DATE2", request.getParameter("toDate"));
				
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
		} finally {
			ConnectionUtil.releaseConnection(client);
		}
	}
	
}
