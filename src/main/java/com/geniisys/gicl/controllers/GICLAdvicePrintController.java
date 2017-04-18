package com.geniisys.gicl.controllers;

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

@WebServlet (name="GICLAdvicePrintController", urlPatterns={"/GICLAdvicePrintController"})
public class GICLAdvicePrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 6908463729547976768L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {		
		try{
			if("printAdviceReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String fileName = request.getParameter("reportTitle").replaceAll(" ", "_");
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports")+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", fileName);
				params.put("reportName", reportId);
				
				params.put("P_CLAIM_ID", Integer.parseInt(request.getParameter("claimId")));
				params.put("P_ADVICE_ID", Integer.parseInt(request.getParameter("adviceId")));
				params.put("P_USER_ID", USER.getUserId());
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
