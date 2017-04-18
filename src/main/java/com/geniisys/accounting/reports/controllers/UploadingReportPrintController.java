//dren 06.10.2015
//Controller for modules GIACS605 and GIACS606 to call reports assigned for each module

package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;

@WebServlet (name="UploadingReportPrintController", urlPatterns={"/UploadingReportPrintController"})
public class UploadingReportPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3369212691219421164L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/uploading/reports")+"/";
				String reportName = reportId;
				
				Map<String, Object> params = new HashMap<String, Object>();
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				
				if("GIACR601".equals(reportId)){		
					params.put("P_FROM_DATE", df.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", df.parse(request.getParameter("toDate")));
					params.put("P_SOURCE_CD", request.getParameter("sourceCd"));					
					params.put("P_TRAN_TYPE", request.getParameter("transactionCd"));
					params.put("P_FILE_NAME", request.getParameter("fileName"));				
				} else if("GIACR601A".equals(reportId) || "GIACR601A_CSV".equals(reportId)){		
					params.put("P_AS_OF_DATE", df.parse(request.getParameter("asOfDate")));
					params.put("P_SOURCE_CD", request.getParameter("sourceCd"));					
					params.put("P_FILE_NAME", request.getParameter("fileName"));					
					params.put("packageName", "GIACR601A_CSV_PKG");	 		
					params.put("functionName", "GIACR601A"); 			     
					params.put("csvAction", "printGIACR601A"); 					
				} else if("GIACR602".equals(reportId)){		
					params.put("P_FROM_DATE", df.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", df.parse(request.getParameter("toDate")));
					params.put("P_SOURCE_CD", request.getParameter("sourceCd"));					
					params.put("P_TRAN_TYPE", request.getParameter("transactionCd"));
					params.put("P_FILE_NAME", request.getParameter("fileName"));						
				} else if("GIACR602A".equals(reportId) || "GIACR602A_CSV".equals(reportId)){		
					params.put("P_FROM_DATE", df.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", df.parse(request.getParameter("toDate")));
					params.put("P_SOURCE_CD", request.getParameter("sourceCd"));	
					params.put("packageName", "GIACR602A_CSV_PKG");	 		
					params.put("functionName", "GIACR602A"); 			     
					params.put("csvAction", "printGIACR602A"); 						
				} else if("GIACR606".equals(reportId) || "GIACR606_CSV".equals(reportId)){		
					params.put("P_SOURCE_CD", request.getParameter("sourceCd"));	
					params.put("P_TRAN_TYPE", request.getParameter("transactionCd"));
					params.put("P_FILE_NAME", request.getParameter("fileName"));
					params.put("P_PREM_CHECK_FLAG", request.getParameter("premCheckFlag"));
					params.put("P_TPREM_CHECK_FLAG", request.getParameter("tpremCheckFlag"));
					params.put("P_TCOMM_CHECK_FLAG", request.getParameter("tcommCheckFlag"));
				} else if("GIACR601_TRAN1_A_CSV".equals(reportId) || "GIACR601_TRAN1_B_CSV".equals(reportId) || "GIACR601_TRAN2_CSV".equals(reportId) ||
					      "GIACR601_TRAN3_CSV".equals(reportId) || "GIACR601_TRAN4_CSV".equals(reportId) || "GIACR601_TRAN5_CSV".equals(reportId)){		
					params.put("P_FROM_DATE", df.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", df.parse(request.getParameter("toDate")));
					params.put("P_SOURCE_CD", request.getParameter("sourceCd"));					
					params.put("P_FILE_NAME", request.getParameter("fileName"));
					params.put("packageName", "GIACR601_CSV_PKG");	 
					
					if("GIACR601_TRAN1_A_CSV".equals(reportId)) {		
						params.put("functionName", "GIACR601_TRAN1_A"); 			     
						params.put("csvAction", "printGIACR601Tran1A");  
					} else if ("GIACR601_TRAN1_B_CSV".equals(reportId)) {
						params.put("functionName", "GIACR601_TRAN1_B"); 			     
						params.put("csvAction", "printGIACR601Tran1B"); 
					} else if ("GIACR601_TRAN2_CSV".equals(reportId)) {
						params.put("functionName", "GIACR601_TRAN2"); 			     
						params.put("csvAction", "printGIACR601Tran2"); 
					} else if ("GIACR601_TRAN3_CSV".equals(reportId)) {
						params.put("functionName", "GIACR601_TRAN3"); 			     
						params.put("csvAction", "printGIACR601Tran3"); 
					} else if ("GIACR601_TRAN4_CSV".equals(reportId)) {
						params.put("functionName", "GIACR601_TRAN4"); 			     
						params.put("csvAction", "printGIACR601Tran4"); 
					} else if ("GIACR601_TRAN5_CSV".equals(reportId)) {
						params.put("functionName", "GIACR601_TRAN5"); 			     
						params.put("csvAction", "printGIACR601Tran5"); 
					} 
				} else if("GIACR602_TRAN1_A_CSV".equals(reportId) || "GIACR602_TRAN1_B_CSV".equals(reportId) || "GIACR602_TRAN2_CSV".equals(reportId) ||
					      "GIACR602_TRAN3_CSV".equals(reportId) || "GIACR602_TRAN4_CSV".equals(reportId) || "GIACR602_TRAN5_CSV".equals(reportId)){		
					params.put("P_FROM_DATE", df.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", df.parse(request.getParameter("toDate")));
					params.put("P_SOURCE_CD", request.getParameter("sourceCd"));					
					params.put("P_FILE_NAME", request.getParameter("fileName"));
					params.put("packageName", "GIACR602_CSV_PKG");	 
					
					if("GIACR602_TRAN1_A_CSV".equals(reportId)) {		
						params.put("functionName", "GIACR602_TRAN1_A"); 			     
						params.put("csvAction", "printGIACR602Tran1A");  
					} else if ("GIACR602_TRAN1_B_CSV".equals(reportId)) {
						params.put("functionName", "GIACR602_TRAN1_B"); 			     
						params.put("csvAction", "printGIACR602Tran1B"); 
					} else if ("GIACR602_TRAN2_CSV".equals(reportId)) {
						params.put("functionName", "GIACR602_TRAN2"); 			     
						params.put("csvAction", "printGIACR602Tran2"); 
					} else if ("GIACR602_TRAN3_CSV".equals(reportId)) {
						params.put("functionName", "GIACR602_TRAN3"); 			     
						params.put("csvAction", "printGIACR602Tran3"); 
					} else if ("GIACR602_TRAN4_CSV".equals(reportId)) {
						params.put("functionName", "GIACR602_TRAN4"); 			     
						params.put("csvAction", "printGIACR602Tran4"); 
					} else if ("GIACR602_TRAN5_CSV".equals(reportId)) {
						params.put("functionName", "GIACR602_TRAN5"); 			     
						params.put("csvAction", "printGIACR602Tran5"); 
					} 
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
