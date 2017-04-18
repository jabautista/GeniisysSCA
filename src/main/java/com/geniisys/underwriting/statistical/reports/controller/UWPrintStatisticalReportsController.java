package com.geniisys.underwriting.statistical.reports.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="UWPrintStatisticalReportsController", urlPatterns={"/UWPrintStatisticalReportsController"})
public class UWPrintStatisticalReportsController extends BaseController{

	private Logger log = Logger.getLogger(UWPrintStatisticalReportsController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			String reportsLocation = "/com/geniisys/underwriting/statistical/reports";
			String reportId = request.getParameter("reportId");
			String filename = reportId;
			String subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportsLocation+"/")+"/";
			String reportName = reportId;
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			
			if ("printReportsStatisticalTab".equals(ACTION)){
				if ("GIPIR071".equals(reportId)){
					params.put("P_EXTRACT_ID", Integer.parseInt(request.getParameter("extractId")));
					params.put("P_STARTING_DATE", sdf.parse(request.getParameter("fromDate")));
					params.put("P_ENDING_DATE", sdf.parse(request.getParameter("toDate")));
					//added by clperello | 06.10.2014
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
					params.put("P_VESSEL_CD", request.getParameter("vesselCargoCd"));
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_gipir071");
					params.put("csvAction", "printGIPIR071");
				}else if ("GIPIR072".equals(reportId)){
					params.put("P_EXTRACT_ID", Integer.parseInt(request.getParameter("extractId")));
					params.put("P_CARGO_CD", request.getParameter("vesselCargoCd"));
					params.put("P_STARTING_DATE", sdf.parse(request.getParameter("fromDate")));
					params.put("P_ENDING_DATE", sdf.parse(request.getParameter("toDate")));
					params.put("P_USER_ID", USER.getUserId());
					//added by clperello | 06.10.2014
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_gipir072");
					params.put("csvAction", "printGIPIR072");
				}
			}else if("printReportsMotorStatTab".equals(ACTION)){
				//GIRIR115, GIRIR116, GIRIR117, GIRIR118
				params.put("P_FROM_DATE", (request.getParameter("fromDate") == null || request.getParameter("fromDate") == "") ? "" : sdf.parse(request.getParameter("fromDate")));//Modified by pjsantos 12/15/2016, GENQA 5892
				params.put("P_TO_DATE",(request.getParameter("toDate")== null || request.getParameter("toDate") == "") ? "" : sdf.parse(request.getParameter("toDate")));//Modified by pjsantos 12/15/2016, GENQA 5892
				params.put("P_FROM_DATE_CHAR", request.getParameter("fromDate"));
				params.put("P_TO_DATE_CHAR", request.getParameter("toDate"));
				params.put("P_YEAR", request.getParameter("year"));
				params.put("P_DATE_PARAM", request.getParameter("dateParam"));
				params.put("P_USER_ID", USER.getUserId());
				//added by clperello | 06.10.2014
				if("GIRIR115".equals(reportId)){
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_girir115");
					params.put("csvAction", "printGIRIR115");	
				}else if("GIRIR116".equals(reportId)) {
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_girir116");
					params.put("csvAction", "printGIRIR116");	
				}else if("GIRIR117".equals(reportId)) {
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_girir117");
					params.put("csvAction", "printGIRIR117");	
				}else if("GIRIR118".equals(reportId)) {
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_girir118");
					params.put("csvAction", "printGIRIR118");	
				}
			}else if("printReportsFireStatTab".equals(ACTION)){
				if ("GIPIR037".equals(reportId) || "GIPIR037A".equals(reportId)){
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_BUS_CD", request.getParameter("busCd"));
					params.put("P_EXPIRED_AS_OF", request.getParameter("expiredAsOf").equals("") ||  request.getParameter("expiredAsOf").equals(null) ? "" : request.getParameter("expiredAsOf")/*sdf.parse(request.getParameter("expiredAsOf"))*/);//edgar 02/24/2015
					params.put("P_PERIOD_START", request.getParameter("periodStart").equals("") ||  request.getParameter("periodStart").equals(null) ? "" : request.getParameter("periodStart")/*sdf.parse(request.getParameter("periodStart"))*/);//edgar 02/24/2015
					params.put("P_PERIOD_END", request.getParameter("periodEnd").equals("") ||  request.getParameter("periodEnd").equals(null) ? "" : request.getParameter("periodEnd")/*sdf.parse(request.getParameter("periodEnd"))*/);//edgar 02/24/2015
					params.put("P_DATE_TYPE", request.getParameter("pDate"));
					params.put("P_INC_ENDT", request.getParameter("inclEndt"));
					params.put("P_INC_EXP", request.getParameter("inclExp"));
					params.put("P_ZONETYPE", request.getParameter("zoneType"));
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015
					params.put("P_USER", USER.getUserId());		
					//added by steven 06.19.2014
					params.put("P_EXPIRED_AS_OF_CHAR", request.getParameter("expiredAsOf").equals(""));
					params.put("P_PERIOD_START_CHAR", request.getParameter("periodStart").equals(""));
					params.put("P_PERIOD_END_CHAR", request.getParameter("periodEnd").equals(""));
					//added by clperello | 06.10.2014
					params.put("P_COLUMN", request.getParameter("columnName"));
					params.put("P_TABLE", request.getParameter("tableName"));
					//params.put("packageName", "CSV_UNDRWRTNG");  // jhing 03.21.2015 commented out and replaced with new package
					if ( "GIPIR037".equals(reportId) ) {
						params.put("packageName", "CSV_UW_GENSTAT_REP"); 
						params.put("functionName", "csv_gipir037");		
						params.put("csvAction", "printGIPIR037");					
					} else {
						params.put("csvAction", "printGIPIR037A");
						params.put("csvVersion", "dynamicSQL");    // jhing 04.16.2015 		
					}

				}else if("GIPIR039A".equals(reportId)){
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_AS_OF", request.getParameter("asOfDate").equals("") ||  request.getParameter("asOfDate").equals(null) ? "" : request.getParameter("asOfDate")/*sdf.parse(request.getParameter("asOfDate"))*/); //edgar 03/09/2015
					params.put("P_FROM_DATE", request.getParameter("dateFrom").equals("") ||  request.getParameter("dateFrom").equals(null) ? "" : request.getParameter("dateFrom")/*sdf.parse(request.getParameter("dateFrom"))*/); //edgar 03/09/2015
					params.put("P_TO_DATE", request.getParameter("dateTo").equals("") ||  request.getParameter("dateTo").equals(null) ? "" : request.getParameter("dateTo")/*sdf.parse(request.getParameter("dateTo"))*/); //edgar 03/09/2015
					params.put("P_ZONE_TYPE", request.getParameter("zoneType"));
					params.put("P_DATE", request.getParameter("pDate"));
					params.put("P_USER_ID", USER.getUserId());	
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015					
					//added by steven 06.19.2014
					params.put("P_AS_OF_CHAR", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE_CHAR", request.getParameter("dateFrom"));
					params.put("P_TO_DATE_CHAR", request.getParameter("dateTo"));
					//added by clperello | 06.10.2014
					params.put("P_COLUMN", request.getParameter("columnName"));
					params.put("P_TABLE", request.getParameter("tableName"));
					//params.put("packageName", "CSV_UNDRWRTNG");
					params.put("packageName", "CSV_UW_GENSTAT_REP");
					params.put("functionName", "csv_gipir039a");
					params.put("csvAction", "printGIPIR039A");
				}else if("GIPIR039B".equals(reportId)){
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_BUS_CD", request.getParameter("busCd"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate").equals("") ||  request.getParameter("asOfDate").equals(null) ? "" : request.getParameter("asOfDate")/*sdf.parse(request.getParameter("asOfDate"))*/);//edgar 03/09/2015
					params.put("P_FROM_DATE", request.getParameter("dateFrom").equals("") ||  request.getParameter("dateFrom").equals(null) ? "" : request.getParameter("dateFrom")/*sdf.parse(request.getParameter("dateFrom"))*/);//edgar 03/09/2015
					params.put("P_TO_DATE", request.getParameter("dateTo").equals("") ||  request.getParameter("dateTo").equals(null) ? "" : request.getParameter("dateTo")/*sdf.parse(request.getParameter("dateTo"))*/);//edgar 03/09/2015
					params.put("P_ZONE_TYPE", request.getParameter("zoneType"));
					params.put("P_DATE", request.getParameter("pDate"));
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015
					//added by steven 06.19.2014
					params.put("P_AS_OF_DATE_CHAR", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE_CHAR", request.getParameter("dateFrom"));
					params.put("P_TO_DATE_CHAR", request.getParameter("dateTo"));
					//added by clperello | 06.10.2014
					params.put("P_USER_ID", USER.getUserId());		
					params.put("P_COLUMN", request.getParameter("columnName"));
					params.put("P_TABLE", request.getParameter("tableName"));
					//params.put("packageName", "CSV_UNDRWRTNG");
					params.put("packageName", "CSV_UW_GENSTAT_REP");
					params.put("functionName", "csv_gipir039b");
					params.put("csvAction", "printGIPIR039B");
				}else if("GIPIR039C".equals(reportId)){
					params.put("AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_AS_OF", request.getParameter("asOfDate"));// request.getParameter("asOfDate").equals("") ||  request.getParameter("asOfDate").equals(null) ? "" : sdf.parse(request.getParameter("asOfDate"))); //edgar 03/09/2015
					params.put("P_FROM_DATE", request.getParameter("dateFrom"));//request.getParameter("dateFrom").equals("") ||  request.getParameter("dateFrom").equals(null) ? "" : sdf.parse(request.getParameter("dateFrom")));//edgar 03/09/2015
					params.put("P_TO_DATE", request.getParameter("dateTo"));//request.getParameter("dateTo").equals("") ||  request.getParameter("dateTo").equals(null) ? "" : sdf.parse(request.getParameter("dateTo")));//edgar 03/09/2015
					params.put("P_ZONE_TYPE", request.getParameter("zoneType"));
					params.put("P_DATE", request.getParameter("pDate"));
					params.put("P_COLUMN", request.getParameter("columnName"));
					params.put("P_TABLE", request.getParameter("tableName"));
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015
					params.put("P_CONSOL_SW", request.getParameter("consolSw")); //edgar 04/13/2015
					params.put("P_USER_ID", USER.getUserId()); //edgar 04/13/2015
					params.put("packageName", "CSV_UW_GENSTAT_REP"); //edgar 04/13/2015
					params.put("functionName", "csv_gipir039C");//edgar 04/13/2015
					params.put("csvAction", "printGIPIR039C");//edgar 04/13/2015
				}else if("GIPIR039E".equals(reportId)){
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE", request.getParameter("dateFrom"));
					params.put("P_TO_DATE", request.getParameter("dateTo"));
					params.put("P_ZONE_TYPE", request.getParameter("zoneType"));
					params.put("P_DATE", request.getParameter("pDate"));
					params.put("P_TRTY_TYPE_CD", request.getParameter("trtyTypeCd"));
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015
					params.put("P_CONSOL_SW", request.getParameter("consolSw")); //edgar 04/13/2015
					params.put("P_PRINT_SW", request.getParameter("printSw")); //edgar 04/13/2015
					params.put("P_USER_ID", USER.getUserId()); //edgar 04/13/2015
					params.put("packageName", "CSV_UW_GENSTAT_REP"); //edgar 04/13/2015
					params.put("functionName", "csv_gipir039E");//edgar 04/13/2015
					params.put("csvAction", "printGIPIR039E");//edgar 04/13/2015
					
					if (request.getParameter("consolSw").equalsIgnoreCase("Y"))  {
						reportId = "GIPIR039H";
						filename = "GIPIR039H";
						reportName = "GIPIR039H";
						params.put("csvAction", "printGIPIR039H");
						params.put("packageName", "CSV_UW_GENSTAT_REP"); 
						params.put("functionName", "csv_gipir039H");
					}
				}else if("GIPIR039G".equals(reportId)){
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE", request.getParameter("dateFrom"));
					params.put("P_TO_DATE", request.getParameter("dateTo"));
					params.put("P_ZONE_TYPE", request.getParameter("zoneType"));
					params.put("P_DATE", request.getParameter("pDate"));
					params.put("P_USER_ID", USER.getUserId());		
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015
					params.put("P_CONSOL_SW", request.getParameter("consolSw")); //edgar 04/13/2015
					params.put("P_USER_ID", USER.getUserId()); //edgar 04/13/2015
					params.put("packageName", "CSV_UW_GENSTAT_REP"); //edgar 04/13/2015
					params.put("functionName", "csv_gipir039G");//edgar 04/13/2015
					params.put("csvAction", "printGIPIR039G");//edgar 04/13/2015
				}else if( "GIPIR037C".equals(reportId)){
					params.put("P_AS_OF", request.getParameter("asOfDate"));
					params.put("P_BUSINESS", request.getParameter("businessCd"));
					params.put("P_FROM_DATE", request.getParameter("dateFrom"));
					params.put("P_TO_DATE", request.getParameter("dateTo"));
					params.put("P_ZONE", request.getParameter("zone"));
					params.put("P_ZONE_TYPE", request.getParameter("zoneType")); //benjo 04/14/2015
					params.put("P_DATE", request.getParameter("pDate"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015
					params.put("P_EXPIRED_AS_OF", request.getParameter("asOfDate").equals("") ||  request.getParameter("asOfDate").equals(null) ? "" : request.getParameter("asOfDate"));//jhing 04/21/2015
					params.put("P_PERIOD_START", request.getParameter("dateFrom").equals("") ||  request.getParameter("dateFrom").equals(null) ? "" : request.getParameter("dateFrom"));//jhing 04/21/2015
					params.put("P_PERIOD_END", request.getParameter("dateTo").equals("") ||  request.getParameter("dateTo").equals(null) ? "" : request.getParameter("dateTo"));//jhing 04/21/2015
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));//jhing 04/21/2015
					params.put("packageName", "CSV_UW_GENSTAT_REP"); //edgar 04/13/2015
					params.put("functionName", "csv_gipir037C");//edgar 04/13/2015
					params.put("csvAction", "printGIPIR037C");//edgar 04/13/2015
				}else if("GIPIR037B".equals(reportId)){
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_AS_OF", request.getParameter("asOfDate"));
					params.put("P_BUSINESS", request.getParameter("businessCd"));
					params.put("P_FROM_DATE", request.getParameter("dateFrom"));
					params.put("P_TO_DATE", request.getParameter("dateTo"));
					params.put("P_ZONE", request.getParameter("zone"));
					params.put("P_DATE", request.getParameter("pDate"));
					params.put("P_ZONE_TYPE", request.getParameter("zoneType")); //edgar 04/15/2015
					params.put("P_LINE_CD", request.getParameter("lineCdFi")); //edgar 04/15/2015
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015
					params.put("P_EXPIRED_AS_OF", request.getParameter("asOfDate").equals("") ||  request.getParameter("asOfDate").equals(null) ? "" : request.getParameter("asOfDate"));//jhing 04/21/2015
					params.put("P_PERIOD_START", request.getParameter("dateFrom").equals("") ||  request.getParameter("dateFrom").equals(null) ? "" : request.getParameter("dateFrom"));//jhing 04/21/2015
					params.put("P_PERIOD_END", request.getParameter("dateTo").equals("") ||  request.getParameter("dateTo").equals(null) ? "" : request.getParameter("dateTo"));//jhing 04/21/2015
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));//jhing 04/21/2015
					
