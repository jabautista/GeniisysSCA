package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="PrintBatchOsAcctngEntriesController", urlPatterns={"/PrintBatchOsAcctngEntriesController"})
public class PrintBatchOsAcctngEntriesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(PrintBatchOsAcctngEntriesController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try{
			if ("printBatchOsAcctngEntries".equals(ACTION)) {
				log.info("printBatchOsAcctngEntries...");
				
				ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = new HashMap<String, Object>();
				Date tranDate =df.parse(request.getParameter("tranDate"));
				String tranId = request.getParameter("tranId").replaceAll(" ", "");
//				Timestamp tranDateFinal = new Timestamp(tranDate.getTime()) ; //remove by steven 7/26/2013
				
				String reportId = "GICLR207";
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = (reportVersion == null ? reportId :  reportId+"_"+reportVersion);
				String reportFont = reportParam.getDefaultReportFont();
				String subreportDir = "";
				
				String reportLocation = "/com/geniisys/claims/reports/";
				subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportLocation+"/")+"/";
				
				params.put("P_FONT_SW", reportFont);
				//params.put("P_TRAN_ID", Integer.parseInt(tranId)); changed by: Kenneth L. 12.17.2014
				params.put("P_TRAN_ID", tranId);
				
//				params.put("P_TRAN_DATE", tranDateFinal); //remove by steven 7/26/2013
				Calendar cal = Calendar.getInstance();
				cal.setTime(tranDate);
				params.put("P_MONTH", cal.get(Calendar.MONTH)+1);
				params.put("P_YEAR", cal.get(Calendar.YEAR));
	
				params.put("MAIN_REPORT", reportName+".jasper");
				//params.put("OUTPUT_REPORT_FILENAME", (reportId+"-"+tranId).replaceAll(" ", "")); changed by: Kenneth L. 12.17.2014
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportName);
				
				this.doPrintReport(request, response, params, subreportDir);
			} 
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
