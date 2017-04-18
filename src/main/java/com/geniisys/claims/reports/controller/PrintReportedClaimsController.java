package com.geniisys.claims.reports.controller;

import java.io.IOException;
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

@WebServlet (name="PrintReportedClaimsController", urlPatterns="/PrintReportedClaimsController")
public class PrintReportedClaimsController extends BaseController{

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
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports/reportedclaims")+"/";
				Map<String, Object> params = new HashMap<String, Object>();
				DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
				
				if ("GICLR540".equals(reportId)) {
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports/reportedclaims")+"/";
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_LINE_NAME", request.getParameter("lineName"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("csvAction", "printGICLR540");
					params.put("packageName", "CSV_REPORTED_CLMS");
					params.put("functionName", "CSV_GICLR540");
				}else if ("GICLR541".equals(reportId)) {
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("csvAction", "printGICLR541");
					params.put("packageName", "CSV_REPORTED_CLMS");
					params.put("functionName", "CSV_GICLR541");
				}else if ("GICLR542".equals(reportId)) {
					params.put("P_ASSD_NO", request.getParameter("assdNo").equals("") ? null : Integer.parseInt(request.getParameter("assdNo")));
					params.put("P_ASSURED", request.getParameter("assdName"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_USER_ID", USER.getUserId());
					//start kenneth SR17610 08192015
					params.put("csvAction", "printGICLR542"); 
					params.put("packageName", "CSV_REPORTED_CLMS");
					params.put("functionName", "CSV_GICLR542");
					//end kenneth SR17610 08192015
				}else if ("GICLR542B".equals(reportId)) {
					params.put("P_ASSD_NO", request.getParameter("assdNo").equals("") ? null : Integer.parseInt(request.getParameter("assdNo")));
					params.put("P_ASSURED", request.getParameter("assdName"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_USER_ID", USER.getUserId());
					//start kenneth SR17610 08192015
					params.put("csvAction", "printGICLR542B");
					params.put("packageName", "CSV_REPORTED_CLMS");
					params.put("functionName", "CSV_GICLR542B");
					//end kenneth SR17610 08192015
				}else if ("GICLR543".equals(reportId)) {
					params.put("P_START_DT", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_END_DT", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_INTM_NO", request.getParameter("intmNo"));
					params.put("P_INTERMEDIARY", request.getParameter("intmName"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_INTM_TYPE", request.getParameter("intmType"));
					params.put("P_SUBAGENT", request.getParameter("subAgent"));
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("csvAction", "printGICLR543");
					params.put("packageName", "CSV_REPORTED_CLMS");
					params.put("functionName", "CSV_GICLR543");
				}else if ("GICLR544".equals(reportId)) {
					params.put("P_BRANCH", request.getParameter("branchName"));	
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_LINE", request.getParameter("lineName"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("csvAction", "printGICLR544");
					params.put("packageName", "CSV_REPORTED_CLMS");
					params.put("functionName", "CSV_GICLR544");
				}else if ("GICLR544B".equals(reportId)) {
					params.put("P_BRANCH", request.getParameter("branchName"));	
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_LINE", request.getParameter("lineName"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("csvAction", "printGICLR544B");
					params.put("packageName", "CSV_REPORTED_CLMS");
					params.put("functionName", "CSV_GICLR544B");
				}else if ("GICLR545".equals(reportId) || "GICLR545_CSV".equals(reportId)) { //Deo [01.11.2017]: added GICLR545_CSV (SR-5399)
					params.put("P_CLM_STAT_CD", request.getParameter("clmStatCd"));
					params.put("P_CLM_STAT_TYPE", request.getParameter("clmStatType"));
					params.put("P_START_DT", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_END_DT", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("csvAction", "printGICLR545"); //Deo [01.11.2017]: SR-5399
					params.put("createCSVFromString", "Y"); //Deo [01.11.2017]: SR-5399
				}else if ("GICLR545B".equals(reportId)||"GICLR545B_CSV".equals(reportId)) {//SR5400
					params.put("P_CLM_STAT_CD", request.getParameter("clmStatCd"));
					params.put("P_CLM_STAT_TYPE", request.getParameter("clmStatType"));
					params.put("P_START_DT", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_END_DT", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GICLR546".equals(reportId) || "GICLR546_CSV".equals(reportId)) { //Deo [02.13.2017]: added GICLR545_CSV (SR-23858)
					params.put("P_CLMSTAT_CD", request.getParameter("clmStatCd"));
					params.put("P_CLMSTAT_TYPE", request.getParameter("clmStatType"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_ISSUE_YY", request.getParameter("polIssueYy").equals("") ? null : Integer.parseInt(request.getParameter("polIssueYy")));
					params.put("P_LINE_CD", request.getParameter("polLineCd"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_POL_ISS_CD", request.getParameter("polIssCd"));
					params.put("P_POL_SEQ_NO", request.getParameter("polSeqNo").equals("") ? null : Integer.parseInt(request.getParameter("polSeqNo")));
					params.put("P_RENEW_NO", request.getParameter("polRenewNo").equals("") ? null : Integer.parseInt(request.getParameter("polRenewNo")));
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_SUBLINE_CD", request.getParameter("polSublineCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GICLR546B".equals(reportId) || "GICLR546B_CSV".equals(reportId)) {
					params.put("P_CLMSTAT_CD", request.getParameter("clmStatCd"));
					params.put("P_CLMSTAT_TYPE", request.getParameter("clmStatType"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_ISSUE_YY", request.getParameter("polIssueYy").equals("") ? null : Integer.parseInt(request.getParameter("polIssueYy")));
					params.put("P_LINE_CD", request.getParameter("polLineCd"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_POL_ISS_CD", request.getParameter("polIssCd"));
					params.put("P_POL_SEQ_NO", request.getParameter("polSeqNo").equals("") ? null : Integer.parseInt(request.getParameter("polSeqNo")));
					params.put("P_RENEW_NO", request.getParameter("polRenewNo").equals("") ? null : Integer.parseInt(request.getParameter("polRenewNo")));
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_SUBLINE_CD", request.getParameter("polSublineCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GICLR547".equals(reportId)) {
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_GROUPED_ITEM_TITLE", request.getParameter("groupedItemTitle"));
					params.put("P_CONTROL_CD", request.getParameter("controlCd"));
					params.put("P_CONTROL_TYPE_CD", request.getParameter("controlTypeCd").equals("") ? null : Integer.parseInt(request.getParameter("controlTypeCd")));
					params.put("P_CLM_STAT_CD", request.getParameter("clmStatCd"));
					params.put("P_CLM_STAT_TYPE", request.getParameter("clmStatType"));
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GICLR547B".equals(reportId) || "GICLR547B_CSV".equals(reportId)) { //SR-5404
					params.put("P_CLMSTAT_CD", request.getParameter("clmStatCd"));
					params.put("P_CLMSTAT_TYPE", request.getParameter("clmStatType"));
					params.put("P_CONTROL_CD", request.getParameter("controlCd"));
					params.put("P_CONTROL_TYPE_CD", request.getParameter("controlTypeCd"));
					params.put("P_END_DT", request.getParameter("toDate"));
					params.put("P_GROUPED_ITEM_TITLE", request.getParameter("groupedItemTitle"));	
					params.put("P_LOSS_EXP", request.getParameter("lossExp"));
					params.put("P_START_DT", request.getParameter("fromDate"));
					params.put("P_USER_ID", USER.getUserId());
				}

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
