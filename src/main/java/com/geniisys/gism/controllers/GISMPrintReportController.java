//created by john dolon 10.08.2013
package com.geniisys.gism.controllers;

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
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GISMPrintReportController", urlPatterns={"/GISMPrintReportController"})
public class GISMPrintReportController extends BaseController{
	
	private static final long serialVersionUID = 8724202224406907688L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			String reportId = request.getParameter("reportId");
			String reportVersion = reportsService.getReportVersion(reportId);
			String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/sms/reports")+"/";
			String reportName = reportId;
			
			Map<String, Object> params = new HashMap<String, Object>();
			if("printReport".equals(ACTION)){
				//common parameters here
				
				if("GISMR012A".equalsIgnoreCase(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
				} else if("GISMR012B".equalsIgnoreCase(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_USER", request.getParameter("user"));
				}
			}
			
			System.out.println("params: "+params);
			params.put("MAIN_REPORT", reportName+".jasper");
			params.put("OUTPUT_REPORT_FILENAME", reportName);
			params.put("reportTitle", request.getParameter("reportTitle"));
			params.put("reportName", reportName);
			params.put("mediaSizeName", "US_STD_FANFOLD");
			System.out.println("params to jasper: " +params.toString());
			
			this.doPrintReport(request, response, params, reportDir);
		} catch (SQLException e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
