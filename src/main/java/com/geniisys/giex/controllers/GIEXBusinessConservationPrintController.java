package com.geniisys.giex.controllers;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date; //Added by Jerome Bautista SR 3399 07.03.2015
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.underwriting.reinsurance.reports.controller.ReinsuranceAcceptanceController;

public class GIEXBusinessConservationPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@SuppressWarnings("unused")
	private Logger log = Logger.getLogger(ReinsuranceAcceptanceController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			if("printBusinessConservationReport".equals(ACTION)){
				String reportName = request.getParameter("report");
				String fileName = request.getParameter("filename");
				String reportsLocation = "/com/geniisys/underwriting/expiry/reports/";
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportsLocation+"/")+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", fileName);
				params.put("reportName", reportName);
				params.put("P_ISS_CD", request.getParameter("issCd"));
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_USER_ID", USER.getUserId()); //marco - 10.20.2014
				params.put("mediaSizeName", "US_STD_FANFOLD");
				
				if("GIEXR109_MAIN".equals(reportName) || "GIEXR109_MAIN_CSV".equals(reportName)){
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
				}else if("GIEXR108".equals(reportName)){ //Added by Jerome Bautista SR 3399 07.03.2015
					Date fromDate, toDate;
					DateFormat format;
					format = new SimpleDateFormat("MM-dd-yyyy");
					fromDate = format.parse(request.getParameter("fromDate"));
					toDate = format.parse(request.getParameter("toDate"));
					Integer intmNo = request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo"));
					
					params.put("P_DATE_FROM", fromDate);
					params.put("P_DATE_TO", toDate);
					params.put("P_CRED_CD", request.getParameter("credCd"));
					params.put("P_INTM_NO", intmNo);
					params.put("packageName", "CSV_UW_RENEWAL"); /* start: added by Kevin 4-6-2016 SR-5491 */
					params.put("csvAction", "printGIEXR108");
					params.put("functionName", "get_giexr108"); /* end: added by Kevin 4-6-2016 SR-5491 */					
				}else if("GIEXR110_MAIN".equals(reportName) || "GIEXR110_MAIN_CSV".equals(reportName)){ //Dren Niebres SR-5493 05.30.2016
					params.put("P_DATE_FROM", request.getParameter("fromDate"));
					params.put("P_DATE_TO", request.getParameter("toDate"));
				}else if("GIEXR111_MAIN".equals(reportName) || "GIEXR111_MAIN_CSV".equals(reportName)){
					params.put("P_DATE_FROM", null);
					params.put("P_DATE_TO", null);
				}else if("GIEXR112_MAIN".equals(reportName)){	
					DateFormat date;
					Integer policyId = request.getParameter("policyId") == "" ? null : Integer.parseInt(request.getParameter("policyId"));
					Integer assdNo = request.getParameter("assdNo") == "" ? null : Integer.parseInt(request.getParameter("assdNo"));
					Integer intmNo = request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo"));
					
					if(request.getParameter("origin").equals("M")){
						date = new SimpleDateFormat("dd-MMM-yyyy");
					}else{
						date = new SimpleDateFormat("MM-dd-yyyy");
					}
					params.put("P_STARTING_DATE", date.parse(request.getParameter("fromDate")));
					params.put("P_ENDING_DATE", date.parse(request.getParameter("toDate")));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
					params.put("P_POLICY_ID", policyId);
					params.put("P_ASSD_NO", assdNo);
					params.put("P_INTM_NO", intmNo);
					//START csv printing SR5499 hdrtagudin 04072016
					params.put("csvAction", "printGIEXR112CSV");
					params.put("packageName", "CSV_UW_RENEWAL"); 
					params.put("functionName", "CSV_GIEXR112");
					//END csv printing SR5499 hdrtagudin 04072016					
				}
				Debug.print("Business Conservation Report Params: "+params);
				
				this.doPrintReport(request, response, params, subreportDir);
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}
}