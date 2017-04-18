package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="PrintNoClaimCertificateController", urlPatterns={"/PrintNoClaimCertificateController"})
public class PrintNoClaimCertificateController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(PrintNoClaimCertificateController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		try{
			if ("showPrintNC".equals(ACTION)) {
				System.out.println(":::::::::::::::::::::PRINT CONTROLLER::::::::::::::::::::::::::::::::");
				String reportVersion = request.getParameter("reportVersion");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != printers.length - 1){
						printerNames = printerNames + ",";
					}
				}
				request.setAttribute("printerNames", printerNames);
				request.setAttribute("reportVersion", reportVersion);
				PAGE = "/pages/claims/noClaim/subPages/printNoClaimCertificate.jsp";
				this.doDispatch(request, response, PAGE);
			}else if("showSamplePrinting".equals(ACTION)){ 
				System.out.println("############### PRINTING SAMPLE #######################");
				String reportVersion = request.getParameter("reportVersion");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != printers.length - 1){
						printerNames = printerNames + ",";
					}
				}
				request.setAttribute("printerNames", printerNames);
				request.setAttribute("reportVersion", reportVersion);
				PAGE = "/pages/claims/noClaimMultiYy/subNoClaimMultiYy/samplePrinting.jsp";
				this.doDispatch(request, response, PAGE);
				
			}else if ("populateSamplePrinting".equals(ACTION)){
				System.out.println("############################ POPULATE SAMPLE PRINTING ###############################");
				ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
			
				String reportId = "GIEXR101A";
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = (reportVersion == null ? reportId :  reportId+"_"+reportVersion);
				String reportFont = reportParam.getDefaultReportFont();
				String subreportDir = "";
				
				String reportLocation = "/com/geniisys/giex/reports/";
				subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportLocation+"/")+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("P_FONT_SW", reportFont);

				Integer policyId = null;
				Integer assdNo = null;
				Integer intmNo = null;
				String issCd = "";
				String sublineCd = "";
				String lineCd = "";
				String endingDate = "";
				String startingDate = "";
				String includePack = "";
				String claimsFlag = "";
				String balanceFlag = "";
					
				
				params.put("P_POLICY_ID",policyId);
				params.put("P_ASSD_NO",assdNo);
				params.put("P_INTM_NO",intmNo);
				params.put("P_ISS_CD",issCd);
				params.put("P_SUBLINE_CD",sublineCd);
				params.put("P_LINE_D",lineCd);
				params.put("P_ENDING_DATE",endingDate);
				params.put("P_STARTING_DATE",startingDate);
				params.put("p_include_pack",includePack);
				params.put("p_claims_flag",claimsFlag);
				params.put("p_balance_flag",balanceFlag);
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", ("CNC - 123").replaceAll(" ", ""));
				params.put("reportName", reportName);
				params.put("pageHeight",792);
				params.put("pageWidth",990);
				params.put("rightMargin", 0);
				params.put("leftMargin",0);
				params.put("topMargin",0);
				params.put("bottomMargin",0);
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}else if ("populateGICLR026B".equals(ACTION)) {
				log.info("populateGICLR026B...");
				
				ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				String noClaimNo = request.getParameter("noClaimNo");
				
				String reportId = "GICLR026B";
				String reportVersion = reportsService.getReportVersion(reportId);
				//String reportVersion = "RSIC";
				String reportName = (reportVersion == null ? reportId :  reportId+"_"+reportVersion);
				String reportFont = reportParam.getDefaultReportFont();
				String subreportDir = "";
				
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");		
				
				params.put("P_FONT_SW", reportFont);
				params.put("P_NO_CLAIM_ID", Integer.parseInt(request.getParameter("noClaimId") == null? null : request.getParameter("noClaimId")));
				params.put("P_REPORT_ID", reportId);

				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", ("CNC - "+noClaimNo).replaceAll(" ", ""));
				params.put("reportName", reportName);
				
				this.doPrintReport(request, response, params, subreportDir);
				
			} else if ("populateGICLR026".equals(ACTION)) {
				log.info("populateGICLR026...");
				
				ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				String noClaimNo = request.getParameter("noClaimNo");
				
				String reportId = "GICLR026";
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = (reportVersion == null ? reportId :  reportId+"_"+reportVersion);
				String reportFont = reportParam.getDefaultReportFont();
				String subreportDir = "";
				
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				
				params.put("P_FONT_SW", reportFont);
				params.put("P_NO_CLAIM_ID", Integer.parseInt(request.getParameter("noClaimId")));
				// added by shan 10.16.2013
				params.put("P_NC_TAG1", request.getParameter("ncTag1"));
				params.put("P_NC_TAG2", request.getParameter("ncTag2"));
				params.put("P_NC_TAG3", request.getParameter("ncTag3"));
				params.put("P_NC_TAG4", request.getParameter("ncTag4"));

				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", ("CNC - "+noClaimNo).replaceAll(" ", ""));
				params.put("reportName", reportName);
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}else if ("showPrintNC2".equals(ACTION)) {
				System.out.println(":::::::::::::::::::::PRINT CONTROLLER::::::::::::::::::::::::::::::::");
				String reportVersion = request.getParameter("reportVersion");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != printers.length - 1){
						printerNames = printerNames + ",";
					}
				}
				request.setAttribute("printerNames", printerNames);
				request.setAttribute("reportVersion", reportVersion);
				PAGE = "/pages/claims/noClaimMultiYy/subNoClaimMultiYy/printNoClaimMulti.jsp";
				this.doDispatch(request, response, PAGE);
			}else if ("populateGICLR062".equals(ACTION)) {
				log.info("populateGICLR062...");
				
				ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				String noClaimNo = request.getParameter("noClaimNo");
				//String reportId = request.getParameter("reportId");
				String reportId = "GICLR062";
				//String fileName = request.getParameter("reportTitle").replaceAll(" ", "_");
				String reportVersion = reportsService.getReportVersion(reportId);
				//String reportVersion = "RSIC";
				String reportName = (reportVersion == null ? reportId :reportId+"_"+reportVersion);
				String reportFont = reportParam.getDefaultReportFont();
				String subreportDir = "";
				
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
								
				params.put("P_FONT_SW", reportFont);
				params.put("P_NO_CLAIM_ID", Integer.parseInt(request.getParameter("noClaimId")));
				params.put("P_POLICY_ID", Integer.parseInt(request.getParameter("policyId")));
				params.put("P_REPORT_ID",	reportId);

				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", ("CNC - "+noClaimNo).replaceAll(" ", ""));
				params.put("reportName", reportName);
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
