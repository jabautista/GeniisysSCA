package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jasperreports.engine.JRException;

import com.geniisys.claims.reports.util.ClaimReportsPropertiesUtil;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;

@WebServlet(name="PrintFinalLossReportController", urlPatterns="/PrintFinalLossReportController")
public class PrintFinalLossReportController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {		
		try{
			Map<String, Object> params = new HashMap<String, Object> ();
			String subreportDir = null;
			
			if("printFinalLossReport".equals(ACTION)){
				Integer claimId = Integer.parseInt(request.getParameter("claimId"));
				String reportName = "GICLR034";
				subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+ClaimReportsPropertiesUtil.claimsReports)+"/";
				
				params.put("P_CLAIM_ID", claimId);
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportName", reportName);
				Debug.print("Print Final Loss Report Params: "+params);
			}
			
			this.doPrintReport(request, response, params, subreportDir);
			
		} catch (JRException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (SQLException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (IOException e) {	
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}
}