					params.put("packageName", "CSV_UW_GENSTAT_REP"); //edgar 04/13/2015
					params.put("functionName", "csv_gipir037B");//edgar 04/13/2015
					params.put("csvAction", "printGIPIR037B");//edgar 04/13/2015
				}else if ("GIPIR039D".equals(reportId)){
					params.put("P_ZONE_TYPE", Integer.parseInt(request.getParameter("zoneType")));
					params.put("P_COLUMN", request.getParameter("columnName"));
					params.put("P_TABLE", request.getParameter("tableName"));
					params.put("P_DATE", request.getParameter("dateParam"));
					/*params.put("P_AS_OF", request.getParameter("asOfDate").equals("") ||  request.getParameter("asOfDate").equals(null) ? "" : sdf.parse(request.getParameter("asOfDate")));
					params.put("P_FROM_DATE", request.getParameter("dateFrom").equals("") ||  request.getParameter("dateFrom").equals(null) ? "" : sdf.parse(request.getParameter("dateFrom")));
					params.put("P_TO_DATE", request.getParameter("dateTo").equals("") ||  request.getParameter("dateTo").equals(null) ? "" : sdf.parse(request.getParameter("dateTo")));*/ //replaced with codes below
					params.put("P_AS_OF", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE", request.getParameter("dateFrom"));
					params.put("P_TO_DATE", request.getParameter("dateTo"));
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_BY_COUNT", request.getParameter("byCount"));
					params.put("P_WHERE", request.getParameter(""));
					params.put("P_INC_EXP", request.getParameter("inclExp"));
					params.put("P_INC_ENDT", request.getParameter("inclEndt"));
					params.put("P_DATE_TYPE", request.getParameter("dateType"));
					params.put("P_USER_ID", USER.getUserId());
					//added by steven 06.19.2014 for CSV params
					params.put("P_AS_OF_CHAR", request.getParameter("asOfDate"));
					params.put("P_FROM_DATE_CHAR", request.getParameter("dateFrom"));
					params.put("P_TO_DATE_CHAR", request.getParameter("dateTo"));
					
					//added by clperello | 06.10.2014
					params.put("packageName", "CSV_UW_GENSTAT_REP");
					params.put("functionName", "csv_gipir039d");
					params.put("csvAction", "printGIPIR039D");
					params.put("csvVersion", "dynamicSQL");    // jhing 04.16.2015 
					params.put("createCSVFromString", "Y"); // Added by Jerome Bautista SR 21338 02.09.2016
				}else if ("GIPIR038A".equals(reportId) || "GIPIR038B".equals(reportId)){
					params.put("P_ZONE_TYPE", request.getParameter("zoneType"));
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_EXPIRED_AS_OF", request.getParameter("asOfDate").equals("") ||  request.getParameter("asOfDate").equals(null) ? "" :request.getParameter("asOfDate")/*sdf.parse(request.getParameter("asOfDate"))*/);//edgar 03/09/2015
					params.put("P_PERIOD_START", request.getParameter("dateFrom").equals("") ||  request.getParameter("dateFrom").equals(null) ? "" :request.getParameter("dateFrom")/*sdf.parse(request.getParameter("dateFrom"))*/);//edgar 03/09/2015
					params.put("P_PERIOD_END", request.getParameter("dateTo").equals("") ||  request.getParameter("dateTo").equals(null) ? "" :request.getParameter("dateTo")/*sdf.parse(request.getParameter("dateTo"))*/);//edgar 03/09/2015
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015
					//added by steven 06.19.2014 for CSV params
					params.put("P_EXPIRED_AS_OF_CHAR", request.getParameter("asOfDate"));
					params.put("P_PERIOD_START_CHAR", request.getParameter("dateFrom"));
					params.put("P_PERIOD_END_CHAR", request.getParameter("dateTo"));
					//added by clperello | 06.10.2014
					if("GIPIR038A".equals(reportId)){
						params.put("packageName", "CSV_UNDRWRTNG");
						params.put("functionName", "csv_gipir038a");
						params.put("csvAction", "printGIPIR038A");	
					}else {
						params.put("packageName", "CSV_UNDRWRTNG");
						params.put("functionName", "csv_gipir038b");
						params.put("csvAction", "printGIPIR038B");
					}
				}else if ("GIPIR038C".equals(reportId)){
					params.put("P_ZONE_TYPE", request.getParameter("zoneType"));
					params.put("P_ZONE_TYPEA", request.getParameter("zoneTypeA"));
					params.put("P_ZONE_TYPEB", request.getParameter("zoneTypeB"));
					params.put("P_ZONE_TYPEC", request.getParameter("zoneTypeC"));
					params.put("P_ZONE_TYPED", request.getParameter("zoneTypeD"));
					params.put("P_AS_OF_SW", request.getParameter("asOfSw"));
					params.put("P_EXPIRED_AS_OF", request.getParameter("asOfDate").equals("") ||  request.getParameter("asOfDate").equals(null) ? "" : request.getParameter("asOfDate")/*sdf.parse(request.getParameter("asOfDate"))*/); //edgar 03/09/2015
					params.put("P_PERIOD_START", request.getParameter("dateFrom").equals("") ||  request.getParameter("dateFrom").equals(null) ? "" : request.getParameter("dateFrom")/*sdf.parse(request.getParameter("dateFrom"))*/); //edgar 03/09/2015
					params.put("P_PERIOD_END", request.getParameter("dateTo").equals("") ||  request.getParameter("dateTo").equals(null) ? "" : request.getParameter("dateTo")/*sdf.parse(request.getParameter("dateTo"))*/); //edgar 03/09/2015
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_RISK_CNT", request.getParameter("riskCnt")); //edgar 03/13/2015
					//added by steven 06.19.2014 for CSV params
					params.put("P_EXPIRED_AS_OF_CHAR", request.getParameter("asOfDate"));
					params.put("P_PERIOD_START_CHAR", request.getParameter("dateFrom"));
					params.put("P_PERIOD_END_CHAR", request.getParameter("dateTo"));
					//added by clperello | 06.10.2014
					//params.put("packageName", "CSV_UNDRWRTNG");
					params.put("packageName", "CSV_UW_GENSTAT_REP");
					params.put("functionName", "csv_gipir038c");
					params.put("csvAction", "printGIPIR038C");
					params.put("csvVersion", "dynamicSQL");    // jhing 04.16.2015 
				}
				/* GIRIR037A, GIRIR039G */
				
			}else if("printReportsRiskProfileTab".equals(ACTION)){
				if("GIPIR940".equals(reportId) || "GIPIR941".equals(reportId) || "GIPIR947".equals(reportId) || "GIPIR947B".equals(reportId) 
						|| "GIPIR948".equals(reportId)  || "GIPIR949".equals(reportId) || "GIPIR949A".equals(reportId) || "GIPIR947".equals(reportId)){ //benjo 04.01.2015 added GIPIR947
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));						
					params.put("P_STARTING_DATE", request.getParameter("fromDate")); //@FGIC Kenneth 10.23.2014
					params.put("P_ENDING_DATE", request.getParameter("toDate")); //@FGIC Kenneth 10.23.2014
					params.put("P_STARTING_DATE2", sdf.parse(request.getParameter("fromDate")));
					params.put("P_ENDING_DATE2", sdf.parse(request.getParameter("toDate")));
					params.put("P_PARAM_DATE", request.getParameter("paramDate"));
					params.put("P_BY_TARF", request.getParameter("byTarf"));
					params.put("P_USER_ID", USER.getUserId());
					//added by steven 06.18.2014
					params.put("P_STARTING_DATE_CHAR", request.getParameter("fromDate"));
					params.put("P_ENDING_DATE_CHAR", request.getParameter("toDate"));
					//added by clperello | 06.10.2014
					params.put("P_ALL_LINE_TAG", request.getParameter("allLineTag"));
					if("GIPIR940".equals(reportId)){
						params.put("packageName", "CSV_UNDRWRTNG");
						params.put("functionName", "csv_gipir940");
						params.put("csvAction", "printGIPIR940");
						params.put("csvVersion", "dynamicSQL");
					}else if("GIPIR941".equals(reportId)){
						params.put("packageName", "CSV_UNDRWRTNG");
						params.put("functionName", "csv_gipir941");
						params.put("csvAction", "printGIPIR941");
						params.put("csvVersion", "dynamicSQL");
					}else if("GIPIR947".equals(reportId)){ //benjo 04.01.2015 added GIPIR947
						params.put("packageName", "CSV_UW_RISK_PROFILE");
						params.put("functionName", "csv_gipir947");
						params.put("csvAction", "printGIPIR947");
						params.put("csvVersion", "dynamicSQL");						
					}else if("GIPIR947B".equals(reportId)){
						params.put("packageName", "CSV_UNDRWRTNG");
						params.put("functionName", "csv_gipir947b");
						params.put("csvAction", "printGIPIR947B");
						params.put("csvVersion", "dynamicSQL");
					}else if("GIPIR948".equals(reportId)){ //benjo 04.01.2015 added GIPIR948
						params.put("packageName", "CSV_UW_RISK_PROFILE");
						params.put("functionName", "csv_gipir948");
						params.put("csvAction", "printGIPIR948");
						params.put("csvVersion", "dynamicSQL");
					}else if("GIPIR949".equals(reportId)){
						params.put("P_SHOW_TARF", request.getParameter("showTarf")); //benjo 04.06.2015 added P_SHOW_TARF
						params.put("packageName", "CSV_UW_RISK_PROFILE"); //benjo 04.06.2015 replaced with new package CSV_UNDRWRTNG -> CSV_UW_RISK_PROFILE
						params.put("functionName", "csv_gipir949");
						params.put("csvAction", "printGIPIR949");
						params.put("csvVersion", "dynamicSQL");
					}else if("GIPIR949A".equals(reportId)){ //benjo 04.06.2015 added GIPIR949A
						params.put("packageName", "CSV_UW_RISK_PROFILE");
						params.put("functionName", "csv_gipir949a");
						params.put("csvAction", "printGIPIR949a");
						params.put("csvVersion", "dynamicSQL");
					} 
				}else if("GIPIR949B".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));						
					params.put("P_STARTING_DATE", request.getParameter("fromDate")); //sdf.parse(request.getParameter("fromDate"))); benjo 03.30.2015
					params.put("P_ENDING_DATE", request.getParameter("toDate")); //sdf.parse(request.getParameter("toDate"))); benjo 03.30.2015
					params.put("P_PARAM_DATE", request.getParameter("paramDate"));
					params.put("P_ALL_LINE_TAG", request.getParameter("allLineTag"));
					params.put("P_USER_ID", USER.getUserId());
					//added by clperello | 06.10.2014
					params.put("P_BY_TARF", request.getParameter("byTarf"));
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_gipir949b");
					params.put("csvAction", "printGIPIR949B");
					//added by steven 06.19.2014 for CSV param
					params.put("P_STARTING_DATE_CHAR", request.getParameter("fromDate"));
					params.put("P_ENDING_DATE_CHAR", request.getParameter("toDate"));
					params.put("csvVersion", "dynamicSQL");
				}else if("GIPIR934".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));						
					params.put("P_FROM_DATE", request.getParameter("fromDate")); //sdf.parse(request.getParameter("fromDate"))); benjo 03.31.2015
					params.put("P_TO_DATE", request.getParameter("toDate")); //sdf.parse(request.getParameter("toDate"))); benjo 03.31.2015
					params.put("P_PARAM_DATE", request.getParameter("paramDate"));
					params.put("P_BY_TARF", request.getParameter("byTarf"));
					params.put("P_USER_ID", USER.getUserId());
					//added by clperello | 06.10.2014
					params.put("P_ALL_LINE_TAG", request.getParameter("allLineTag"));
					params.put("packageName", "CSV_UW_RISK_PROFILE"); //benjo 03.31.2015 replaced with new package CSV_UNDRWRTNG -> CSV_UW_RISK_PROFILE
					params.put("functionName", "csv_gipir934");
					params.put("csvAction", "printGIPIR934");
					params.put("csvVersion", "dynamicSQL");
				}else if("GIPIR949C".equals(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate")); //sdf.parse(request.getParameter("fromDate"))); benjo 03.31.2015
					params.put("P_TO_DATE", request.getParameter("toDate")); //sdf.parse(request.getParameter("toDate"))); benjo 03.31.2015
					//added by clperello | 06.10.2014
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));	
					params.put("P_ALL_LINE_TAG", request.getParameter("allLineTag"));
					params.put("P_PARAM_DATE", request.getParameter("paramDate"));
					params.put("P_BY_TARF", request.getParameter("byTarf"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_gipir949c");
					params.put("csvAction", "printGIPIR949C");
					//added by steven 06.19.2014 for CSV param
					params.put("P_FROM_DATE_CHAR", request.getParameter("fromDate"));
					params.put("P_TO_DATE_CHAR", request.getParameter("toDate"));
					params.put("csvVersion", "dynamicSQL");
				}
			}
			
			params.put("MAIN_REPORT", reportId+".jasper");
			params.put("OUTPUT_REPORT_FILENAME", filename);
			params.put("reportName", reportName);
			params.put("mediaSizeName", "US_STD_FANFOLD");
			System.out.println(reportId + " PARAMS: " + params.toString());
			
			log.info("Creating UW RI Report: " + filename);
			
			this.doPrintReport(request, response, params, subreportDir);
		}catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
