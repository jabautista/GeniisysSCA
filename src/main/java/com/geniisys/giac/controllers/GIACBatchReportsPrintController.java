package com.geniisys.giac.controllers;

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

import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACBatchReportsPrintController", urlPatterns={"/GIACBatchReportsPrintController"})
public class GIACBatchReportsPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try{
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/production/reports")+"/";
				String fileName = reportId;
				Map<String, Object> params = new HashMap<String, Object>();
				
				GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				
				String version = giisReportsService.getReportVersion(reportId);
				String reportIdVersion = reportId + (version != null ? "_" + version : "");
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				if("GIACR226".equals(reportId)){
					params.put("P_V_ISS_CD", request.getParameter("issCd"));
					params.put("P_DATE", request.getParameter("date"));
				}else if("GIACR227".equals(reportId)){
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_ACCT_ENT_MONTH", (request.getParameter("month") != null && !request.getParameter("month").isEmpty() ? Integer.parseInt(request.getParameter("month")) : null));
					params.put("P_ACCT_ENT_YEAR", (request.getParameter("year") != null && !request.getParameter("year").isEmpty() ? Integer.parseInt(request.getParameter("year")) : null));
					subreportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/endofmonth/reports")+"/";
				}else if("GIACB003S".equals(reportId) || "GIACB003D".equals(reportId)){
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_DATE", request.getParameter("date"));
					subreportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/endofmonth/reports")+"/";
				}else if("GIACB004S".equals(reportId) || "GIACB004D".equals(reportId)){
					params.put("P_DATE", "GIACB004S".equals(reportId) ? df.parse(request.getParameter("date")) : request.getParameter("date"));
					subreportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/reinsurance/reports")+"/";
				}else if("GIACR225".equals(reportId)){
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_DATE", request.getParameter("date"));
					params.put("packageName", "CSV_AC_EOM_REPORTS"); // added by carlo de guzman 3.07.2016
					params.put("functionName", "csv_giacr225");      // added by carlo de guzman 3.07.2016
					params.put("csvAction", "printGIACR225CSV");     // added by carlo de guzman 3.07.2016					
					fileName = request.getParameter("branchCd").equals("") ? fileName : fileName+"_"+request.getParameter("branchCd");
					subreportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/production/reports")+"/";
				}
				
				
				
				params.put("OUTPUT_REPORT_FILENAME", fileName);
				params.put("MAIN_REPORT", reportIdVersion +".jasper");
				params.put("reportName", reportIdVersion);				
				params.put("mediaSizeName", "US_STD_FANFOLD");
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}
}
