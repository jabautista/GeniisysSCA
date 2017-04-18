package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
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

@WebServlet (name="EndOfMonthPrintReportController", urlPatterns={"/EndOfMonthPrintReportController"})
public class EndOfMonthPrintReportController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4052862338240276885L;

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {		
		try {
			if ("printReport".equals(ACTION)) {
				String reportId = request.getParameter("reportId");
				String fileName = reportId;	
				Map<String, Object> params = new HashMap<String, Object>();
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/endofmonth/reports")+"/";
				params.put("P_USER_ID", USER.getUserId());
				
				if ("GIACR044".equals(reportId)) {
					//concatenated branchCd as report's unique identifier when printing per branch report
					fileName = request.getParameter("branchCd").equals("") ? fileName : fileName+"_"+request.getParameter("branchCd");
					params.put("P_MM", Integer.parseInt(request.getParameter("mm")));
					params.put("P_YEAR", Integer.parseInt(request.getParameter("year")));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("packageName", "CSV_24TH_METHOD"); // added by carlo de guzman 3.10.2016 SR 5343
					params.put("functionName", "csv_giacr044");    // added by carlo de guzman 3.10.2016 SR 5343
					params.put("csvAction", "printGIACR044CSV");   // added by carlo de guzman 3.10.2016 SR 5343	
				}else if ("GIACR044R".equals(reportId)) {
					//concatenated branchCd as report's unique identifier when printing per branch report
					fileName = request.getParameter("branchCd").equals("") ? fileName : fileName+"_"+request.getParameter("branchCd");
					params.put("P_MM", Integer.parseInt(request.getParameter("mm")));
					params.put("P_YEAR", Integer.parseInt(request.getParameter("year")));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("packageName", "CSV_24TH_METHOD"); // added by carlo de guzman 3.14.2016 SR-5344
					params.put("functionName", "csv_giacr044R");    // added by carlo de guzman 3.14.2016 SR-5344
					params.put("csvAction", "printGIACR044RCSV");   // added by carlo de guzman 3.14.2016 SR-5344
				}else if("GIACR045".equals(reportId)){ //added by carlo rubenecia 04.06.2016 SR 5490 -START
					params.put("P_EXTRACT_YEAR", Integer.parseInt(request.getParameter("extractYear")));
					params.put("P_EXTRACT_MM", Integer.parseInt(request.getParameter("extractMm")));
					params.put("csvAction", "printGIACR045"); 
					params.put("packageName", "CSV_24TH_METHOD");
					params.put("functionName", "CSV_GIACR045");
					if(request.getParameter("reportType").equals("Premium Ceded")){
						params.put("P_REPORT_TYPE", "DPC");
					}else if(request.getParameter("reportType").equals("Commission Expense")){
						params.put("P_REPORT_TYPE", "DCE");
					}else if(request.getParameter("reportType").equals("Commission Income")){
						params.put("P_REPORT_TYPE", "DCI");
					}else{
						params.put("P_REPORT_TYPE", "DGP");
					}//added by carlo rubenecia 04.06.2016 SR 5490 -END
				}else if ("GIACR139".equals(reportId)) {
					SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_FROM_DATE", sdf.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", sdf.parse(request.getParameter("toDate")));
				}else if ("GIACR155".equals(reportId)) {
					SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_FROM_DATE", sdf.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", sdf.parse(request.getParameter("toDate")));
				}else if ("GIACR213".equals(reportId)) {
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_ISSUE_CODE", request.getParameter("chkIssueCode"));
					params.put("P_POLICY_ENDT", request.getParameter("policyType"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR216".equals(reportId)) {
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_ISSUE_CODE", request.getParameter("chkIssueCode"));
					params.put("P_POLICY_ENDT", request.getParameter("policyType"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR166".equals(reportId)) {
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_REPORT_ID", request.getParameter("repId"));
				}else if ("GIACR165".equals(reportId)) {
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_REPORT_ID", request.getParameter("repId"));
				}else if ("GIACR101".equals(reportId)) {
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_ISS_CD", request.getParameter("branchCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
					params.put("P_BRANCH_TYPE", request.getParameter("branchType"));
					params.put("P_USER_ID", USER.getUserId());
				}else if("GIACR102".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if("GIACR103".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR217".equals(reportId) || "GIACR219".equals(reportId)) {
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_FROM_ACCT_ENT_DATE", request.getParameter("fromDate"));
					params.put("P_TO_ACCT_ENT_DATE", request.getParameter("toDate"));
					params.put("P_INTM_NO", request.getParameter("intmNo"));
					params.put("P_INTM_TYPE", request.getParameter("intmType"));
					params.put("P_ISS_CRED", request.getParameter("issCred"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
				}else if ("GIACR275".equals(reportId) || "GIACR275A".equals(reportId)){
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));
					params.put("P_CUT_OFF_PARAM", request.getParameter("cutOffParam"));
					params.put("P_ISS_PARAM", request.getParameter("issParam"));
					
					params.put("P_DATE_PARAM", request.getParameter("dateParam"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_INTM_NO", request.getParameter("intmNo"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR122".equals(reportId) || "GIACR123".equals(reportId) || "GIACR124".equals(reportId) || "GIACR198".equals(reportId)
					   || "GIACR242".equals(reportId) || "GIACR243".equals(reportId) || "GIACR244".equals(reportId) || "GIACR245".equals(reportId)
					   || "GIACR246".equals(reportId) || "GIACR247".equals(reportId) || "GIACR248".equals(reportId) || "GIACR249".equals(reportId)
					   || "GIACR260".equals(reportId) || "GIACR261".equals(reportId) || "GIACR262".equals(reportId) || "GIACR263".equals(reportId)
					   || "GIACR218".equals(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_TOGGLE", request.getParameter("pToggle"));
					params.put("P_USER", USER.getUserId());
					System.out.println("GIACS128 params..............." + params);
				}else if("GIACR127".equals(reportId) || "GIACR129".equals(reportId) || "GIACR130".equals(reportId)){
					SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					params.put("P_DATE", sdf.parse(request.getParameter("dateParam")));
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/production/reports")+"/";
				}else if("GIACR131".equals(reportId) || "GIACR132".equals(reportId)){
					params.put("P_DATE", request.getParameter("dateParam"));
				}else if("GIACR134".equals(reportId)){
					params.put("P_DATE", request.getParameter("dateParam"));
					params.put("P_TRAN_DATE1", request.getParameter("fromDate"));
					params.put("P_TRAN_DATE2", request.getParameter("toDate"));
					params.put("P_YEAR", "");
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/production/reports")+"/";
				} else if ("GIACR354".equals(reportId) || "GIACR354_CLAIMS".equals(reportId)) { //Deo [02.02.2017]: SR-5923
					params.put("P_USER_ID", USER.getUserId());
					params.put("createCSVFromString", "Y");
					if ("GIACR354".equals(reportId)) {
						params.put("csvAction", "printGIACR354Prod");
					} else {
						params.put("csvAction", "printGIACR354Clm");
					}
				}
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", fileName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				
				this.doPrintReport(request, response, params, reportDir);			
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
