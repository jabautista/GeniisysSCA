package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
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
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.Debug;

@WebServlet (name="GeneralLedgerPrintController", urlPatterns={"/GeneralLedgerPrintController"})
public class GeneralLedgerPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5106235824838416741L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		DataSourceTransactionManager client = null;
		client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		SimpleDateFormat dt = new SimpleDateFormat("MM-dd-yyyy"); //added by clperello | 06.05.2014
		
		try {
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/reports")+"/";
				String reportName = reportVersion == null ? reportId : reportId+"_"+reportVersion;
				
				Map<String, Object> params = new HashMap<String, Object>();
				System.out.println("paramsss: "+reportId);
				if("GIAGR02A".equals(reportId) || "GIAGR03A".equals(reportId)){ //added giagr03a reymon 10092013
					params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
					params.put("P_REPORT_ID", reportId);
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_TRAN_CLASS", request.getParameter("tranClass"));		//added tranClass for ucpb config doc ...kenneth L. 07.15.2013
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				} else if("GIACR071".equals(reportId)){
					params.put("P_GACC_TRAN_ID", request.getParameter("tranId")); //Integer.parseInt(request.getParameter("tranId")) edited by markS 9.21.2016
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));	//Gzelle 07.15.2013 - UCPB version additional parameters
					params.put("P_REPORT_ID", reportId);
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				} else if("GIACR072".equals(reportId)){
					params.put("P_DATE_OPT", request.getParameter("dateOpt"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_MODULE_ID", "GIACS072");
					params.put("P_MEMO_TYPE", request.getParameter("memoType"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_CUTOFF_DATE", request.getParameter("cutOffDate"));
					params.put("packageName", "CSV_AC_GL_REPORTS");	 //Dren 03.04.2016 SR-5358
					params.put("functionName", "csv_giacr072"); 	 //Dren 03.04.2016 SR-5358
					params.put("csvAction", "printGIACR072CSV");	 //Dren 03.04.2016 SR-5358
					reportName = reportId;								
					System.out.println(params);
				} else if ("GIACR138".equals(reportId) || "GIACR138B".equals(reportId)) {
					reportName = reportId;
					params.put("packageName", "CSV_ACCTG");
					params.put("csvAction", "print"+reportId);
					if ("GIACR138".equals(reportId)) {
						params.put("functionName", "JOURNALVOUCHERREGISTER_D");
					} else {
						params.put("functionName", "JOURNALVOUCHERREGISTER_S");
					}
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_MODULE_ID", "GIACS127");
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_TRAN_CLASS", request.getParameter("tranClass"));
					params.put("P_JV_TRAN_CD", request.getParameter("jvTranCd"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_TRAN_POST", request.getParameter("tranPost"));
					params.put("P_COLDV", request.getParameter("colDv"));
					params.put("P_ORDER_BY", request.getParameter("orderBy")); //added by robert SR 5156 11.04.2015
					System.out.println(params);
				} else if ("GIACR060".equals(reportId) || "GIACR061".equals(reportId) || "GIACR062".equals(reportId) || "GIACR201".equals(reportId)
						|| "GIACR202".equals(reportId)) {
					reportName = reportId;
					params.put("packageName", "CSV_GIACS060");
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_FUND_CD", request.getParameter("fundCd"));
					params.put("P_CATEGORY", request.getParameter("category"));
					params.put("P_CONTROL", request.getParameter("control"));
					params.put("P_TRAN_CLASS", request.getParameter("tranClass"));
					params.put("P_TRAN_FLAG", request.getParameter("tranFlag"));
					params.put("P_TRAN_POST", request.getParameter("tranPost"));
					params.put("P_TRAN_POST2", request.getParameter("tranPost").equals("T") ? 1 : 2); //added by clperello | 06.05.2014
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_FROM_DATE2", dt.parse(request.getParameter("fromDate"))); //added by clperello | 06.05.2014
					params.put("P_TO_DATE2", dt.parse(request.getParameter("toDate"))); //added by clperello | 06.05.2014
					params.put("P_SUB_1", request.getParameter("sub1"));
					params.put("P_SUB_2", request.getParameter("sub2"));
					params.put("P_SUB_3", request.getParameter("sub3"));
					params.put("P_SUB_4", request.getParameter("sub4"));
					params.put("P_SUB_5", request.getParameter("sub5"));
					params.put("P_SUB_6", request.getParameter("sub6"));
					params.put("P_SUB_7", request.getParameter("sub7"));
					params.put("P_ALL_BRANCHES", request.getParameter("branchAll"));
					params.put("P_SL_CD", request.getParameter("slCd"));
					params.put("P_COMPANY", request.getParameter("company")); //added by clperello | 06.05.2014
					params.put("P_BEGBAL", request.getParameter("includeBegBal")); //added by jhing 01.26.2016 from vondanix changes Temp Solution -  RSIC 20691 11.20.2015
					
					if(!request.getParameter("branchAll").equals("Y"))
						params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					
					//added by john 10.16.2014
					if(request.getParameter("includeSubAccts").equals("Y")){
						if((request.getParameter("control")).equals("00")){
							params.put("P_CONTROL", null);
						}
						if((request.getParameter("sub1")).equals("00")){
							params.put("P_SUB_1", null);
						}
						if((request.getParameter("sub2")).equals("00")){
							params.put("P_SUB_2", null);
						}
						if((request.getParameter("sub3")).equals("00")){
							params.put("P_SUB_3", null);
						}
						if((request.getParameter("sub4")).equals("00")){
							params.put("P_SUB_4", null);
						}
						if((request.getParameter("sub5")).equals("00")){
							params.put("P_SUB_5", null);
						}
						if((request.getParameter("sub6")).equals("00")){
							params.put("P_SUB_6", null);
						}
						if((request.getParameter("sub7")).equals("00")){
							params.put("P_SUB_7", null);
						}
					}
					
					//added by clperello | 06.04.2014
					if("GIACR060".equals(reportId)) {
						params.put("functionName", "CSV_GIACR060");
						params.put("csvAction", "printGIACR060");
					} else if ("GIACR061".equals(reportId)) {
						params.put("functionName", "CSV_GIACR061");
						params.put("csvAction", "printGIACR061");
					} else if ("GIACR062".equals(reportId)) {
						params.put("functionName", "CSV_GIACR062");
						params.put("csvAction", "printGIACR062");
					} else if ("GIACR201".equals(reportId)) {
						params.put("functionName", "CSV_GIACR201");
						params.put("csvAction", "printGIACR201");
					} else if ("GIACR202".equals(reportId)) {
						params.put("functionName", "CSV_GIACR202");
						params.put("csvAction", "printGIACR202");
				    }
										
				} else if("GIACR109".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_POST_TRAN", request.getParameter("postTran"));
					params.put("P_TRAN_DATE1", request.getParameter("tranDate1"));
					params.put("P_TRAN_DATE2", request.getParameter("tranDate2"));
					reportName = reportId;
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("csvAction", "printGIACR109");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_EVAT");
				} else if ("GIACR500".equals(reportId) || "GIACR500A".equals(reportId) || "GIACR500B".equals(reportId) 
						|| "GIACR500C".equals(reportId) || "GIACR500D".equals(reportId)
						|| "GIACR500E".equals(reportId) || "GIACR500AE".equals(reportId)) {
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_MONTH", request.getParameter("month"));
					params.put("P_YEAR", request.getParameter("year"));
					params.put("P_BRANCH", request.getParameter("branch"));
					
					//added by clperello | 06.06.2014
					params.put("packageName", "CSV_MONTHLY_TB");
					if("GIACR500".equals(reportId)) {
						params.put("functionName", "standard_report");
						params.put("csvAction", "printGIACR500");
					} else if ("GIACR500A".equals(reportId)) {
						params.put("functionName", "con_branches");
						params.put("csvAction", "printGIACR500A");
					} else if ("GIACR500B".equals(reportId)) {
						params.put("functionName", "CON_BRANCHES_W_SUM");
						params.put("csvAction", "printGIACR500B");
					} else if ("GIACR500C".equals(reportId)) {
						params.put("functionName", "summary_report");
						params.put("csvAction", "printGIACR500C");
					} else if ("GIACR500D".equals(reportId)) {
						params.put("functionName", "break_by_branch");
						params.put("csvAction", "printGIACR500D");
					} else if ("GIACR500E".equals(reportId)) {
						params.put("functionName", "sub_totals");
						params.put("csvAction", "printGIACR500E");
					} else {
						params.put("functionName", "adjusting_entries");
						params.put("csvAction", "printGIACR500AE");
					}
				} else if("GIACR503".equals(reportId) || "GIACR503_CSV".equals(reportId)){ //Dren Niebres SR-5345 05.02.2016 
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					reportName = reportId;
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("P_TRAN_YEAR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					System.out.println("GIACR503 Report Params: "+params);
				} else if("GIACR111".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_DATE", request.getParameter("asOfDate"));
					params.put("P_EXCLUDE_TAG", request.getParameter("excludeTag"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));
					params.put("P_POST_TRAN", request.getParameter("postTran"));
					params.put("csvAction", "printGIACR111");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_WTAX_GIACR111");
				} else if("GIACR112".equals(reportId) || "GIACR112A".equals(reportId)){ // bonok :: 3.10.2016 :: GENQA SR 4073
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					if("GIACR112A".equals(reportId)){ // bonok :: 3.10.2016 :: GENQA SR 4073
						GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
						params.put("P_FORM_PATH", giisParametersService.getParamValueV2("FORM_2307_PATH"));
					}
					params.put("P_DATE1", request.getParameter("fromDate"));
					params.put("P_DATE2", request.getParameter("toDate"));
					params.put("P_EXCLUDE_TAG", request.getParameter("excludeTag"));
					params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd"));
					params.put("P_PAYEE_NO", request.getParameter("payeeNo"));
					params.put("P_POST_TRAN", request.getParameter("postTran"));
					//Added by pjsantos 12/22/2016, GENQA 5898
					params.put("P_ITEMS", request.getParameter("printItems"));
					params.put("P_TRAN_ID", request.getParameter("gaccTranId"));
					params.put("P_TRAN_TAG", request.getParameter("pTrans"));
					//pjsantos end

				} else if("GIACR256".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_POST_TRAN", request.getParameter("postTran"));
					params.put("P_DATE1", request.getParameter("fromDate"));
					params.put("P_DATE2", request.getParameter("toDate"));
					params.put("P_PAYEE", request.getParameter("payeeClassCd"));
					params.put("P_EXCLUDE_TAG", request.getParameter("excludeTag"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));	//added by Gzelle 08132014
					params.put("P_POST_TRAN_TOGGLE", request.getParameter("postTran"));	//added by Gzelle 08182014
					params.put("P_TAX_CD",request.getParameter("taxCd") == null ? "" : request.getParameter("taxCd")); //Added by Jerome 09.26.2016 SR 5671
					params.put("csvAction", "printGIACR256");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_WTAX_GIACR256");
				} else if("GIACR255".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_POST_TRAN", request.getParameter("postTran"));
					params.put("P_DATE1", request.getParameter("fromDate"));
					params.put("P_DATE2", request.getParameter("toDate"));
					params.put("P_PAYEE", request.getParameter("payeeClassCd"));
					params.put("P_EXCLUDE_TAG", request.getParameter("excludeTag"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));	//added by Gzelle 08132014
					params.put("P_POST_TRAN_TOGGLE", request.getParameter("postTran"));	//added by Gzelle 08182014
					params.put("csvAction", "printGIACR255");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_WTAX_GIACR255");
				} else if("GIACR254".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_POST_TRAN", request.getParameter("postTran"));
					params.put("P_DATE1", request.getParameter("fromDate"));
					params.put("P_DATE2", request.getParameter("toDate"));
					params.put("P_PAYEE", request.getParameter("payeeClassCd"));
					params.put("P_TAX_ID", request.getParameter("taxCd"));
					params.put("P_EXCLUDE_TAG", request.getParameter("excludeTag"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));	//added by Gzelle 08132014
					params.put("P_POST_TRAN_TOGGLE", request.getParameter("postTran"));	//added by Gzelle 08182014
					params.put("csvAction", "printGIACR254");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_WTAX_GIACR254");
				} else if("GIACR110".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_POST_TRAN", request.getParameter("postTran"));
					params.put("P_DATE1", request.getParameter("fromDate"));
					params.put("P_DATE2", request.getParameter("toDate"));
					params.put("P_PAYEE", request.getParameter("payeeClassCd"));
					params.put("P_EXCLUDE_TAG", request.getParameter("excludeTag"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));	//added by Gzelle 08182014
					params.put("P_POST_TRAN_TOGGLE", request.getParameter("postTran"));	//added by Gzelle 08182014
					params.put("P_TAX_CD",request.getParameter("taxCd") == null ? "" : request.getParameter("taxCd")); //Added by Jerome 09.26.2016 SR 5671
					params.put("csvAction", "printGIACR110");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_WTAX_GIACR110");
				} else if("GIACR107".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_POST_TRAN", request.getParameter("postTran"));
					params.put("P_DATE1", request.getParameter("fromDate"));
					params.put("P_DATE2", request.getParameter("toDate"));
					params.put("P_PAYEE", request.getParameter("payeeClassCd"));
					params.put("P_EXCLUDE_TAG", request.getParameter("excludeTag"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));	//added by Gzelle 08182014
					params.put("P_POST_TRAN_TOGGLE", request.getParameter("postTran"));	//added by Gzelle 08182014
					params.put("csvAction", "printGIACR107");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_WTAX_GIACR107");
				} else if("GIACR253".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_POST_TRAN", request.getParameter("postTran"));
					params.put("P_DATE1", request.getParameter("fromDate"));
					params.put("P_DATE2", request.getParameter("toDate"));
					params.put("P_PAYEE", request.getParameter("payeeClassCd"));
					params.put("P_TAX_ID", request.getParameter("taxCd"));
					params.put("P_EXCLUDE_TAG", request.getParameter("excludeTag"));
					params.put("P_MODULE_ID", request.getParameter("moduleId"));	//added by Gzelle 08132014
					params.put("P_POST_TRAN_TOGGLE", request.getParameter("postTran"));	//added by Gzelle 08182014
					params.put("csvAction", "printGIACR253");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_WTAX_GIACR253");
				} else if("GIACR502".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_TRAN_YR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("csvAction", "printGIACR502");
					params.put("packageName", "CSV_ASOF_TB");
					params.put("functionName", "CSV_GIACR502");
				} else if("GIACR502A".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("P_TRAN_YR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("csvAction", "printGIACR502A");
					params.put("packageName", "CSV_ASOF_TB");
					params.put("functionName", "CSV_GIACR502A");
				} else if("GIACR502B".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("P_TRAN_YR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("csvAction", "printGIACR502B");
					params.put("packageName", "CSV_ASOF_TB");
					params.put("functionName", "CSV_GIACR502B");
				} else if("GIACR502C".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("P_TRAN_YR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("csvAction", "printGIACR502C");
					params.put("packageName", "CSV_ASOF_TB");
					params.put("functionName", "CSV_GIACR502C");
				} else if("GIACR502D".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("P_TRAN_YR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("csvAction", "printGIACR502D");
					params.put("packageName", "CSV_ASOF_TB");
					params.put("functionName", "CSV_GIACR502D");
				} else if("GIACR502E".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("P_TRAN_YR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("csvAction", "printGIACR502E");
					params.put("packageName", "CSV_ASOF_TB");
					params.put("functionName", "CSV_GIACR502E");
				} else if("GIACR502F".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("P_TRAN_YR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("csvAction", "printGIACR502F");
					params.put("packageName", "CSV_ASOF_TB");
					params.put("functionName", "CSV_GIACR502F");
				} else if("GIACR502G".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("P_TRAN_YR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("csvAction", "printGIACR502G");
					params.put("packageName", "CSV_ASOF_TB");
					params.put("functionName", "CSV_GIACR502G");
				} else if ("GIACR502AE".equals(reportId)) {
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_TRAN_YR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("P_TRAN_MM", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
					params.put("P_BRANCH", request.getParameter("branch"));	// shan 09.02.2014
					if ("N".equals(request.getParameter("branch"))){	// consolidated
						params.put("csvAction", "printGIACR502AECnsldtd");
						params.put("packageName", "CSV_ASOF_TB");
						params.put("functionName", "CSV_GIACR502AE_CNSLDTD");
					}else{
						params.put("csvAction", "printGIACR502AE");
						params.put("packageName", "CSV_ASOF_TB");
						params.put("functionName", "CSV_GIACR502AE");
					}
				}else if("GIACR290".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_REPORT_TYPE", request.getParameter("reportType").toUpperCase());
					params.put("packageName", "CSV_GIACR290_RECAPS_PKG"); //added by carlo rubenecia SR-5506 -- START
					if(request.getParameter("reportType").toUpperCase().equals("PREMIUM")){
						params.put("csvAction", "printGIACR290R1");
						params.put("functionName", "csv_giacr290_recap1");
					}else if(request.getParameter("reportType").toUpperCase().equals("LOSSPD")){
						params.put("csvAction", "printGIACR290R2");
						params.put("functionName", "csv_giacr290_recap2");
					}else if(request.getParameter("reportType").toUpperCase().equals("COMM")){
						params.put("csvAction", "printGIACR290R3");
						params.put("functionName", "csv_giacr290_recap3");
					}else if(request.getParameter("reportType").toUpperCase().equals("TSI")){
						params.put("csvAction", "printGIACR290R4");
						params.put("functionName", "csv_giacr290_recap4");
					}else{
						params.put("csvAction", "printGIACR290R5");
						params.put("functionName", "csv_giacr290_recap5");
					}//added by carlo rubenecia SR-5506 -- END
				}else if("GIACR290A".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_REPORT_TYPE", request.getParameter("reportType").toUpperCase());
					params.put("P_ROWTITLE", request.getParameter("rowTitle"));
					params.put("P_DATE", request.getParameter("date"));
				} else if("GIPIR203".equals(reportId) || "GIPIR203A".equals(reportId) || "GIPIR203A_CSV".equals(reportId) || "GIPIR203B".equals(reportId)){ //Dren Niebres 07.18.2016 SR-5336 - Start
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("csvAction", "print"+reportId+"CSV");
					params.put("packageName", "CSV_RECAP");
					params.put("functionName", "CSV_"+reportId);
					params.put("P_INCLUDE_ENDT", request.getParameter("includeEndt")); //Dren Niebres 07.18.2016 SR-5336 - End
				}else if("GIACR450".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("mediaSizeName", "US_STD_FANFOLD");
				}else if("GIACR451".equals(reportId) || "GIACR452".equals(reportId) || "GIACR453".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("mediaSizeName", "US_STD_FANFOLD");
				}else if("GIACR510".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_YEAR", request.getParameter("year"));
					params.put("P_DT_BASIS", request.getParameter("dateBasis"));
					params.put("P_TRAN_FLAG", request.getParameter("tranFlag"));
					params.put("mediaSizeName", "US_STD_FANFOLD");
				}else if("GIACR343A".equals(reportId) || "GIACR343B".equals(reportId) || "GIACR343C".equals(reportId)){	/* start - Gzelle - 02052016 - AP/AR ENH */
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_PERIOD_TAG", request.getParameter("periodTag"));
					params.put("P_CUTOFF_DATE", request.getParameter("cutOffDate"));
					params.put("P_LEDGER_CD", request.getParameter("ledgerCd"));
					params.put("P_SUBLEDGER_CD", request.getParameter("subLedgerCd"));
					params.put("P_TRANSACTION_CD", request.getParameter("transactionCd"));
					
					if("GIACR343A".equals(reportId)){	
						params.put("P_SL_CD", request.getParameter("slCd"));
						params.put("csvAction", "printGIACR343ACsv");
						params.put("packageName", "CSV_ACCTG_GL");
						params.put("functionName", "get_giacr343A_csv");
					}else if("GIACR343B".equals(reportId)){
						params.put("csvAction", "printGIACR343BCsv");
						params.put("packageName", "CSV_ACCTG_GL");
						params.put("functionName", "get_giacr343B_csv");
					}else if("GIACR343C".equals(reportId)){
						params.put("P_SL_CD", request.getParameter("slCd"));
						params.put("csvAction", "printGIACR343CCsv");
						params.put("packageName", "CSV_ACCTG_GL");
						params.put("functionName", "get_giacr343C_csv");
					}	/* end - Gzelle - 02052016 - AP/AR ENH */				
				} 
				
				params.put("P_USER_ID", USER.getUserId());
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				Debug.print("Print " + reportId +  ": " + params); //added by clperello 06.05.2014
				this.doPrintReport(request, response, params, reportDir);
			} 
			
		} catch (SQLException e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} finally {
			ConnectionUtil.releaseConnection(client);
		}
	}
	
}