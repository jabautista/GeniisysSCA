package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;

@WebServlet (name="PrintBiggestClaimsController", urlPatterns="/PrintBiggestClaimsController")
public class PrintBiggestClaimsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_SESSION_ID", request.getParameter("sessionId"));
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
				params.put("P_ISS_CD", request.getParameter("branchCd"));
				params.put("P_INTM_NO", request.getParameter("intmNo"));
				params.put("P_ASSD_NO", request.getParameter("assdCedantNo"));
				params.put("P_DATE_AS", request.getParameter("asOfDate"));
				params.put("P_AMT", request.getParameter("claimAmt"));
				params.put("P_LOSS_EXP", request.getParameter("lossExpense")); //added by Aliza G. SR 5362
				//params.put("P_DATE", request.getParameter("claimDate"));
				//params.put("P_DATE_FR", request.getParameter("dateFrom"));
				//params.put("P_DATE_TO", request.getParameter("dateTo"));
				
				System.out.println("GICLS220 Report Id: "+ reportId +" params: "+ params);
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports")+"/";
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				params.put("P_FILE_TYPE", request.getParameter("fileType ")); //added by Aliza G. SR 5362
				params.put("csvAction", "printGICLR220");
				params.put("packageName", "CSV_BIG_CLMS");
				params.put("functionName", "CSV_GICLR220");			
				params.put("createCSVFromString", "Y");
				System.out.println("PrintBiggestClaims_GICLS220 complete params: "+ params); //Aliza G.				
				
				this.doPrintReport(request, response, params, reportDir);
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
