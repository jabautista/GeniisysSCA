package com.geniisys.underwriting.maintenance.reports.controller;

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
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="MaintenanceReportsController", urlPatterns={"/MaintenanceReportsController"})
public class MaintenanceReportsController extends BaseController{


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		DataSourceTransactionManager client = null;
		client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		try {
			String reportId = request.getParameter("reportId");
			String reportVersion = reportsService.getReportVersion(reportId);
			String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/underwriting/maintenance/reports")+"/";
			String reportName = reportVersion == null ? reportId : reportId+"_"+reportVersion;
			Map<String, Object> params = new HashMap<String, Object>();

			if("printReport".equals(ACTION)){
				if("GIPIR803".equals(reportId)){
					params.put("P_USER_ID", USER.getUserId());
				}else if("GIPIR802".equals(reportId)){
					params.put("P_USER_ID", USER.getUserId());
				}
			}
			
			
			params.put("MAIN_REPORT", reportName+".jasper");
			params.put("OUTPUT_REPORT_FILENAME", reportName);
			params.put("reportTitle", request.getParameter("reportTitle"));
			params.put("reportName", reportName);
			
			this.doPrintReport(request, response, params, reportDir);
			
		} catch (SQLException e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} finally {
			ConnectionUtil.releaseConnection(client);
		}
	}
}
