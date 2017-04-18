package com.geniisys.marketing.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.report.ReportGenerator;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.marketing.reports.util.MarketingReportsPropertiesUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class MarketingPrintController extends BaseController {
	
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(MarketingPrintController.class);	

	@Override
	@SuppressWarnings({ "unchecked", "unused", "static-access"})
	public void doProcessing(HttpServletRequest request, 
			HttpServletResponse response, 
			GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException { //, String env
		
		DataSourceTransactionManager client = null;
		
		try {
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			Map<String, Object> SESSION_PARAMETERS = (Map<String, Object>) SESSION.getAttribute("PARAMETERS");
			client =  (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager"); // +env
			GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");	
			MarketingReportsPropertiesUtil propsUtil = new MarketingReportsPropertiesUtil();
			ReportGenerator reportGenerator = new ReportGenerator();
			String lineCd = request.getParameter("vLineCd");
			String reportName = "";
			String reportId = request.getParameter("reportId");
			
			if(reportId == null || reportId.equalsIgnoreCase("")){				 
				reportId = propsUtil.getLineName(lineCd);
			}			
			
			if("print".equals(ACTION)){
				System.out.println("*** print action ***");
				
				Map<String, Object> params = new HashMap<String, Object>();
				
				/********* Report Query Parameters *********/
				int quoteId = Integer.parseInt(request.getParameter("quoteId"));
				String version = reportsService.getReportVersion(reportId, lineCd);
				reportName = reportId + (version != null ? "_" + version : "");
				System.out.println("reportId : " + reportId);
				System.out.println("version : " + version);
				System.out.println("reportName : " + reportName);
				params.put("P_QUOTE_ID", 			quoteId);
				
				//JSONObject objParams = new JSONObject(request.getParameter("params"));
				System.out.println("QUOTE ID: "+quoteId);
				System.out.println("Attention :  \u00f1" + StringFormatter.unescapeHtmlJava(request.getParameter("attentionTo")));
				
				params.put("P_ATTN_NAME", 		(request.getParameter("attentionTo")==null?"":request.getParameter("attentionTo")).replaceAll("ñ", "\u00f1"));
				params.put("P_ATTENTION", 		(request.getParameter("attentionTo")==null?"":request.getParameter("attentionTo")).replaceAll("ñ", "\u00f1")); // added by: Nica 06.25.2012
				params.put("P_ATTN_POSITION", 	(request.getParameter("attentionPosition")==null?"":request.getParameter("attentionPosition")).replaceAll("ñ", "\u00f1"));
				params.put("P_CLOSING_WORDS", 	(request.getParameter("closingWords")==null?"":request.getParameter("closingWords")).replaceAll("ñ", "\u00f1"));
				params.put("P_SIGNATORY", 		(request.getParameter("signatory")==null?"":request.getParameter("signatory")).replaceAll("ñ", "\u00f1"));
				params.put("P_DESIGNATION", 	(request.getParameter("designation")==null?"":request.getParameter("designation")).replaceAll("ñ", "\u00f1"));
				params.put("P_CONTACT_NO", 		(request.getParameter("contactNo")==null?"":request.getParameter("contactNo")).replaceAll("ñ", "\u00f1")); // added by: Nica 07.05.2012
				
				//String lineCd = request.getParameter("vLineCd");
				/********** End of Report Query Parameter ********/
				System.out.println("isPreview: "+request.getParameter("isPreview"));
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				String reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_MK");
				
				params.put("P_DRAFT", 				 Integer.parseInt(request.getParameter("isPreview")));				
				params.put("MAIN_REPORT", reportId+"_"+version+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", "Quotation_"+quoteId);
				params.put("reportTitle", 			request.getParameter("reportTitle"));
				params.put("reportName", 			reportName);				
				
				this.doPrintReport(request, response, params, reportDir);
	
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showPrintOptions".equals(ACTION)) {
				request.setAttribute("quoteId", request.getParameter("quoteId"));
				request.setAttribute("preview", request.getParameter("preview"));
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				this.doDispatch(request, response, "/pages/marketing/quotation/pop-ups/printOptions.jsp");
			} else if ("printMarketingReport".equals(ACTION)){
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/"+propsUtil.REPORTS_LOCATION_STATISTICAL)+"/";
				Map<String, Object> params = new HashMap<String, Object>();				
				
				params.put("mediaSizeName",          "US_STD_FANFOLD");
				params.put("P_DRAFT", 				 Integer.parseInt(request.getParameter("isPreview")));				
				params.put("MAIN_REPORT", 			 propsUtil.getReportFileName(reportId) +".jasper");
				params.put("OUTPUT_REPORT_FILENAME", propsUtil.getGeneratedReportFileName(reportId));
				params = updateReportParams(request, params, reportId);
				log.info("Marketing Report Parameters: "+params);
				
				this.doPrintReport(request, response, params, reportDir);
			}
		} catch (SQLException e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);			
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	private Map<String, Object> updateReportParams(HttpServletRequest request, Map<String, Object> params, String reportId) throws ParseException{
		if ("GIPIR909".equalsIgnoreCase(reportId)
				|| "GIPIR909A".equalsIgnoreCase(reportId)
				|| "GIPIR910".equalsIgnoreCase(reportId)){
			 DateFormat df = new SimpleDateFormat("MM-dd-yyyy"); // Nica 06.08.2012
			 params.put("P_FROM_DATE", request.getParameter("fromDate") == null ? null : df.parse(request.getParameter("fromDate")));
			 params.put("P_TO_DATE", request.getParameter("toDate") == null ? null : df.parse(request.getParameter("toDate")));
	     	 params.put("P_LINE", request.getParameter("lineCd"));
	     	 params.put("P_INTM_NO", request.getParameter("intmNo"));
		}
		return params;
	}
}