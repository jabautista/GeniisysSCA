/**
 * 
 */
package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;

/**
 * @author steven
 *
 */
@WebServlet (name="PrintBatchOsDetail", urlPatterns={"/PrintBatchOsDetail"})
public class PrintBatchOsDetail extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6588131715794916874L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			if ("printReport".equals(ACTION)) {
				String reportId = request.getParameter("reportId");
				String fileName = reportId;	
				Map<String, Object> params = new HashMap<String, Object>();
				
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				Date tranDate =df.parse(request.getParameter("tranDate"));
				Calendar cal = Calendar.getInstance();
				cal.setTime(tranDate);
				
				if ("GICLR207".equals(reportId)) {
					fileName = request.getParameter("tranId").equals("") ? fileName : fileName+"_"+request.getParameter("tranId");
					//params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("tranId"))); //replaced by codes below robert SR 4954 09.15.15
					params.put("P_TRAN_ID", request.getParameter("tranId")); //to adapt the changes in report for multiple pages printing in one window
					params.put("P_MONTH", cal.get(Calendar.MONTH)+1);
					params.put("P_YEAR", cal.get(Calendar.YEAR));
					params.put("packageName", "CSV_BATCHOS_ENTRIES_GICLR207"); // added by carlo rubenecia 04/26/2016  SR-5418	
					params.put("functionName", "csv_giclr207");    // added by carlo rubenecia 04/26/2016  SR-5418	
					params.put("csvAction", "printGICLR207CSV");   // added by carlo rubenecia 04/26/2016 SR-5418		
				}else if ("GICLR207R".equals(reportId)) {
					fileName = request.getParameter("tranId").equals("") ? fileName : fileName+"_"+request.getParameter("tranId");
					params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
					params.put("P_MONTH", cal.get(Calendar.MONTH)+1);
					params.put("P_YEAR", cal.get(Calendar.YEAR));
					params.put("packageName", "CSV_BATCHOS_ENTRIES_GICLR207R"); // added by carlo rubenecia 04/25/2016  SR 5419	
					params.put("functionName", "csv_giclr207r");    // added by carlo rubenecia 04/25/2016  SR 5419	
					params.put("csvAction", "printGICLR207RCSV");   // added by carlo rubenecia 04/25/2016 SR 5419		
				}else if ("GICLR207C".equals(reportId)) {
					fileName = request.getParameter("tranId").equals("") ? fileName : fileName+"_"+request.getParameter("tranId");
					params.put("P_TRAN_CLASS", request.getParameter("tranClass"));
					params.put("P_TRAN_DATE", request.getParameter("tranDate"));
					params.put("P_MONTH", cal.get(Calendar.MONTH)+1);
					params.put("P_YEAR", cal.get(Calendar.YEAR));
					params.put("packageName", "CSV_BATCHOS_ENTRIES_GICLR207C"); // added by carlo rubenecia 04/25/2016  SR 5420	
					params.put("functionName", "csv_giclr207c");    // added by carlo rubenecia 04/25/2016  SR 5420	
					params.put("csvAction", "printGICLR207CCSV");   // added by carlo rubenecia 04/25/2016 SR 5420		
				}else if ("GICLR207D".equals(reportId)) {
					fileName = request.getParameter("tranId").equals("") ? fileName : fileName+"_"+request.getParameter("tranId");
					params.put("P_TRAN_DATE", request.getParameter("tranDate"));
					params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
				}else if ("GICLR207L".equals(reportId)) {
					fileName = request.getParameter("tranId").equals("") ? fileName : fileName+"_"+request.getParameter("tranId");
					params.put("P_TRAN_DATE", request.getParameter("tranDate"));
					params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
				}
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports")+"/";
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
