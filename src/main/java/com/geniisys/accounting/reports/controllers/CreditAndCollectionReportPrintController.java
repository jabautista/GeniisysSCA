package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="CreditAndCollectionReportPrintController",  urlPatterns={"/CreditAndCollectionReportPrintController"})
public class CreditAndCollectionReportPrintController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1912835730764039285L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try {
			String reportId = request.getParameter("reportId");
			String reportVersion = reportsService.getReportVersion(reportId);
			String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/creditandcollection/reports")+"/";
			String reportName = reportId;
			
			Map<String, Object> params = new HashMap<String, Object>();
			
			if("printReport".equals(ACTION)){
				
				// put all parameters that are common to all reports
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_INC_OVERDUE", request.getParameter("includeNotDue"));
				params.put("P_REMARKS", request.getParameter("soaRemarks"));
				params.put("P_INTM_TYPE", request.getParameter("intmType"));
				params.put("P_CUT_OFF", request.getParameter("cutOffDate"));
				params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
				params.put("P_BAL_AMT_DUE", (request.getParameter("outstandingBal") != null && !request.getParameter("outstandingBal").equals("")) ? new BigDecimal(request.getParameter("outstandingBal")) : null);
				params.put("P_INTM_NO", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);	// SR-3875_3569_3882_3574 : shan 06.19.2015
				//params.put("P_INTM_NO", request.getParameter("intmNo"));
				
				if("SOA_NET".equalsIgnoreCase(reportId)){
					System.out.println(reportVersion);
					reportName = (reportVersion != null && !reportVersion.equals("")) ? reportId+"_"+reportVersion : reportId;
					params.put("P_USER", USER.getUserId());
					params.put("P_OPT", request.getParameter("viewType"));
					//SR-5122_5126_5127 : comment by sherry 11.05.2015
					//params.put("P_NO", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
					if(request.getParameter("viewType").equals("I")){
						params.put("P_NO", request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("") ? Integer.parseInt(request.getParameter("intmNo")) : null);
					} else if(request.getParameter("viewType").equals("A")){
						params.put("P_NO", request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals("") ? Integer.parseInt(request.getParameter("assdNo")) : null);
					}
					//SR-5122_5126_5127 : sherry 11.05.2015
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				} else if("SOA".equalsIgnoreCase(reportId)){
					//reportName = (!reportVersion.equals("") && reportVersion != null) ? reportId+"_"+reportVersion : reportId;
					
					if(reportVersion != null && !reportVersion.equals("")){
						reportName = reportId+"_"+reportVersion;
					} else {
						reportName = reportId+"_CPI"; // to call the default report which is SOA_CPI.
					}
					
					if(request.getParameter("viewType").equals("I")){
						params.put("P_COL", request.getParameter("intmNo"));
						params.put("P_NAME", request.getParameter("intmName"));
						params.put("P_NO", request.getParameter("intmNo"));
					} else if(request.getParameter("viewType").equals("A")){
						params.put("P_COL", request.getParameter("assdNo"));
						params.put("P_NAME", request.getParameter("assdName"));
						params.put("P_NO", request.getParameter("assdNo"));
					}
					params.put("P_ACCT_OF_CD", "");
					params.put("P_DATE_FR", "");
					params.put("P_DATE_TO", "");
					params.put("P_SUB_NAME", "");
					params.put("P_SUB_NO", null);
					params.put("P_TAG", "");
					params.put("P_WHERE", "");
					params.put("P_OPT", request.getParameter("viewType"));
					params.put("P_USER", USER.getUserId());
					
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				} else if("GIACR199".equalsIgnoreCase(reportId)){
					params.put("P_INTM_NO", request.getParameter("intmNo"));	// SR-4016 : shan 06.19.2015
                    params.put("P_USER", USER.getUserId());
					params.put("csvAction", "printGIACR199Csv");
					params.put("packageName", "CSV_SOA");
					params.put("functionName", "CSV_GIACR199");
				} else if("GIACR196".equalsIgnoreCase(reportId)){
					
				} else if("GIACR193".equalsIgnoreCase(reportId) || "GIACR193_CSV".equalsIgnoreCase(reportId)){ //Dren 05.12.206 SR-5340
					params.put("P_INTM_NO", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
				} else if("GIACR193A".equalsIgnoreCase(reportId)){
					params.put("P_INTM_NO", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
					params.put("P_USER", USER.getUserId());
					params.put("csvAction", "printGIACR193ACsv");
					params.put("displayCols", "getGIACR193ACsvCols");
					params.put("packageName", "GIACR193A_PKG");
					params.put("functionName", "GET_GIACR193A_CSV");
				} else if("GIACR197".equalsIgnoreCase(reportId)){
					params.put("P_ASSD_NO", (request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals("")) ? Integer.parseInt(request.getParameter("assdNo")) : null);
					params.put("P_USER", USER.getUserId());
					params.put("P_MONTH", "");					
				} else if("GIACR197A".equalsIgnoreCase(reportId)){
					params.put("P_ASSD_NO", (request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals("")) ? /*Integer.parseInt(request.getParameter("assdNo"))*/request.getParameter("assdNo") : null);	// SR-3875_3569_3882_3574 : shan 06.19.2015
					params.put("P_USER", USER.getUserId());
				} else if("GIACR257".equalsIgnoreCase(reportId)){
					params.put("P_USER", USER.getUserId());
					params.put("P_MONTH", "");
				} else if("GIACR258".equalsIgnoreCase(reportId)){
					params.put("P_USER", USER.getUserId());
					params.put("P_MONTH", "");
				} else if("GIACR190E".equalsIgnoreCase(reportId)){
					params.put("P_USER", USER.getUserId());
				} else if("GIACR190".equalsIgnoreCase(reportId)){
					params.put("P_USER", USER.getUserId());
					params.put("P_MONTH", "");
					params.put("P_REP_ID", "GIACR190");
					params.put("csvAction", "printGIACR190Csv");
					params.put("displayCols", "getGIACR190CsvCols");
					params.put("packageName", "CSV_SOA");
					params.put("functionName", "CSV_GIACR190");
				} else if("GIACR189P".equalsIgnoreCase(reportId)){
					
				} else if("GIACR189".equalsIgnoreCase(reportId)){
					params.put("P_USER", USER.getUserId());
					params.put("P_MONTH", "");
					params.put("P_NO", "");
					params.put("P_ASSD_NO", (request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals("")) ? Integer.parseInt(request.getParameter("assdNo")) : null);
					params.put("P_INTM_NO", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
					params.put("P_REP_ID", "GIACR189");
					params.put("csvAction", "printGIACR189Csv");
					params.put("displayCols", "getGIACR189CsvCols");
					params.put("packageName", "CSV_SOA");
					params.put("functionName", "CSV_GIACR189");
					params.put("P_INCLUDE_PDC", request.getParameter("includePDC"));	// SR-4032 : shan 06.19.2015
				} else if("GIACR191".equalsIgnoreCase(reportId)){
					//params.put("P_ASSD_NO", request.getParameter("assdNo"));	// SR-3875_3569_3882_3574 : shan 06.19.2015
					params.put("P_ASSD_NO", (request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals("")) ? Integer.parseInt(request.getParameter("assdNo")) : null);
					params.put("P_USER", USER.getUserId());
					params.put("P_REP_ID", "GIACR191");
					params.put("csvAction", "printGIACR191Csv");
					params.put("displayCols", "getGIACR191CsvCols");
					params.put("packageName", "CSV_SOA");
					params.put("functionName", "CSV_GIACR191");
				} else if("GIACR191P".equalsIgnoreCase(reportId)){
					params.put("P_ASSD_NO", (request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals("")) ? /*Integer.parseInt(request.getParameter("assdNo"))*/ request.getParameter("assdNo") : null);	// SR-3875_3569_3882_3574 : shan 06.19.2015
					params.put("P_USER", USER.getUserId());
				} else if("GIACR192".equalsIgnoreCase(reportId)){
					params.put("P_USER", USER.getUserId());
					params.put("P_ASSD_NO", request.getParameter("assdNo"));
					params.put("P_REP_ID", "GIACR192");
					params.put("csvAction", "printGIACR192Csv");
					params.put("displayCols", "getGIACR192CsvCols");
					params.put("packageName", "CSV_SOA");
					params.put("functionName", "CSV_GIACR192");
				} else if("GIACR190A".equalsIgnoreCase(reportId)){
					//params.put("P_AGING_ID", (request.getParameter("agingId") != null && !request.getParameter("agingId").equals("")) ? Integer.parseInt(request.getParameter("agingId")) : null);
					params.put("P_INTM_LIST", request.getParameter("intmNoList"));
					params.put("P_AGING_LIST", request.getParameter("agingIdList"));
					params.put("P_PRINT_BTN_NO", (request.getParameter("printButtonNo") != null && !request.getParameter("printButtonNo").equals("")) ? Integer.parseInt(request.getParameter("printButtonNo")) : null);
				} else if("GIACR190B".equalsIgnoreCase(reportId)){
					params.put("P_AGING_ID", (request.getParameter("agingId") != null && !request.getParameter("agingId").equals("")) ? Integer.parseInt(request.getParameter("agingId")) : null);
					params.put("P_AGING_LIST", request.getParameter("agingIdList"));
				} else if("GIACR190C".equalsIgnoreCase(reportId)){
					System.out.println("asdNoList: "+request.getParameter("assdNoList"));
					params.put("P_SELECTED_INTM_NO", request.getParameter("intmNoList"));
					params.put("P_SELECTED_ASSD_NO", request.getParameter("assdNoList"));
					params.put("P_SELECTED_AGING_ID", request.getParameter("agingIdList"));
					params.put("P_AGING_ID", request.getParameter("agingId"));
					params.put("P_PRINT_BTN_NO", (request.getParameter("printButtonNo") != null && !request.getParameter("printButtonNo").equals("")) ? Integer.parseInt(request.getParameter("printButtonNo")) : null);
					params.put("P_USER", USER.getUserId());
				} else if("GIACR190D".equalsIgnoreCase(reportId)){
					params.put("P_ASSD_NO", request.getParameter("assdNo")); /*(request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals("")) ? Integer.parseInt(request.getParameter("assdNo")) : null*/
					params.put("P_SELECTED_AGING_ID", request.getParameter("agingIdList"));
				} else if("GIACR329".equalsIgnoreCase(reportId) || "GIACR329_CSV".equalsIgnoreCase(reportId)){ //Dren Niebres 05.20.2016 SR-5359
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_INTM_TYPE", request.getParameter("intmType"));
					params.put("P_INTM_NO", request.getParameter("intmNo"));
					params.put("P_USER_ID", USER.getUserId());
				} else if("GIACR410".equalsIgnoreCase(reportId)){
					if(reportVersion != null && !reportVersion.equals("")){
						reportName = reportId+"_"+reportVersion;
					} else {
						reportName = reportId; 
					}
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_PREM_SEQ_NO", request.getParameter("premSeqNo"));
					params.put("P_INST_NO", request.getParameter("instNo"));
					params.put("P_VIEW_TYPE", request.getParameter("viewType"));
					params.put("P_COLL_LET_NO", request.getParameter("collLetNo"));
					params.put("P_BILL_NO", request.getParameter("billNo"));	// changed from P_BENJO	// SR-3875_3569_3882_3574 : shan 06.19.2015
					params.put("P_USER", USER.getUserId());	// SR-3875_3569_3882_3574 : shan 06.19.2015
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				} else if("GIACR410A".equalsIgnoreCase(reportId)){
					if ((reportVersion != null) && (!reportVersion.equals(""))) {
		                reportName = reportId + "_" + reportVersion;
		              } else {
		                reportName = reportId;
		              }
		              params.put("P_ISS_CD", request.getParameter("issCd"));
		              params.put("P_PREM_SEQ_NO", request.getParameter("premSeqNo"));
		              params.put("P_INST_NO", request.getParameter("instNo"));
		              params.put("P_VIEW_TYPE", request.getParameter("viewType"));
		              params.put("P_USER_ID", USER.getUserId());
		              GIISParameterService giisParameterService = (GIISParameterService)APPLICATION_CONTEXT.getBean("giisParameterService");
		              reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				} else if("GIACR410B".equalsIgnoreCase(reportId)){
					if ((reportVersion != null) && (!reportVersion.equals(""))) {
		                reportName = reportId + "_" + reportVersion;
		              } else {
		                reportName = reportId;
		              }
		              params.put("P_ISS_CD", request.getParameter("issCd"));
		              params.put("P_PREM_SEQ_NO", request.getParameter("premSeqNo"));
		              params.put("P_INST_NO", request.getParameter("instNo"));
		              params.put("P_VIEW_TYPE", request.getParameter("viewType"));
		              params.put("P_USER_ID", USER.getUserId());
		              GIISParameterService giisParameterService = (GIISParameterService)APPLICATION_CONTEXT.getBean("giisParameterService");
		              reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				} else if("GIACR410C".equalsIgnoreCase(reportId)){
					if ((reportVersion != null) && (!reportVersion.equals(""))) {
		                reportName = reportId + "_" + reportVersion;
		              } else {
		                reportName = reportId;
		              }
		              params.put("P_ISS_CD", request.getParameter("issCd"));
		              params.put("P_PREM_SEQ_NO", request.getParameter("premSeqNo"));
		              params.put("P_INST_NO", request.getParameter("instNo"));
		              params.put("P_VIEW_TYPE", request.getParameter("viewType"));
		              params.put("P_USER_ID", USER.getUserId());
		              GIISParameterService giisParameterService = (GIISParameterService)APPLICATION_CONTEXT.getBean("giisParameterService");
		              reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				} else if("GIACR480A".equalsIgnoreCase(reportId)){
					params.put("P_USER", USER.getUserId());
					params.put("P_EMPLOYEE_CD", request.getParameter("employeeCd"));
					params.put("P_COMPANY_CD", request.getParameter("companyCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
				} else if("GIACR480B".equalsIgnoreCase(reportId)){
					params.put("P_USER", USER.getUserId());
					params.put("P_EMPLOYEE_CD", request.getParameter("employeeCd"));
					params.put("P_COMPANY_CD", request.getParameter("companyCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
				} else if("GIACR328".equalsIgnoreCase(reportId)){	//Kenneth L. 07.09.2013
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_DATE", request.getParameter("date"));
				}  else if("GIACR328A".equalsIgnoreCase(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_DATE", request.getParameter("date"));
				}    else if("GIACR286".equalsIgnoreCase(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_CUT_OFF_PARAM", request.getParameter("cutOffParam"));
					params.put("P_INTM_NO", request.getParameter("intmNo"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_MODULE_ID", "GIACS286");
					params.put("csvAction", "printGIACR286");
					params.put("packageName", "CSV_PAID_PREM_INTM_ASSD");
					params.put("functionName", "CSV_GIACR286");
				} 	else if("GIACR287".equalsIgnoreCase(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_CUT_OFF_PARAM", request.getParameter("cutOffParam"));
					params.put("P_ASSD_NO", (request.getParameter("assdNo") != null && !request.getParameter("assdNo").equals("")) ? Integer.parseInt(request.getParameter("assdNo")) : null);
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("csvAction", "printGIACR287");
					params.put("packageName", "CSV_PAID_PREM_INTM_ASSD");
					params.put("functionName", "CSV_GIACR287");
				} else if("GIACR157".equalsIgnoreCase(reportId) || "GIACR157_ALL_CSV".equalsIgnoreCase(reportId) ||
						  "GIACR157_UNBOOKED_CSV".equalsIgnoreCase(reportId) || "GIACR157_BOOKED_CSV".equalsIgnoreCase(reportId)){
					params.put("P_INTM_NO", request.getParameter("intmNo"));
					params.put("P_ASSD_NO",request.getParameter("assdNo"));
					params.put("P_OR_NO",request.getParameter("orNo"));
					params.put("P_PFROM_DATE",request.getParameter("prodFromDate"));
					params.put("P_PTO_DATE",request.getParameter("prodToDate"));
					params.put("P_CFROM_DATE",request.getParameter("collFromDate"));
					params.put("P_CTO_DATE",request.getParameter("collToDate"));
					params.put("P_PRNT_CODE",request.getParameter("printCode"));
					params.put("P_USER_ID", USER.getUserId());
				} else if("GIACR276".equalsIgnoreCase(reportId)){
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
				} else if("GIACR277".equalsIgnoreCase(reportId)){
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
				}
			} 
			
			System.out.println("params: "+params);
			params.put("MAIN_REPORT", reportName+".jasper");
			params.put("OUTPUT_REPORT_FILENAME", reportName);
			params.put("reportTitle", request.getParameter("reportTitle"));
			params.put("reportName", reportName);
			params.put("mediaSizeName", "US_STD_FANFOLD");
			System.out.println("params to jasper: " +params.toString());
			
			this.doPrintReport(request, response, params, reportDir);
			
		} catch (SQLException e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
