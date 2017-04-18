/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.accounting.reports.controllers
	File Name: GeneralDisbursementPrintController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Nov 9, 2012
	Description: 
*/


package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jasperreports.engine.JRException;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GeneralDisbursementPrintController", urlPatterns="/GeneralDisbursementPrintController")
public class GeneralDisbursementPrintController extends BaseController {
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GeneralDisbursementPrintController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
			String filename = "";
			String reportDir = null;
			
			if ("printGIADD01A".equals(ACTION)) {				
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				filename = "CHECK_REQUISITION_" + request.getParameter("tranId") ;
				
				log.info("CREATING REPORT : "+reportName);
				params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
				params.put("P_REPORT_ID", reportId);
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_DOCUMENT_CD", request.getParameter("documentCd"));
				params.put("P_CREATE_BY", USER.getUserId());
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
				Debug.print("Print check requisition XOL Params: "+params);
			}else if("printGIACR081".equals(ACTION) && "GIACS016".equals(request.getParameter("moduleId"))){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				filename = "DV_RECORDS_REPLENISHMENT_" + request.getParameter("replenishId") ;
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_REPLENISH_ID", Integer.parseInt(request.getParameter("replenishId")));
				params.put("P_REPORT_ID", reportId);				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportId);
			}else if ("printGIACR251".equals(ACTION)) {
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				String reportName = reportVersion == "" || reportVersion == null ? reportId : reportId+"_"+reportVersion;
				
				params.put("P_INTM_NO", Integer.parseInt(request.getParameter("intmNo"))); //Modified by Joms 07.16.2013 Parsed.
				params.put("P_CV_NO", request.getParameter("cvNo"));
				params.put("P_CV_PREF", request.getParameter("cvPref"));
				params.put("P_CV_DATE", request.getParameter("cvDate"));
				params.put("P_REPORT_ID", "GIACR251");
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				
				System.out.println("params ::::::::::::: " + params);
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				
				//marco - 12.06.2013 - for batch printing
				if("GIACS251".equals(request.getParameter("callingForm"))){					
					params.put("OUTPUT_REPORT_FILENAME", reportName + "_" + request.getParameter("intmNo")+"_"+request.getParameter("cvNo"));
				}
			}else if ("printGIACR251A".equals(ACTION)) {
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				String reportName = reportVersion == "" || reportVersion == null ? reportId : reportId+"_"+reportVersion;
				
				//params.put("P_INTM_NO", request.getParameter("intmNo")); //Modified by Joms 07.16.2013 Parsed.
				params.put("P_INTM_NO", Integer.parseInt(request.getParameter("intmNo"))); // bonok :: 12.8.2015 :: UCPB SR 19912
				params.put("P_CV_NO", request.getParameter("cvNo"));
				params.put("P_CV_PREF", request.getParameter("cvPref"));
				
				//DateFormat dfmt = new SimpleDateFormat("MM-dd-yyyy");
				//params.put("P_CV_DATE", dfmt.parse(request.getParameter("cvDate")));
				params.put("P_CV_DATE", request.getParameter("cvDate")); // bonok :: 12.8.2015 :: UCPB SR 19912
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_REPORT_ID", "GIACR251A");
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				
				System.out.println("params ::::::::::::: " + params);
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");

			}else if ("printGIACR252".equals(ACTION)){
				/*
				 *Added by reymon 06182013
				 *GIACR252 (Comm Fund Slip) printing 
				 */
				SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				filename = "COMM_FUND_SLIP_" + request.getParameter("cfsNo") ; //added by steven 07.30.2014 - request.getParameter("P_CFS_NO") ;
				
				log.info("CREATING REPORT : "+reportName);
				params.put("P_INTM_NO", Integer.parseInt(request.getParameter("intmNo")));
				params.put("P_CFS_NO", request.getParameter("cfsNo"));
				params.put("P_GACC_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
				params.put("P_CFS_PREF", request.getParameter("cfsPref"));
				if(reportVersion != null && (reportVersion.equals("UCPB") || reportVersion.equals("RSIC"))){
					System.out.println("Joms!!!!!");
					params.put("P_CFS_DATE", request.getParameter("cfsDate"));
				} else {
					System.out.println("Reymon!!!!");
					params.put("P_CFS_DATE", (request.getParameter("cfsDate") != null && !request.getParameter("cfsDate").isEmpty() ? sdf.parse(request.getParameter("cfsDate")) : null));
				}
				params.put("P_REPORT_ID", reportId);
				params.put("P_USER_ID", USER.getUserId());
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
			}// added by mark SR23579 1/11/2017
			else if ("printGIACR252A".equals(ACTION)){
				SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				filename = "COMM_FUND_SLIP_DTL" + request.getParameter("cfsNo") ;
				log.info("CREATING REPORT : "+reportName);
				params.put("P_INTM_NO", Integer.parseInt(request.getParameter("intmNo")));
				params.put("P_CFS_NO", request.getParameter("cfsNo"));
				params.put("P_GACC_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
				params.put("P_CFS_PREF", request.getParameter("cfsPref"));
				params.put("P_CFS_DATE", request.getParameter("cfsDate"));
				params.put("P_REPORT_ID", reportId);
				params.put("P_USER_ID", USER.getUserId());
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
			}//SR23579
			else if ("printGIACR081".equals(ACTION) && "GIACS081".equals(request.getParameter("moduleId"))) {	//Added by Gzelle 07.10.2013
				String reportId = request.getParameter("reportId");	
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				params.put("P_REPLENISH_ID", Integer.parseInt(request.getParameter("replenishId")));
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_REPORT_ID", reportId);	
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
			} else if ("printGIACR081A".equals(ACTION) && "GIACS081".equals(request.getParameter("moduleId"))) { //Added by Gzelle 07.10.2013
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				params.put("P_REPLENISH_ID", Integer.parseInt(request.getParameter("replenishId")));
				params.put("P_REPORT_ID", reportId);	
				
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
			} else if("printGiacs118Reports".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				//String reportVersion = reportsService.getReportVersion(reportId);
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				//String reportName = reportVersion == "" || reportVersion == null ? reportId : reportId+"_"+reportVersion;
				String reportName = reportId;
				params.put("packageName", "CSV_ACCTG");
				params.put("csvAction", "print"+reportId);
				
				if("GIACR118".equalsIgnoreCase(request.getParameter("reportId"))){
					params.put("functionName", "CASHDISBREGISTER_D");
					params.put("P_BRANCH_CHK", (request.getParameter("branchChk") != null && !request.getParameter("branchChk").equals("")) ? request.getParameter("branchChk") : null);
				} else if("GIACR118B".equalsIgnoreCase(request.getParameter("reportId"))){
					params.put("functionName", "CASHDISBREGISTER_S");
					params.put("P_BRANCH_CHECK", (request.getParameter("branchChk") != null && !request.getParameter("branchChk").equals("")) ? request.getParameter("branchChk") : null);
				} else if("GIACR118C".equalsIgnoreCase(request.getParameter("reportId"))){
					params.put("functionName", "CASHDISBREGISTER_PR");
				}
				params.put("P_DATE", request.getParameter("fromDate"));
				params.put("P_DATE2", request.getParameter("toDate"));
				params.put("P_BRANCH", request.getParameter("branchCd"));
				
				params.put("P_POST_TRAN_TOGGLE", (request.getParameter("postTranToggle") != null && !request.getParameter("postTranToggle").equals("")) ? request.getParameter("postTranToggle") : null);
				params.put("P_DV_CHECK_TOGGLE", (request.getParameter("dvCheckToggle") != null && !request.getParameter("dvCheckToggle").equals("")) ? request.getParameter("dvCheckToggle") : null);
				params.put("P_DV_CHECK", request.getParameter("dvCheck"));
				
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				System.out.println("params to jasper: " +params.toString());
			
			} else if("printGIACR135".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				String reportName = reportId;
				params.put("packageName", "CSV_ACCTG");
				
				if("I".equalsIgnoreCase(request.getParameter("ieParticulars"))){
					params.put("functionName", "GET_GIACR135_INCLUDE_PART");
					params.put("csvAction", "print"+reportId+"I");
				} else {
					params.put("functionName", "GET_GIACR135_EXCLUDE_PART");
					params.put("csvAction", "print"+reportId+"E");
				}
				
				params.put("P_POST_TRAN_TOGGLE", request.getParameter("postTranToggle"));
				//params.put("P_BEGIN_DATE", (request.getParameter("beginDate") != null && !request.getParameter("beginDate").equals("")) ? df.parse(request.getParameter("beginDate")) : null);
				//params.put("P_END_DATE", (request.getParameter("endDate") != null && !request.getParameter("endDate").equals("")) ? df.parse(request.getParameter("endDate")) : null);
				params.put("P_BEGIN_DATE", request.getParameter("beginDate"));
				params.put("P_END_DATE", request.getParameter("endDate"));
				params.put("P_BRANCH", request.getParameter("branchCd"));
				params.put("P_BRANCH", request.getParameter("branchCd"));
				params.put("P_BANK_CD", request.getParameter("bankCd"));
				params.put("P_BANK_ACCT_NO", request.getParameter("bankAcctNo"));
				params.put("ORDERBY", request.getParameter("orderBy"));
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("P_SORT_ITEM", null);
				params.put("I_E_PARTICULARS", request.getParameter("ieParticulars"));
				params.put("P_USER_ID", USER.getUserId());
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				System.out.println("params: "+params);
				
			} else if("printGiacs512Reports".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				String reportName = reportId;
				
				if("GIACR512".equals(request.getParameter("reportId"))){
					params.put("P_TRAN_YEAR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
					params.put("P_INTM_NO", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
					params.put("P_ISS_CD", "");
					params.put("P_USER", USER.getUserId());
				} else if("GIACR512A".equals(request.getParameter("reportId"))){
					params.put("P_INTM_NO", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
					params.put("P_TRAN_YEAR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? request.getParameter("year") : null);
					params.put("P_BRANCH_CD", "");
				} else if("GIACR512B".equals(request.getParameter("reportId"))){
					params.put("P_INTM_NO", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
					params.put("P_TRAN_YEAR", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? request.getParameter("year") : null);
					params.put("P_BRANCH_CD", "");
				}
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				System.out.println("params: "+params);
			} else if("printGIACS184Reports".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				String reportName = reportId;
				
				if("GIACR185".equalsIgnoreCase(request.getParameter("reportId")) || "GIACR185_CSV".equalsIgnoreCase(request.getParameter("reportId"))){ //Dren Niebres 05.03.2016 SR-5355
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));					
				} else if("GIACR186".equalsIgnoreCase(request.getParameter("reportId")) || "GIACR186_CSV".equalsIgnoreCase(request.getParameter("reportId"))){ //Dren Niebres 05.03.2016 SR-5355
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_NULL", request.getParameter("paramNull"));
					params.put("P_CLEARED", request.getParameter("paramCleared"));					
				} 
				params.put("P_BANK_CD", "");
				params.put("P_BANK_ACCT_CD", "");
				if (request.getParameter("moduleId").equals("GIACS047")) {
					params.put("P_BANK_CD", request.getParameter("bankCd"));
					params.put("P_BANK_ACCT_CD", request.getParameter("bankAcctCd"));
				}
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				System.out.println("params: "+params);
				
			} else if("printGIACS413Reports".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				String reportName = reportId;
				
				if("GIACR413A".equalsIgnoreCase(request.getParameter("reportId"))){
					params.put("P_BRANCH", (request.getParameter("branchCd") != null && !request.getParameter("branchCd").equals("")) ? request.getParameter("branchCd") : null);
					params.put("P_FROM_DATE", (request.getParameter("fromDate") != null && !request.getParameter("fromDate").equals("")) ? request.getParameter("fromDate") : null);
					params.put("P_TO_DATE", (request.getParameter("toDate") != null && !request.getParameter("toDate").equals("")) ? request.getParameter("toDate") : null);
					params.put("P_TRAN_POST", (request.getParameter("paramTranPost") != null && !request.getParameter("paramTranPost").equals("")) ? request.getParameter("paramTranPost") : null);					
				} else if("GIACR413B".equalsIgnoreCase(request.getParameter("reportId"))){
					params.put("P_FROM_DT", (request.getParameter("fromDate") != null && !request.getParameter("fromDate").equals("")) ? request.getParameter("fromDate") : null);
					params.put("P_TO_DT", (request.getParameter("toDate") != null && !request.getParameter("toDate").equals("")) ? request.getParameter("toDate") : null);
					params.put("P_TRAN_POST", (request.getParameter("paramTranPost") != null && !request.getParameter("paramTranPost").equals("")) ? Integer.parseInt(request.getParameter("paramTranPost")) : null);
					params.put("P_BRANCH", (request.getParameter("branchCd") != null && !request.getParameter("branchCd").equals("")) ? request.getParameter("branchCd") : null);
				} else if("GIACR413C".equalsIgnoreCase(request.getParameter("reportId"))){
					params.put("P_FROM_DT", (request.getParameter("fromDate") != null && !request.getParameter("fromDate").equals("")) ? request.getParameter("fromDate") : null);
					params.put("P_TO_DT", (request.getParameter("toDate") != null && !request.getParameter("toDate").equals("")) ? request.getParameter("toDate") : null);
					params.put("P_TRAN_POST", (request.getParameter("paramTranPost") != null && !request.getParameter("paramTranPost").equals("")) ? Integer.parseInt(request.getParameter("paramTranPost")) : null);
				} else if("GIACR413D".equalsIgnoreCase(request.getParameter("reportId"))){
					params.put("P_TRAN_POST", (request.getParameter("paramTranPost") != null && !request.getParameter("paramTranPost").equals("")) ? request.getParameter("paramTranPost") : null);
					params.put("P_FROM_DT", (request.getParameter("fromDate") != null && !request.getParameter("fromDate").equals("")) ? df.parse(request.getParameter("fromDate")) : null);
					params.put("P_TO_DT", (request.getParameter("toDate") != null && !request.getParameter("toDate").equals("")) ? df.parse(request.getParameter("toDate")) : null);
				} else if("GIACR413E".equalsIgnoreCase(request.getParameter("reportId"))){
					params.put("P_FROM_DT", (request.getParameter("fromDate") != null && !request.getParameter("fromDate").equals("")) ? request.getParameter("fromDate") : null);
					params.put("P_TO_DT", (request.getParameter("toDate") != null && !request.getParameter("toDate").equals("")) ? request.getParameter("toDate") : null);
					params.put("P_TRAN_POST", (request.getParameter("paramTranPost") != null && !request.getParameter("paramTranPost").equals("")) ? Integer.parseInt(request.getParameter("paramTranPost")) : null);
				} else if("GIACR413F".equalsIgnoreCase(request.getParameter("reportId"))){
					params.put("P_BRANCH", (request.getParameter("branchCd") != null && !request.getParameter("branchCd").equals("")) ? request.getParameter("branchCd") : null);
					params.put("P_FROM_DT", (request.getParameter("fromDate") != null && !request.getParameter("fromDate").equals("")) ? df.parse(request.getParameter("fromDate")) : null);
					params.put("P_TO_DT", (request.getParameter("toDate") != null && !request.getParameter("toDate").equals("")) ? df.parse(request.getParameter("toDate")) : null);
					params.put("P_TRAN_POST", (request.getParameter("paramTranPost") != null && !request.getParameter("paramTranPost").equals("")) ? request.getParameter("paramTranPost") : null);
				}
				params.put("P_INTM_TYPE", (request.getParameter("intmType") != null && !request.getParameter("intmType").equals("")) ? request.getParameter("intmType") : null);
				params.put("P_BRANCH_CD", (request.getParameter("branchCd") != null && !request.getParameter("branchCd").equals("")) ? request.getParameter("branchCd") : null);
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				
				if (request.getParameter("fileType").equals("CSV")) { //Deo [02.15.2017]: SR-5933
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("createCSVFromString", "Y");
					params.put("csvAction", "print" + reportId);
				}
				System.out.println("params: "+params);
				
			}else if("printGIACR273".equals(ACTION)){	//Disbursement List
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				String reportName = reportId + "_DETAILS";
				filename = reportId;
				
				params.put("P_BRANCH", request.getParameter("branchCd"));
				params.put("P_DOC_CD", request.getParameter("docCd"));
				params.put("P_DATE1", request.getParameter("fromDate") == "" || request.getParameter("fromDate") == null ? null : df.parse(request.getParameter("fromDate")));
				params.put("P_DATE2", request.getParameter("toDate") == "" || request.getParameter("toDate") == null ? null : df.parse(request.getParameter("toDate")));
				params.put("P_TRUNC_DATE", request.getParameter("truncDate"));
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
			} else if("printGIACR408".equals(ACTION)){
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				String reportId = request.getParameter("reportId");
				params.put("P_COMM_REC_ID", Integer.parseInt(request.getParameter("commRecId")));
				params.put("P_ISS_CD", request.getParameter("issCd"));
				params.put("P_PREM_SEQ_NO", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("P_FUND_CD", request.getParameter("fundCd"));
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
			}else if("printGIACR409".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				params.put("P_BRANCH_TYPE", request.getParameter("branchType"));
				params.put("P_CRED_BRANCH", request.getParameter("credBranch"));
				params.put("P_FLAG", request.getParameter("tranStatus"));
				params.put("P_FR_DATE", request.getParameter("fromDate"));
				params.put("P_TO_DATE", request.getParameter("toDate"));
				params.put("P_ISS_CD", request.getParameter("issCd"));
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_MODULE_ID", "GIACS056");
				params.put("P_BRANCH", request.getParameter("branchCd"));
				params.put("P_PREM_SEQ_NO", request.getParameter("billNo").equals("") ? null : Integer.parseInt(request.getParameter("billNo")));
				params.put("P_TRAN_NO", request.getParameter("tranNo").equals("") ? null : Integer.parseInt(request.getParameter("tranNo")));
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
			}else if("printGIACR212".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				params.put("P_TO_DATE", request.getParameter("toDate"));
				params.put("P_FROM_DATE", request.getParameter("fromDate"));
				params.put("P_DATE_TYPE", request.getParameter("dateType"));
				params.put("P_SL_TYPE", request.getParameter("slType"));
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
			
			//GIACS149 Overriding Commission Voucher reports
			}else if("printGIACR163".equals(ACTION) || "printGIACR163A".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				//added by steven 10.09.2014
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				
				params.put("P_INTM_NO", request.getParameter("intmNo"));
				params.put("P_COMMV_PREF", request.getParameter("commvPref"));
				params.put("P_COMM_VCR_NO", request.getParameter("commVcrNo"));
				params.put("P_CV_DATE", request.getParameter("cvDate"));
				params.put("P_USER_ID", USER.getUserId());
				
				log.info("CREATING REPORT : "+reportName);
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
			}else if("printGIACR162".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				params.put("P_INTM_NO", request.getParameter("intmNo") == null || request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo")));
				params.put("P_FROM_DT", request.getParameter("fromDate"));
				params.put("P_TO_DT", request.getParameter("toDate"));
				params.put("P_CHOICE", request.getParameter("choice"));
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
			
			//end GIACS149 reports
			}else if("printGIACR221B".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/reinsurance/reports")+"/";
				params.put("P_REP_GRP", request.getParameter("repGrp"));
				params.put("P_ISS_CD", request.getParameter("issCd"));
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("P_UNPAID_PREM", request.getParameter("unpaidPrem"));
				params.put("P_USER_ID", USER.getUserId());
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				
				params.put("packageName", "CSV_AC_DISB_REPORTS");	 //added carlo de guzman 3/1/2016
				params.put("functionName", "csv_giacr221B"); 		 //added carlo de guzman 3/1/2016
				params.put("csvAction", "printGIACR221BCSV");		 //added carlo de guzman 3/1/2016	
				params.put("P_INTM_NO", request.getParameter("intmNo"));   //added by Dren 04.11.2016 SR-5357
			}else if("printGIACR259".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				params.put("P_BRANCH_PARAM", request.getParameter("branchParam"));
				params.put("P_DATE_PARAM", request.getParameter("dateParam"));
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_FROM", request.getParameter("fromDate")!= null && !request.getParameter("fromDate").equals("") ? df.parse(request.getParameter("fromDate")) : null);
				params.put("P_TO", request.getParameter("toDate")!= null && !request.getParameter("toDate").equals("") ? df.parse(request.getParameter("toDate")) : null);
				params.put("P_INTM_CD", request.getParameter("intmCd"));
				params.put("P_INTERMEDIARY_CD", request.getParameter("intermediaryCd"));
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("P_USER_ID", USER.getUserId());
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
			}else if("printGIACR052".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				//reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";	// replaced with codes below : shan 09.29.2014
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				
				params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_REPORT_ID", request.getParameter("reportId"));
				params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
				params.put("P_CHECK_DATE", (request.getParameter("checkDate") != null && !request.getParameter("checkDate").isEmpty() ? df.parse(request.getParameter("checkDate")) : null));
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId + "_" + request.getParameter("gaccTranId"));
				params.put("reportName", reportName);
			}else if("printGIACR052C".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				//reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";	// replaced with codes below : shan 09.29.2014
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				
				params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("P_CHK_PREFIX", request.getParameter("checkPrefix"));
				params.put("P_CHECK_NO", request.getParameter("checkNo"));
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_REPORT_ID", request.getParameter("reportId"));
				params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));				
				params.put("P_CHECK_DATE", (request.getParameter("checkDate") != null && !request.getParameter("checkDate").isEmpty() ? df.parse(request.getParameter("checkDate")) : null));
				
				if("PHILFIRE".equals(reportVersion)){ //marco - 12.10.2013
					params.put("P_ITEM_NO", request.getParameter("itemNo") == null ? null : Integer.parseInt(request.getParameter("itemNo")));
				}
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId + "_" + request.getParameter("gaccTranId"));
				params.put("reportName", reportName);
			}else if("printGIACR240".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				
				params.put("P_PAYEE_NO", new BigDecimal(request.getParameter("payeeNo")));
				params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd"));
				params.put("P_BEGIN_DATE", request.getParameter("fromDate"));
				params.put("P_END_DATE", request.getParameter("toDate"));
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
			}else if ("printGIACR241".equals(ACTION)) {
				String reportId = request.getParameter("reportId");
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				
				params.put("P_BEGIN_DATE", request.getParameter("beginDate"));
				params.put("P_END_DATE", request.getParameter("endDate"));
				params.put("P_OUC_ID", request.getParameter("oucId"));
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportName", reportId);
			}else if("printGIADD157".equals(ACTION)){ //added by MarkS SR5151 7.25.2016
				String reportId = request.getParameter("reportId");	
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generaldisbursement/reports")+"/";
				String reportLocation = "/com/geniisys/accounting/generaldisbursement/reports/";
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportLocation+"/")+"/";
				params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
				params.put("P_REPORT_ID", request.getParameter("reportId"));
				params.put("SUBREPORT_DIR", subreportDir);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
			} //end SR-5151
			
			this.doPrintReport(request, response, params, reportDir);
			
		} catch (JRException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (SQLException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (IOException e) {	
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}
}
