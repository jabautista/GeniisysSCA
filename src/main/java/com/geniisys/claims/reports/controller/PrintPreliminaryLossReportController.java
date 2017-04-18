package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;
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

@WebServlet(name="PrintPreliminaryLossReportController", urlPatterns={"/PrintPreliminaryLossReportController"})
public class PrintPreliminaryLossReportController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(PrintPreliminaryLossReportController.class);

	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			if("printPreLossRep".equals(ACTION)) {
				log.info("Printing Preliminary Loss Report...");
				
				Integer claimId = Integer.parseInt(request.getParameter("claimId") == null || "".equals(request.getParameter("claimId")) ? "0" : request.getParameter("claimId"));
				String lineCd = request.getParameter("lineCd");
				String reportId = request.getParameter("reportId");
				
				String reportName = "GICLR029_MAIN";
				String filename = "PLR-" + request.getParameter("claimNo");
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports")+"/";
				Date generatedDate = new Date();
				
				System.out.println("subreportDir: " + subreportDir);
				System.out.println("date: " + generatedDate);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_CLAIM_ID", claimId);
				params.put("P_LINE_CD", lineCd);
				params.put("P_REPORT_ID", reportId);
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
				
				Debug.print("Preliminary Loss Report Params: "+ params);
				
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
