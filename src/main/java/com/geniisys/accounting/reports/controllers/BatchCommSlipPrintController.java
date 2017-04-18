package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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

@WebServlet (name="BatchCommSlipPrintController", urlPatterns={"/BatchCommSlipPrintController"})
public class BatchCommSlipPrintController extends BaseController{

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
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		try {
			if("printCommSlip".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				String reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				String reportName = reportVersion == null ? reportId+"_COMMISSION_SLIP" : reportId+"_"+reportVersion;
				
				String tranId = request.getParameter("gaccTranId");
				String commSlipPref = request.getParameter("commSlipPref");
				String commSlipNo = request.getParameter("commSlipNo");
				String intmNo = request.getParameter("intmNo");
				String branchCd = request.getParameter("gaccBranchCd");
				Date commDate = request.getParameter("commSlipDate") == "" ? new Date() : df.parse(request.getParameter("commSlipDate"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_GACC_TRAN_ID", tranId);
				params.put("P_BRANCH_CD", branchCd);
				params.put("P_INTM_NO", intmNo);
				params.put("P_REPORT_ID", reportName);
				params.put("P_CS_NO", commSlipNo);
				params.put("P_CS_PREF", commSlipPref);
				params.put("P_CS_DATE", request.getParameter("commSlipDate"));
				params.put("P_COMM_SLIP_DATE", commDate);
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName + "_" + request.getParameter("recId"));
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				
				log.info("Printing Commission Slip " + request.getParameter("commSlipPref") + "-" + request.getParameter("commSlipNo"));
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
