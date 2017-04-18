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

@WebServlet (name="PremiumCollectionsPrintController", urlPatterns={"/PremiumCollectionsPrintController"})
public class PremiumCollectionsPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1289826174543395727L;

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
				//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				params.put("P_DATE", Integer.parseInt(request.getParameter("dateOpt")));
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_MODULE_ID", "GIACS284");
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_FROM_DATE", request.getParameter("fromDate"));
				params.put("P_TO_DATE", request.getParameter("toDate"));
				//params.put("P_FROM_DATE", sdf.parse(request.getParameter("fromDate")));
				//params.put("P_TO_DATE", sdf.parse(request.getParameter("toDate")));
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
