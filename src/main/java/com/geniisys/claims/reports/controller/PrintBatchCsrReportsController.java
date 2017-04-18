package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.geniisys.claims.reports.util.ClaimReportsPropertiesUtil;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;

@WebServlet(name="PrintBatchCsrReportsController", urlPatterns={"/PrintBatchCsrReportsController"})
public class PrintBatchCsrReportsController extends BaseController{

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {		
		try{
			if("printBCSRReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportLocation = ClaimReportsPropertiesUtil.claimsReports;
				String subreportDir = "";
				subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportLocation+"/")+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				Integer batchCsrId = Integer.parseInt(request.getParameter("batchCsrId"));
				params.put("P_BATCH_CSR_ID", batchCsrId);
				params.put("P_REPORT_ID", reportId);
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", request.getParameter("outTitle")+"_"+ batchCsrId);
				
				this.doPrintReport(request, response, params, subreportDir);
				PAGE = "/pages/genericMessage.jsp";
			}else if("printBatchSCSR".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String reportId = request.getParameter("reportId");
				String reportLocation = ClaimReportsPropertiesUtil.sCSRReports;
				String subreportDir = "";
				subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportLocation+"/")+"/";
				
				params.put("P_BATCH_DV_ID", request.getParameter("batchDvId"));
				params.put("P_TRAN_ID", request.getParameter("tranId"));
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_REPORT_ID", reportId);
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", request.getParameter("outTitle")+"_"+ request.getParameter("batchDvId"));
				
				this.doPrintReport(request, response, params, subreportDir);
				
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
