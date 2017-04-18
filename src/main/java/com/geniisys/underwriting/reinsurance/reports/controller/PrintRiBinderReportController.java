package com.geniisys.underwriting.reinsurance.reports.controller;

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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;

@WebServlet(name="PrintRiBinderReportController", urlPatterns={"/PrintRiBinderReportController"})
public class PrintRiBinderReportController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(PrintRiBinderReportController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			if("printRIBinderReport".equals(ACTION)) {
				log.info("Printing RI Binder Report...");
				
				String lineCd = request.getParameter("lineCd");
				Integer binderYy = Integer.parseInt(request.getParameter("binderYy").replaceAll(" ", ""));
				Integer binderSeqNo = Integer.parseInt(request.getParameter("binderSeqNo").replaceAll(" ", ""));
				
				String reportName = "GIRIR001A_MAIN";
				String filename = reportName+"_"+lineCd+"-"+binderYy+"-"+binderSeqNo;
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/underwriting/reinsurance/reports/")+"/";
				
				System.out.println("subreportDir: " + subreportDir);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_LINE_V", lineCd);
				params.put("P_BINDER_YY_V", binderYy);
				params.put("P_BINDER_SEQ_NO_V", binderSeqNo);
				//params.put("P_PARAM_ATTN", "");
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
				
				Debug.print("RI Binder Report Params: "+ params);
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}
		}catch(SQLException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
