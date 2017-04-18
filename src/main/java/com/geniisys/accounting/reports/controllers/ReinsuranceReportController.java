package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
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



@WebServlet (name="ReinsuranceReportController", urlPatterns={"/ReinsuranceReportController"})
public class ReinsuranceReportController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2324941090709747612L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try {
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion;
				if (reportId.contentEquals(("GIACR137"))) {
					reportVersion = "";
				}else {
					reportVersion = reportsService.getReportVersion(reportId);
				}
				
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/reinsurance/reports")+"/";
				String reportName = reportVersion == "" || reportVersion == null ? reportId : reportId+"_"+reportVersion;
				SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = new HashMap<String, Object>();
				
				if("GIACR106".equals(reportId)){
					reportName = reportId;
					params.put("packageName", "CSV_ACCTG");
					params.put("csvAction", "print"+reportId);
					params.put("functionName", "OUTRISUBSLEDGER");
					//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_DATE_TYPE", request.getParameter("dateType"));
					params.put("P_FROM_DATE", sdf.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", sdf.parse(request.getParameter("toDate")));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
				}else if("GIACR105".equals(reportId)){
					reportName = reportId;
					params.put("packageName", "CSV_ACCTG");
					params.put("csvAction", "print"+reportId);
					params.put("functionName", "INFACRISUBSLEDGER");
					//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_DATE_TYPE", request.getParameter("dateType"));
					params.put("P_DATE_FROM", sdf.parse(request.getParameter("fromDate")));
					params.put("P_DATE_TO", sdf.parse(request.getParameter("toDate")));
					params.put("P_MODULE_ID", request.getParameter("moduleId")); //added by robert 01.08.2016 SR 5269
					params.put("P_USER_ID", USER.getUserId());  //added by robert 01.08.2016 SR 5269
				}else if ("GIACR171A".equals(reportId)) {		// -gzelle 06.19.2013
					reportName = reportId;
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR171".equals(reportId)) {		// -gzelle 06.20.2013
					reportName = reportId;
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR171B".equals(reportId)) {		// -gzelle 06.24.2013
					reportName = reportId;
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR137".equals(reportId)) {		// -gzelle 07.04.2013
					params.put("P_QUARTER", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
					params.put("P_CESSION_YEAR", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SHARE_CD", request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd")));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR137A".equals(reportId)) {		// -gzelle 07.05.2013
					params.put("P_QUARTER", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
					params.put("P_CESSION_YEAR", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SHARE_CD", request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd")));
					params.put("P_USER_ID", USER.getUserId());	
				}else if ("GIACR137B".equals(reportId)) {		// -gzelle 07.09.2013
					params.put("P_QUARTER", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
					params.put("P_CESSION_YEAR", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER_ID", USER.getUserId());	
				}else if ("GIACR137C".equals(reportId)) {		// -gzelle 07.15.2013
					params.put("P_QUARTER", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
					params.put("P_CESSION_YEAR", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER_ID", USER.getUserId());		
				}else if ("GIACR136".equals(reportId)) {		//Gzelle 07.19.2013
					params.put("P_CESSION_YEAR", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_QUARTER", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
					params.put("P_SHARE_CD", request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd")));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR136A".equals(reportId)) {		
					params.put("P_CESSION_YEAR", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_QUARTER", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
					params.put("P_SHARE_CD", request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd")));
					params.put("P_USER_ID", USER.getUserId());	
				}else if ("GIACR136B".equals(reportId)) {		
					params.put("P_CESSION_YEAR", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_QUARTER", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
					params.put("P_SHARE_CD", request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd")));
					params.put("P_USER_ID", USER.getUserId());						
				}else if ("GIACR136C".equals(reportId)) {		
					params.put("P_CESSION_YEAR", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_QUARTER", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
					params.put("P_SHARE_CD", request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd")));
					params.put("P_USER_ID", USER.getUserId());		
				}else if ("GIACR121".equals(reportId) || "GIACR121_CSV".equals(reportId)) { //add GIACR121_CSV CarloR SR5346 06.28.2016
					params.put("P_USER", USER.getUserId());
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));
				}else if ("GIACR121B".equals(reportId) || "GIACR121B_CSV".equals(reportId)) {
					params.put("P_AGING", request.getParameter("aging"));
					params.put("P_COMM", request.getParameter("comm"));
					params.put("P_CUT_OFF", request.getParameter("cutOffDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_USER", USER.getUserId());
				}else if ("GIACR121C".equals(reportId)) {
					params.put("P_CUT_OFF", request.getParameter("cutOffDate"));
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_USER", USER.getUserId());
				}else if ("GIACR164".equals(reportId)) {
					params.put("P_AGING", request.getParameter("aging"));
					params.put("P_COMM", request.getParameter("comm"));
					params.put("P_DATE_FROM", sdf.parse(request.getParameter("fromDate")));
					params.put("P_DATE_TO", sdf.parse(request.getParameter("toDate")));
					params.put("P_CUT_OFF", request.getParameter("cutOffDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_RI_CD", request.getParameter("riCd").equals("") ? null : Integer.parseInt(request.getParameter("riCd")));
					params.put("P_USER", USER.getUserId());
				}else if ("GIACR164C".equals(reportId)) {
					params.put("P_AGING", request.getParameter("aging"));
					params.put("P_COMM", request.getParameter("comm"));
					params.put("P_DATE_FROM", sdf.parse(request.getParameter("fromDate")));
					params.put("P_DATE_TO", sdf.parse(request.getParameter("toDate")));
					params.put("P_CUT_OFF", request.getParameter("cutOffDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_RI_CD", request.getParameter("riCd").equals("") ? null : Integer.parseInt(request.getParameter("riCd")));
					params.put("P_USER", USER.getUserId());
				}else if ("GIACR224".equals(reportId) || "GIACR224_CSV".equals(reportId)) { //CSV; Daniel Marasigan SR 5347 07.05.2016
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_CUT_OFF", request.getParameter("cutOffDate"));
					params.put("P_USER", USER.getUserId());
					params.put("P_RI_CD", request.getParameter("riCd").equals("") ? null : Integer.parseInt(request.getParameter("riCd")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
				}else if ("GIACR224C".equals(reportId)) {
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_CUT_OFF", request.getParameter("cutOffDate"));
					params.put("P_USER", USER.getUserId());
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));					
				}else if("GIACR119".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_P", request.getParameter("chkClmPayments"));
					params.put("P_TRAN_DATE1", request.getParameter("fromDate"));
					params.put("P_TRAN_DATE2", request.getParameter("toDate"));
				}else if("GIACR120".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_CANCEL_TAG", request.getParameter("cancelTag"));
					params.put("P_P", request.getParameter("chkClmPayments"));
					params.put("P_TRAN_DATE1", request.getParameter("fromDate"));
					params.put("P_TRAN_DATE2", request.getParameter("toDate"));
				}else if("GIACR181".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
				}else if("GIACR181A".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if("GIACR181B".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if("GIACR184".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
				}else if("GIACR180".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
				}else if("GIACR182".equals(reportId) || "GIACR188".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));
					params.put("P_USER_ID", USER.getUserId());
					
				//GIACS296 - SOA Outward Facultative Binders Reports
				}else if("GIACR296".equals(reportId) || "GIACR296A".equals(reportId) || "GIACR296B".equals(reportId)
						|| "GIACR296C".equals(reportId) || "GIACR296D".equals(reportId)){
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					
					if("GIACR296".equals(reportId)){
						params.put("csvAction", "printGIACR296Csv");
						params.put("displayCols", "getGIACR296CsvCols");
						params.put("packageName", "CSV_SOA");
						params.put("functionName", "CSV_GIACR296");
					} else if("GIACR296A".equals(reportId)){
						params.put("csvAction", "printGIACR296ACsv");
						params.put("displayCols", "getGIACR296ACsvCols");
						params.put("createCSVFromString", "Y");  // jhing GENQA 4099, 4100, 4102, 4101
						params.put("packageName", "CSV_SOA");
						params.put("functionName", "CSV_GIACR296A");
					} else if("GIACR296B".equals(reportId)){
						params.put("csvAction", "printGIACR296BCsv");
						params.put("displayCols", "getGIACR296BCsvCols");
						params.put("packageName", "CSV_SOA");
						params.put("functionName", "CSV_GIACR296B");
					} else if("GIACR296C".equals(reportId)){
						params.put("csvAction", "printGIACR296CCsv");
						params.put("displayCols", "getGIACR296CCsvCols");
						params.put("createCSVFromString", "Y");  // jhing GENQA 4099, 4100, 4102, 4101
						params.put("packageName", "CSV_SOA");
						params.put("functionName", "CSV_GIACR296C");
					} else if("GIACR296D".equals(reportId)){
						params.put("P_PAID", request.getParameter("paid"));
						params.put("P_UNPAID", request.getParameter("unpaid"));
						params.put("P_PARTPAID", request.getParameter("partial"));
						params.put("createCSVFromString", "Y");  // jhing GENQA 4099, 4100, 4102, 4101
						
						params.put("csvAction", "printGIACR296DCsv");
						params.put("displayCols", "getGIACR296DCsvCols");
						params.put("packageName", "CSV_SOA");
						params.put("functionName", "CSV_GIACR296D");
					}
				
				//GIACS279 - SOA Losses Recoverable Reports
				}else if("GIACR279".equals(reportId) || "GIACR279A".equals(reportId) || "GIACR279B".equals(reportId) || "GIACR279B_CSV".equals(reportId) //added GIACR279B_CSV CarloR SR5351 06.27.2016
						|| "GIACR279C".equals(reportId) || "GIACR279_CSV".equals(reportId)//Dren Niebres 05.24.2016 SR-5349
						|| "GIACR279A_CSV".equals(reportId) || "GIACR279C_CSV".equals(reportId)){ //CarloR SR-5350 06.24.2016 //CarloR SR5352 06.27.2016
					params.put("P_PAYEE_TYPE", request.getParameter("payeeType"));
					params.put("P_PAYEE_TYPE2", request.getParameter("payeeType2"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
				
				//GIACS274 - List of Binders Attached to Redistributed Records Report
				}else if("GIACR274".equals(reportId)){
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
				}else if("GIACR299".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_BOP", request.getParameter("bop"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_CUT_OFF_PARAM", request.getParameter("cutOffParam"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_TRAN_FLAG", request.getParameter("tranFlag")); //Added by Jerome Bautista 10.16.2015 SR 3892
					params.put("P_USER_ID", USER.getUserId());
					reportName = reportId;
				}else if("GIACR276".equalsIgnoreCase(reportId)){
					params.put("P_ISS_PARAM", !request.getParameter("issParam").equals("")&&request.getParameter("issParam") != null ? Integer.parseInt(request.getParameter("issParam")) : null);
					params.put("P_FROM", request.getParameter("fromDate"));
					params.put("P_TO", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
				} else if("GIACR276A".equalsIgnoreCase(reportId)){
					params.put("P_ISS_PARAM", !request.getParameter("issParam").equals("")&&request.getParameter("issParam") != null ? Integer.parseInt(request.getParameter("issParam")) : null);
					params.put("P_FROM", request.getParameter("fromDate"));
					params.put("P_TO", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
				} else if("GIACR277".equalsIgnoreCase(reportId) || "GIACR277_CSV".equalsIgnoreCase(reportId)){
					params.put("P_ISS_PARAM", request.getParameter("issParam"));
					params.put("P_FROM", request.getParameter("fromDate"));
					params.put("P_TO", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
				} else if("GIACR277A".equalsIgnoreCase(reportId)){
					params.put("P_ISS_PARAM", !request.getParameter("issParam").equals("")&&request.getParameter("issParam") != null ? new BigDecimal(request.getParameter("issParam")): null );
					params.put("P_FROM", request.getParameter("fromDate"));
					params.put("P_TO", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_USER_ID", USER.getUserId());
				} else if("GIACR221A".equals(reportId) || "GIACR222A".equals(reportId) || "GIACR223A".equals(reportId) || 
						"GIACR220".equals(reportId) || "GIACR221".equals(reportId) || "GIACR222".equals(reportId) || 
						"GIACR223".equals(reportId)) {					
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_TRTY_YY", (!request.getParameter("treatyYy").equals("")) ? Integer.parseInt(request.getParameter("treatyYy")) : null);
					params.put("P_SHARE_CD", (!request.getParameter("shareCd").equals("")) ? Integer.parseInt(request.getParameter("shareCd")) : null);
					params.put("P_TREATY_SEQ_NO", (!request.getParameter("trtySeqNo").equals("")) ? Integer.parseInt(request.getParameter("trtySeqNo")) : null);
					params.put("P_RI_CD", (!request.getParameter("riCd").equals("")) ? Integer.parseInt(request.getParameter("riCd")) : null);
					params.put("P_PROC_YEAR", (!request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("P_PROC_QTR", (!request.getParameter("qtr").equals("")) ? Integer.parseInt(request.getParameter("qtr")) : null);					
				}else if("GIACR183".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_FROM_DATE", sdf.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", sdf.parse(request.getParameter("toDate")));
					params.put("P_CUT_OFF_DATE", sdf.parse(request.getParameter("cutOffDate")));
				}else if("GIACR187".equals(reportId)){
					reportName = reportId;
					params.put("P_RI_CD", request.getParameter("riCd"));
					params.put("P_FROM_DATE", sdf.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", sdf.parse(request.getParameter("toDate")));
					params.put("P_CUT_OFF_DATE", sdf.parse(request.getParameter("cutOffDate")));
				}
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				System.out.println(reportName+" Report parameters::::: " +params.toString());
				
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
