package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;

@WebServlet (name="PrintLossProfileController", urlPatterns={"/PrintLossProfileController"})
public class PrintLossProfileController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			if("printReportGicls211".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String claimDate = request.getParameter("claimDate");
				
				Map<String, Object> params = new HashMap<String, Object>();
				DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
				
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
				params.put("P_STARTING_DATE", request.getParameter("startingDate"));
				params.put("P_ENDING_DATE", request.getParameter("endingDate"));
				params.put("P_LOSS_DATE_FROM", request.getParameter("lossDateFrom"));
				params.put("P_LOSS_DATE_TO", request.getParameter("lossDateTo"));
				params.put("P_PARAM_DATE", request.getParameter("paramDate"));
				params.put("P_CLAIM_DATE", claimDate);
				params.put("P_EXTRACT", new BigDecimal(request.getParameter("extract")));
				
				if("GICLR212".equals(reportId) || "GICLR213".equals(reportId) || "GICLR218".equals(reportId)){
					params.put("P_STARTING_DATE", date.parse(request.getParameter("startingDate")));
					params.put("P_ENDING_DATE", date.parse(request.getParameter("endingDate")));
					params.put("P_LOSS_DATE_FROM", date.parse(request.getParameter("lossDateFrom")));
					params.put("P_LOSS_DATE_TO", date.parse(request.getParameter("lossDateTo")));
					params.put("P_EXTRACT", new BigDecimal(request.getParameter("extract")));
				}
				
				if("GICLR211".equals(reportId)){
					params.put("P_STARTING_DATE", date.parse(request.getParameter("startingDate")));
					params.put("P_ENDING_DATE", date.parse(request.getParameter("endingDate")));
					params.put("P_LOSS_DATE_FROM", date.parse(request.getParameter("lossDateFrom")));
					params.put("P_LOSS_DATE_TO", date.parse(request.getParameter("lossDateTo")));
					params.put("P_EXTRACT", new BigDecimal(request.getParameter("extract")));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
					params.put("csvAction", "printGICLR211");
					params.put("packageName", "CSV_LOSS_PROFILE");
					params.put("functionName", "CSV_GICLR211");
					
					System.out.println();
				}
				
				if("GICLR215".equals(reportId)){
					params.put("P_STARTING_DATE", date.parse(request.getParameter("startingDate")));
					params.put("P_ENDING_DATE", date.parse(request.getParameter("endingDate")));
					params.put("P_LOSS_DATE_FROM", date.parse(request.getParameter("lossDateFrom")));
					params.put("P_LOSS_DATE_TO", date.parse(request.getParameter("lossDateTo")));
					params.put("P_EXTRACT", new BigDecimal(request.getParameter("extract")));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
					params.put("csvAction", "printGICLR215");
					params.put("packageName", "CSV_LOSS_PROFILE");
					params.put("functionName", "CSV_GICLR215");
					if("Claim File Date".equals(claimDate)){
						params.put("P_LOSS_SW", "FD");
					}else if("Loss Date".equals(claimDate)){
						params.put("P_LOSS_SW", "LD");
					}
				}
				
				if("GICLR214".equals(reportId) || "GICLR216".equals(reportId) || "GICLR217".equals(reportId)){
					params.put("P_LINE", request.getParameter("lineCd"));
					params.put("P_SUBLINE", request.getParameter("sublineCd"));
					params.put("P_USER", USER.getUserId());
				}
				
				System.out.println("GICLS211 Report Id: "+ reportId +" params: "+ params);
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports/lossprofile")+"/";
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				System.out.println("GICLS211 complete params: "+ params);
				
				this.doPrintReport(request, response, params, reportDir);
			}
		}catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
