package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.sql.SQLException;
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
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="PrintClaimsRecoveryRegisterController", urlPatterns="/PrintClaimsRecoveryRegisterController")
public class PrintClaimsRecoveryRegisterController extends BaseController{
	
	/**
	 * 
	 */
	private Logger log = Logger.getLogger(PrintClaimsRecoveryRegisterController.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			String reportId = request.getParameter("reportId");
			String reportVersion = reportsService.getReportVersion(reportId);
			String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/inquiry/listing/reports")+"/";
			String reportName = reportVersion == "" || reportVersion == null ? reportId : reportId+"_"+reportVersion;
			
			if ("printCLRecRegReports".equals(ACTION)){
				if("GICLR201".equals(reportId)){	// Claim Recovery Register
					params.put("P_DATE_SW", request.getParameter("dateSw"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_REC_TYPE_CD", request.getParameter("recTypeCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("csvAction", "printGICLR201CSV");
					params.put("packageName", "CSV_RECOVERY_REGISTER");
					params.put("functionName", "CSV_GICLR201");
					
				}else if("GICLR201A".equals(reportId)){		// Schedule of Salvage Recoveries
					params.put("P_DATE_SW", request.getParameter("dateSw"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_REC_TYPE_CD", request.getParameter("recTypeCd"));
					params.put("P_USER_ID", USER.getUserId());
					
				}else if("GICLR202".equals(reportId)){ 	// Outstanding Claim Recoveries as of
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_REC_TYPE_CD", request.getParameter("recTypeCd"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("csvAction", "printGICLR202CSV");
					params.put("packageName", "CSV_OS_RECOVERY_GICLR201");// changed to CSV_OS_RECOVERY_GICLR201 by herbert
					params.put("functionName", "CSV_GICLR202");
				}
				
				System.out.println(reportId + " PARAMS: " + params.toString());
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				
				this.doPrintReport(request, response, params, reportDir);
			}
			
		}catch(SQLException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}

