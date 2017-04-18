package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="CashReceiptsReportPrintController", urlPatterns={"/CashReceiptsReportPrintController"})
public class CashReceiptsReportPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3369212691219421164L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try {
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/cashreceipt/reports")+"/";
				String reportName = reportId; // /*reportVersion == "" || reportVersion == null ? reportId : reportId+"_"+reportVersion;*/ removed reportVersion : shan 05.07.2014
				
				Map<String, Object> params = new HashMap<String, Object>();
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				
				if("GIARR01A".equals(reportId)){
					params.put("P_FUND_CD", request.getParameter("fundCd"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_CASHIER_CD", request.getParameter("cashierCd"));
					params.put("P_DCB_NO", Integer.parseInt(request.getParameter("dcbNo")));
					params.put("P_DCB_YEAR", request.getParameter("dcbYear"));
					params.put("P_TRAN_DT", request.getParameter("dspDate"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_REPORT_ID", reportId);
				    params.put("packageName", "GIARR001A_PKG");
				    params.put("csvAction", "printGIARR01A");
				    params.put("functionName", "CSV_GIARR01A");					
				} else if ("GIACR178".equals(reportId) || "GIACR178_CSV".equals(reportId)) { //modified by gab 06.27.2016
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_TRAN_POST", request.getParameter("tranPost"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_MODULE_ID", "GIACS178");
					params.put("P_USER_ID", USER.getUserId());
					reportName = reportId;
				}else if("GIACR117".equals(reportId) || "GIACR117B".equals(reportId)){	//Cash Receipt Register Reports
					Date fromDate = df.parse(request.getParameter("fromDate"));
					Date toDate = df.parse(request.getParameter("toDate"));
					params.put("packageName", "CSV_ACCTG");
					params.put("csvAction", "print"+reportId);
					if ("GIACR117".equals(reportId)) {
						params.put("functionName", "CASHRECEIPTSREGISTER_D");
					} else {
						params.put("functionName", "CASHRECEIPTSREGISTER_S");
					}
					params.put("P_DATE", fromDate);
					params.put("P_DATE2", toDate);
					params.put("P_BRANCH", request.getParameter("branchCd"));
					params.put("P_POST_TRAN_TOGGLE", request.getParameter("postTranToggle"));
					params.put("P_TRAN_CLASS", request.getParameter("tranClass"));
					params.put("P_PER_BRANCH", request.getParameter("perBranch"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR170".equals(reportId)) {	// Advanced Premium Payment Reports
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_DATE_TYPE", request.getParameter("dateType"));
					params.put("P_BRANCH", request.getParameter("branchParam"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("packageName", "CSV_AC_RCPT_REPORTS");  // added by carlo de guzman 3.07.2016
					params.put("functionName", "csv_giacr170");        // added by carlo de guzman 3.07.2016
					params.put("csvAction", "printGIACR170CSV");       // added by carlo de guzman 3.07.2016					
				/*Added by MarkS 02/15/2017 SR23838*/
				}else if ("GIACR170A".equals(reportId)) {	// Advanced Premium Payment Reports
					System.out.println("triggering");
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_DATE_TYPE", request.getParameter("dateType"));
					params.put("P_BRANCH", request.getParameter("branchParam"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("packageName", "CSV_AC_RCPT_REPORTS");  
					params.put("functionName", "csv_giacr170a");        
					params.put("csvAction", "printGIACR170aCSV");       
				/* end SR23838*/	
				}else if("GIACR093".equals(reportId) || "GIACR093A".equals(reportId) //PDC Register Reports
						 || "GIACR093A_CSV".equals(reportId)){	//CarloR SR-5519 06.28.2016
					params.put("P_AS_OF", request.getParameter("asOfDate"));
					params.put("P_CUT_OFF", request.getParameter("cutOffDate"));
					params.put("P_PDC", request.getParameter("pdc"));
					params.put("P_BEGIN_EXTRACT", request.getParameter("beginExtract"));
					params.put("P_END_EXTRACT", request.getParameter("endExtract"));
					params.put("P_USER", USER.getUserId());
		
					if ("GIACR093".equals(reportId)){
						params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					}
				}else if("GIACR281".equals(reportId) || "GIACR281_CSV".equals(reportId) || "GIACR281A_CSV".equals(reportId) || "GIACR281A".equals(reportId) || "GIACR282".equals(reportId) || "GIACR282A".equals(reportId)) { /*edited by MarkS 7.13.2016 SR5536*/
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_BANK_ACCT_CD", request.getParameter("bankAcctCd"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_TRAN_POST", request.getParameter("tranPost"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_MODULE_ID", "GIACS281");
				}else if("GIACR161".equals(reportId)){	//premium deposit report
					params.put("P_ASSD_NO", request.getParameter("assdNo"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_DEP_FLAG", request.getParameter("depFlag"));
					params.put("P_SWITCH", request.getParameter("switch"));
				}else if("GIACR078".equals(reportId)){	//Collection Analysis Report
					params.put("P_DATE_FROM", request.getParameter("fromDate") == "" || request.getParameter("fromDate") == null ? null : df.parse(request.getParameter("fromDate")));
					params.put("P_DATE_TO", request.getParameter("toDate") == "" || request.getParameter("toDate") == null ? null : df.parse(request.getParameter("toDate")));
					params.put("P_DATE_TAG", request.getParameter("dateTag"));
					params.put("P_REP_TYPE", request.getParameter("repType"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_INTM_NO", request.getParameter("intmNo") == "" || request.getParameter("intmNo") == null ? null : Integer.parseInt(request.getParameter("intmNo")));
					params.put("P_USER", USER.getUserId());
				}else if("GIACR019".equals(reportId)){	
					params.put("P_TRAN_ID", request.getParameter("tranId") == "" || request.getParameter("tranId") == null ? null : Integer.parseInt(request.getParameter("tranId")));
				}
				
				System.out.println(reportId + " PARAMS: " + params.toString());
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				
				this.doPrintReport(request, response, params, reportDir);
				
			}
		} catch (SQLException e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
