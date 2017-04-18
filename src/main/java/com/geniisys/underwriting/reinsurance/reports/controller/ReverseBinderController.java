package com.geniisys.underwriting.reinsurance.reports.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.underwriting.certificates.reports.controller.PrintPolicyCertificatesController;
import com.seer.framework.util.ApplicationContextReader;

public class ReverseBinderController extends BaseController{

	private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(PrintPolicyCertificatesController.class);
	

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try{
			if ("printBinderReport".equals(ACTION)) {
				log.info("Printing binder report...");
				
				ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				Map<String, Object> params = new HashMap<String, Object>();
				
				String lineCd = request.getParameter("lineCd");
				Integer binderYy = request.getParameter("binderYy")== null ? 0 : Integer.parseInt(request.getParameter("binderYy"));
				Integer binderSeqNo = request.getParameter("binderSeqNo")== null ? 0 : Integer.parseInt(request.getParameter("binderSeqNo"));
				String reportFont = reportParam.getDefaultReportFont();
				String reportName = "GIRIR001_MAIN";
				String subreportDir = "";
				
				String reportLocation = "/com/geniisys/underwriting/reinsurance/reports/";
				subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportLocation+"/")+"/";
				
				params.put("P_FONT_SW", reportFont);
				params.put("P_LINE_CD", lineCd);
				params.put("P_BINDER_YY", binderYy);
				params.put("P_BINDER_SEQ_NO", binderSeqNo);

				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", 	"BINDER_"+lineCd+"-"+binderYy+"-"+binderSeqNo);
				params.put("reportName", reportName);
				
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
