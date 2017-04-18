package com.geniisys.gipi.controllers;

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
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIPIPolbasicPrintController", urlPatterns={"/GIPIPolbasicPrintController"})
public class GIPIPolbasicPrintController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		try{
			if("printGipis130".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("P_DIST_FLAG", request.getParameter("distFlag"));
				params.put("userId", USER.getUserId());
				
				System.out.println("GIPIS130 Report Id: "+ reportId +" params: "+ params);
				//String reportsLocation = "/com/geniisys/underwriting/distribution/reports";
				//String reportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportsLocation+"/")+"/";
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/underwriting/distribution/reports")+"/";
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				params.put("SUBREPORT_DIR", reportDir);  // shan 04.23.2014
				System.out.println("GIPIS130 complete params: "+ params);
				
				if("GIUWR130".equals(reportId)){
					params.put("P_DIST_NO", request.getParameter("distNo"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					//added by robert SR  5290 01.29.2016
					params.put("P_USER_ID", USER.getUserId());
				    params.put("csvAction", "printGIUWR130CSV");
					params.put("packageName", "CSV_UW_INQUIRY_PKG");
				    params.put("functionName", "GET_GIUWR130");	
				} else if ("GIPIR130".equals(reportId)){
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				//	reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
					
					GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
					String version = reportsService.getReportVersion("GIPIR130");
					String reportName = (version == null || version.equals("CPI") ? reportId :  reportId+"_"+version);
					reportDir = (version == null || version.equals("CPI") ? getServletContext().getRealPath("WEB-INF/classes/com/geniisys/underwriting/distribution/reports")+"/" :  giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW"));
					params.put("P_DIST_NO", Integer.parseInt(request.getParameter("distNo")));
					params.put("MAIN_REPORT", reportName+".jasper");
					params.put("OUTPUT_REPORT_FILENAME", reportName);
					params.put("reportName", reportName);
					params.put("P_USER_ID", USER.getUserId());
				}
				
				this.doPrintReport(request, response, params, reportDir);
				
			}
		}catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}


}
