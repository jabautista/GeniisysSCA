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

@WebServlet (name="PrintOutstandingLOAController", urlPatterns="/PrintOutstandingLOAController")
public class PrintOutstandingLOAController extends BaseController{

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
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports")+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_START_DT", request.getParameter("fromDate"));
				params.put("P_END_DT", request.getParameter("toDate"));
				params.put("P_AS_OF_DT", request.getParameter("asOfDate"));
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
				params.put("P_CHOICE_DATE", request.getParameter("choiceDate"));
				params.put("P_USER_ID", USER.getUserId());

				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				System.out.println("Report Id: "+ reportId +" params: "+ params);
				
				this.doPrintReport(request, response, params, reportDir);
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
