package com.geniisys.underwriting.certificates.reports.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

public class PrintPolicyCertificatesController extends BaseController {

	private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(PrintPolicyCertificatesController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try{
			if("showPolicyCertPrintingPage".equals(ACTION)){
				log.info("Show Policy Certificates Printing Page");
				
				/*PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != (printers.length-1)){
						printerNames = printerNames + ",";
					}
				}
				request.setAttribute("printerNames", printerNames);*/
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				
				PAGE = "/pages/underwriting/reportsPrinting/policyCertificates/printPolicyCertificates.jsp";
				this.doDispatch(request, response, PAGE);
			
			}else if("printPolicyCertificate".equals(ACTION)){
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				Integer policyId = request.getParameter("policyId")== null ? 0 : Integer.parseInt(request.getParameter("policyId"));
				String reportId = request.getParameter("reportId");
				
				/*String reportName = policyCertUtil.getCertReportName(reportId) +"_"+ reportsService.getReportVersion("OTHERS_CERT");*/
				String reportName = reportId + "_" + reportsService.getReportVersion("OTHERS_CERT"); //policyCertUtil.getCertReportName(reportId) +"_"+ reportsService.getReportVersion("OTHERS_CERT");
				Map<String, Object> params = new HashMap<String, Object>();

				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				String subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
				
				params.put("P_POLICY_ID",   			policyId);
				params.put("MAIN_REPORT",   			reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", 	reportId+"_"+policyId);
				params.put("reportTitle", 				request.getParameter("reportTitle"));
				params.put("reportName", 				reportName);
				
				this.doPrintReport(request, response, params, subreportDir);
				
				PAGE = "/pages/genericMessage.jsp";
				
			}
		} catch (SQLException e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}
}
