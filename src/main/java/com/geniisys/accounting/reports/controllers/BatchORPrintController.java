package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="BatchORPrintController", urlPatterns={"/BatchORPrintController"})
public class BatchORPrintController extends BaseController{

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
		Logger log = Logger.getLogger(BatchORPrintController.class);
		
		try {
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				String reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				String reportName = reportVersion == null ? reportId : reportId+"_"+reportVersion;
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_OR_PREF", request.getParameter("orPref"));
				params.put("P_OR_NO", Integer.parseInt(request.getParameter("orNo")));
				params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("P_USER_ID", USER.getUserId());
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName + "_" + request.getParameter("gaccTranId"));
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				
				log.info("Printing OR " + request.getParameter("orPref") + "-" + request.getParameter("orNo"));
				this.doPrintReport(request, response, params, reportDir);
			}
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
