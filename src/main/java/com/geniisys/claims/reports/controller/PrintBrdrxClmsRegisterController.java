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

@WebServlet (name="PrintBrdrxClmsRegisterController", urlPatterns={"/PrintBrdrxClmsRegisterController"})
public class PrintBrdrxClmsRegisterController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			if("printReportGicls202".equals(ACTION)){
				String reportId = request.getParameter("reportId");				
				Map<String, Object> params = new HashMap<String, Object>();
				DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
				params.put("P_USER_ID", USER.getUserId());
				
				if(request.getParameter("repName").equals("1")){
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_DATE_AS_OF", request.getParameter("asOfDate"));
					params.put("P_DATE_OPTION", Integer.parseInt(request.getParameter("dateOption")));
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					params.put("P_ISS_BREAK", Integer.parseInt(request.getParameter("issBreak")));
					params.put("P_SUBLINE_BREAK", Integer.parseInt(request.getParameter("sublineBreak")));
					params.put("P_OS_DATE", request.getParameter("osDate") == "" || request.getParameter("osDate") == null ? null : Integer.parseInt(request.getParameter("osDate")));
				}
				
				params.put("P_SESSION_ID", Integer.parseInt(request.getParameter("sessionId")));
				
				if("GICLR205L".equals(reportId)){ // error
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					params.put("P_PAGE_BREAK", request.getParameter("intmBreak"));
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate") == null || request.getParameter("asOfDate") == "" ? null : date.parse(request.getParameter("asOfDate")));
					params.put("P_AMT", request.getParameter("amt"));
					params.put("P_DATE_OPTION", Integer.parseInt(request.getParameter("dateOption")));
					params.put("P_ISS_BREAK", Integer.parseInt(request.getParameter("issBreak")));
					params.put("P_SUBLINE_BREAK", Integer.parseInt(request.getParameter("sublineBreak")));
					//added by clperello | 06.09.2014
					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr205l");
					params.put("csvAction", "printGICLR205L");
				}else if("GICLR208L".equals(reportId)){
					//
				}else if("GICLR208A".equals(reportId)){
					//added by clperello | 06.09.2014
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					params.put("P_ISS_BREAK", request.getParameter("issBreak"));
					params.put("P_SUBLINE_BREAK", Integer.parseInt(request.getParameter("sublineBreak")));
					params.put("P_CHK_OPTION", request.getParameter("chkOption")); // bonok :: 1.17.2017 :: FGIC SR 23448
					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr208a");
					params.put("csvAction", "printGICLR208A");
				}else if("GICLR208C".equals(reportId)){
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));
					params.put("P_AGING_DATE", Integer.parseInt(request.getParameter("agingDate")));
				}else if("GICLR205E".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate") == null || request.getParameter("asOfDate") == "" ? null : date.parse(request.getParameter("asOfDate")));
					params.put("P_AMT", request.getParameter("amt"));
					//added by clperello | 06.09.2014
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					params.put("P_ISS_BREAK", Integer.parseInt(request.getParameter("issBreak")));
					params.put("P_SUBLINE_BREAK", Integer.parseInt(request.getParameter("sublineBreak")));
					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr205e");
					params.put("csvAction", "printGICLR205E");
				}else if("GICLR208E".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
				}else if("GICLR208B".equals(reportId)){
					//added by clperello | 06.09.2014
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					params.put("P_ISS_BREAK", request.getParameter("issBreak"));
					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr208b");
					params.put("csvAction", "printGICLR208B");
				}else if("GICLR208D".equals(reportId)){
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));
					params.put("P_AGING_DATE", Integer.parseInt(request.getParameter("agingDate")));
				}else if("GICLR205LE".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate") == null || request.getParameter("asOfDate") == "" ? null : date.parse(request.getParameter("asOfDate")));
					params.put("P_AMT", request.getParameter("amt"));
					params.put("P_INTM_BREAK", request.getParameter("intmBreak"));
					params.put("P_ISS_BREAK", request.getParameter("issBreak"));
					params.put("P_SUBLINE_BREAK", request.getParameter("sublineBreak"));		
					//added by clperello | 06.09.2014
					//start kenneth SR 19960 08112015
					//params.put("packageName", "CSV_BRDRX");
					//params.put("functionName", "csv_giclr205le");
					params.put("csvAction", "printGICLR205LE"); 
					//params.put("csvVersion", "dynamicSQL"); //Deo [01.09.2017]: comment out (SR-23537)
					params.put("createCSVFromString", "Y"); //Deo [01.09.2017]: SR-23537
					//end kenneth SR 19960 08112015
				}else if("GICLR208LE".equals(reportId) || "GICLR208LE_CSV".equals(reportId)){
					// report not yet finished
				}else if("GICLR205LR".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate") == null || request.getParameter("asOfDate") == "" ? null : date.parse(request.getParameter("asOfDate")));
					params.put("P_AMT", request.getParameter("amt"));
					params.put("P_DATE_OPTION", request.getParameter("dateOption"));
					params.put("P_INTM_BREAK", request.getParameter("intmBreak"));
					params.put("P_ISS_BREAK", request.getParameter("issBreak"));
					params.put("P_SUBLINE_BREAK", request.getParameter("sublineBreak"));
					params.put("P_OS_DATE", request.getParameter("osDate"));
				}else if("GICLR208LR".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_ISS_BREAK", request.getParameter("issBreak"));
				}else if("GICLR208AR".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
				}else if("GICLR208CR".equals(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_OS_DATE", request.getParameter("osDate"));
					params.put("P_AGING_DATE", Integer.parseInt(request.getParameter("agingDate")));
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));
				}else if("GICLR205ER".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate") == null || request.getParameter("asOfDate") == "" ? null : date.parse(request.getParameter("asOfDate")));
					params.put("P_DATE_OPTION", request.getParameter("dateOption"));
					params.put("P_AMT", request.getParameter("amt"));
					params.put("P_INTM_BREAK", request.getParameter("intmBreak"));
					params.put("P_PAGE_BREAK", request.getParameter("intmBreak"));
					params.put("P_ISS_BREAK", request.getParameter("issBreak"));
					params.put("P_SUBLINE_BREAK", request.getParameter("sublineBreak"));
					params.put("P_OS_DATE", request.getParameter("osDate"));
				}else if("GICLR208ER".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_ISS_BREAK", request.getParameter("issBreak"));
				}else if("GICLR208BR".equals(reportId)){
					//
				}else if("GICLR208DR".equals(reportId)){
					params.put("P_AGING_DATE", Integer.parseInt(request.getParameter("agingDate")));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_CUT_OFF_DATE", request.getParameter("cutOffDate"));
				}else if("GICLR222L".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_FROM_DATE2", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.format(date.parse(request.getParameter("fromDate"))));
					params.put("P_TO_DATE2", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.format(date.parse(request.getParameter("toDate"))));
					params.put("P_AMT", request.getParameter("amt"));
					//added by clperello | 06.09.2014
					//params.put("packageName", "csv_brdrx_dynamic");
					//params.put("functionName", "csv_giclr222l_dynsql");
					params.put("csvAction", "printGICLR222L"); 
					//params.put("csvVersion", "dynamicSQL"); //SR-5366 //Deo [01.09.2017]: comment out (SR-23537)
					params.put("createCSVFromString", "Y"); //Deo [01.09.2017]: SR-23537
				}else if("GICLR221L".equals(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_FROM_DATE2", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.format(date.parse(request.getParameter("fromDate"))));
					params.put("P_TO_DATE2", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.format(date.parse(request.getParameter("toDate"))));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_AMT", request.getParameter("amt"));
					//added by clperello | 06.09.2014
					/*params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr221l"); comment out SR-5363*/
					params.put("csvAction", "printGICLR221L");
					//params.put("csvVersion", "dynamicSQL");//added jm SR-5363 //Deo [01.09.2017]: comment out (SR-23537)
					params.put("createCSVFromString", "Y"); //Deo [01.09.2017]: SR-23537
				}else if("GICLR206L".equals(reportId)){
					//marco - 03.12.2014
					//params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					//params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_TO_DATE2", date.format(date.parse(request.getParameter("toDate"))));
					params.put("P_FROM_DATE2", date.format(date.parse(request.getParameter("fromDate"))));
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_AMT", request.getParameter("amt"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					//added by clperello | 06.09.2014
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr206l");
					params.put("csvAction", "printGICLR206L");
				}else if("GICLR209L".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
				}else if("GICLR209A".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_PAID_DATE", request.getParameter("paidDate"));
					//added by clperello | 06.09.2014
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					params.put("P_ISS_BREAK", Integer.parseInt(request.getParameter("issBreak")));
					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr209a");
					params.put("csvAction", "printGICLR209A");
				}else if("GICLR222E".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_AMT", request.getParameter("amt"));
					params.put("P_FROM_DATE2", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.format(date.parse(request.getParameter("fromDate"))));
					params.put("P_TO_DATE2", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.format(date.parse(request.getParameter("toDate"))));
					//added by clperello | 06.09.2014
/*					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr222e");//Removed by Carlo Rubenecia SR-5367 05.10.11*/
					params.put("csvAction", "printGICLR222E"); 
					//params.put("csvVersion", "dynamicSQL"); //Added By Carlo Rubenecia SR-5367 05.10.11 //Deo [01.09.2017]: comment out (SR-23537)
					params.put("createCSVFromString", "Y"); //Deo [01.09.2017]: SR-23537
				}else if("GICLR221E".equals(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_FROM_DATE2", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.format(date.parse(request.getParameter("fromDate"))));
					params.put("P_TO_DATE2", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.format(date.parse(request.getParameter("toDate"))));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_AMT", request.getParameter("amt"));
					//added by clperello | 06.09.2014
					/*params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr221e");*/
					params.put("csvAction", "printGICLR221E");
					//params.put("csvVersion", "dynamicSQL");//jm //Deo [01.09.2017]: comment out (SR-23537)
					params.put("createCSVFromString", "Y"); //Deo [01.09.2017]: SR-23537
				}else if("GICLR206E".equals(reportId)){
					//marco - 03.11.2013
					//params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					//params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_TO_DATE2", date.format(date.parse(request.getParameter("toDate"))));
					params.put("P_FROM_DATE2", date.format(date.parse(request.getParameter("fromDate"))));
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_AMT", request.getParameter("amt"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					//added by clperello | 06.09.2014
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr206e");
					params.put("csvAction", "printGICLR206E");
				}else if("GICLR209E".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
				}else if("GICLR209B".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_PAID_DATE", request.getParameter("paidDate"));
					//added by clperello | 06.09.2014
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					params.put("P_ISS_BREAK", Integer.parseInt(request.getParameter("issBreak")));
					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr209b");
					params.put("csvAction", "printGICLR209B");
				}else if("GICLR222LE".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_FROM_DATE2", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.format(date.parse(request.getParameter("fromDate"))));
					params.put("P_TO_DATE2", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.format(date.parse(request.getParameter("toDate"))));
					params.put("P_AMT", request.getParameter("amt"));
					//added by clperello | 06.09.2014
/*					params.put("packageName", "CSV_BRDRX");
					params.put("functionName", "csv_giclr222le"); Removed by Carlo Rubenecia SR 5368 05.17.2016*/
					params.put("csvAction", "printGICLR222LE");
					//params.put("csvVersion", "dynamicSQL"); //Added by Carlo Rubenecia SR 5368 05.17.2016 //Deo [01.09.2017]: comment out (SR-23537)
					params.put("createCSVFromString", "Y"); //Deo [01.09.2017]: SR-23537
				}else if("GICLR221LE".equals(reportId)){
					params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_FROM_DATE2", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.format(date.parse(request.getParameter("fromDate"))));
					params.put("P_TO_DATE2", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.format(date.parse(request.getParameter("toDate"))));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_AMT", request.getParameter("amt"));
					//added by clperello | 06.09.2014
					//params.put("packageName", "CSV_BRDRX");
					//params.put("functionName", "csv_giclr221le");
					params.put("csvAction", "printGICLR221LE");
					//params.put("csvVersion", "dynamicSQL"); //Deo [01.09.2017]: comment out (SR-23537)
					params.put("createCSVFromString", "Y"); //Deo [01.09.2017]: SR-23537
				}else if("GICLR206LE".equals(reportId)){
					//marco - 03.12.2014
					//params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					//params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_TO_DATE2", date.format(date.parse(request.getParameter("toDate"))));
					params.put("P_FROM_DATE2", date.format(date.parse(request.getParameter("fromDate"))));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_AMT", request.getParameter("amt"));
					//added by clperello | 06.09.2014
					params.put("P_INTM_BREAK", Integer.parseInt(request.getParameter("intmBreak")));
					//start kenneth SR 19960 08112015
					//params.put("packageName", "CSV_BRDRX");
					//params.put("functionName", "csv_giclr206le");
					params.put("csvAction", "printGICLR206LE");
					//params.put("csvVersion", "dynamicSQL"); //Deo [01.09.2017]: comment out (SR-23537)
					params.put("createCSVFromString", "Y"); //Deo [01.09.2017]: SR-23537
					//end kenneth  SR 19960 08112015
				}else if("GICLR209LE".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_PAID_DATE", request.getParameter("paidDate"));
				}else if("GICLR206X".equals(reportId)){
					//Modified by Pol Cruz
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_INTM_BREAK", request.getParameter("intmBreak"));
					params.put("P_PAID_DATE", request.getParameter("paidDate"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
				}else if("GICLR206LR".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					//marco - 03.11.2013
					//params.put("P_FROM_DATE", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : date.parse(request.getParameter("fromDate")));
					//params.put("P_TO_DATE", request.getParameter("toDate") == null || request.getParameter("toDate") == "" ? null : date.parse(request.getParameter("toDate")));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_AMT", request.getParameter("amt"));
				}else if("GICLR209LR".equals(reportId)){
					params.put("P_PAID_DATE", request.getParameter("paidDate"));
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
				}else if("GICLR209AR".equals(reportId)){
					params.put("P_PAID_DATE", request.getParameter("paidDate"));
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
				}else if("GICLR206ER".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					//params.put("P_PAID_DATE", request.getParameter("paidDate"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
					params.put("P_AMT", request.getParameter("amt"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
				}else if("GICLR209ER".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_PAID_DATE", request.getParameter("paidDate"));
				}else if("GICLR206XR".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_AMT", request.getParameter("amt"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_PAID_DATE", Integer.parseInt(request.getParameter("paidDate")));
				}else if("GICLR203".equals(reportId)){
					params.put("P_DATE_SW", request.getParameter("dateSw"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_INTERMEDIARY_TAG", request.getParameter("intermediaryTag") == "" || request.getParameter("intermediaryTag") == null ? null : Integer.parseInt(request.getParameter("intermediaryTag")));
					params.put("P_INTM_NO", request.getParameter("intmNo") == "" || request.getParameter("intmNo") == null ? null : Integer.parseInt(request.getParameter("intmNo")));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_ISS_CD_TAG", request.getParameter("issCdTag") == "" || request.getParameter("issCdTag") == null ? null : Integer.parseInt(request.getParameter("issCdTag")));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_LINE_CD_TAG", request.getParameter("lineCdTag") == "" || request.getParameter("lineCdTag") == null ? null : Integer.parseInt(request.getParameter("lineCdTag")));
					params.put("P_PERIL_CD", request.getParameter("perilCd") == "" || request.getParameter("perilCd") == null ? null : Integer.parseInt(request.getParameter("perilCd")));
					params.put("P_BRANCH_CLM_POL", 1);
					params.put("functionName", "CSV_GICLR203"); // Dren 09.15.2015 SR 0020264 : Added CSV Report for GICLR203 - Start
					params.put("packageName", "giclr203_pkg");
					params.put("csvAction", "printGICLR203"); // Dren 09.15.2015 SR 0020264 : Added CSV Report for GICLR203 - End
				}else if("GICLR203A".equals(reportId)){
					params.put("P_SESSION_ID", request.getParameter("sessionId"));
					params.put("P_DATE_SW", request.getParameter("dateSw"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_INTERMEDIARY_TAG", request.getParameter("intermediaryTag"));
					params.put("P_INTM_NO", request.getParameter("intmNo") == "" || request.getParameter("intmNo") == null ? null : Integer.parseInt(request.getParameter("intmNo")));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_ISS_CD_TAG", request.getParameter("issCdTag"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_LINE_CD_TAG", request.getParameter("lineCdTag"));
					params.put("P_PERIL_CD", request.getParameter("perilCd"));
					params.put("P_BRANCH_CLM_POL", "1");
					params.put("functionName", "CSV_GICLR203A"); // Dren 09.15.2015 SR 0020264 : Added CSV Report for GICLR203A - Start
					params.put("packageName", "giclr203a_pkg");
					params.put("csvAction", "printGICLR203A"); // Dren 09.15.2015 SR 0020264 : Added CSV Report for GICLR203A - End
				}
				
				System.out.println("GICLS202 Report Id: "+ reportId +" params: "+ params);
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports/bordereaux")+"/";
				params.put("SUBREPORT_DIR", reportDir);
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				//params.put("mediaSizeName", "US_STD_FANFOLD");
				System.out.println("GICLS202 complete params: "+ params);
				
				this.doPrintReport(request, response, params, reportDir);
				
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
