/*Created by: Joanne
 *Date: 03.06.13
 *Description: For printing initial acceptance report */
package com.geniisys.giri.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.underwriting.reinsurance.reports.controller.ReinsuranceAcceptanceController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="InitialAcceptancePrintController", urlPatterns="/InitialAcceptancePrintController")
public class InitialAcceptancePrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(ReinsuranceAcceptanceController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			Map<String, Object> params = new HashMap<String, Object> ();
			String reportId = request.getParameter("reportId");
			String reportVersion = reportsService.getReportVersion(reportId);
			String reportDir = null;
			String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
			
			if("printGIRIR119".equals(ACTION)){
				log.info("CREATING REPORT : " + reportId);
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
				params.put("P_PAR_ID", Integer.parseInt(request.getParameter("parId")));
			}
			
			params.put("MAIN_REPORT", reportName+".jasper");
			params.put("OUTPUT_REPORT_FILENAME", reportName);
			params.put("reportTitle", request.getParameter("reportTitle"));
			params.put("reportName", reportName);
			
			Debug.print("Print " + reportId +  ": " + params);
			
			this.doPrintReport(request, response, params, reportDir);
			
		}catch(Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
