
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

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="PrintCatastrophicEventReportController", urlPatterns={"/PrintCatastrophicEventReportController"})
public class PrintCatastrophicEventReportController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(PrintCatastrophicEventReportController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		message = "SUCCESS";
		
		try {
			Map<String, Object> params = new HashMap<String, Object> ();
			String reportDir = null;
			
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportFont = reportParam.getDefaultReportFont();
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = StringUtils.isEmpty(reportVersion) ? reportId : reportId+"_"+reportVersion;
				reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports")+"/";
				
				log.info("CREATING REPORT : "+reportName);
				
				if("GICLR200B".equals(reportId)){
					params.put("P_SESSION_ID", "".equals(request.getParameter("sessionId")) ? null :Integer.parseInt(request.getParameter("sessionId")));
					params.put("P_AS_OF_DT", request.getParameter("asOfDate"));
					params.put("P_RI_CD", "".equals(request.getParameter("riCd")) ? null :Integer.parseInt(request.getParameter("riCd")));	
					params.put("csvAction", "printGICLR200BCSV");
					params.put("packageName", "CSV_GICLR200B_PKG");
					params.put("functionName", "get_report_details");
				} else if("GICLR200".equals(reportId)){
					params.put("P_SESSION_ID", "".equals(request.getParameter("sessionId")) ? null :Integer.parseInt(request.getParameter("sessionId")));
					params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
				} else if("GICLR056".equals(reportId)){
					params.put("P_CAT_CD", request.getParameter("catCd"));
					params.put("P_USER_ID", USER.getUserId());
				}

				params.put("P_FONT_SW", reportFont);
				params.put("P_USER_NAME", USER.getUsername());
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				log.info(reportId+" parameters : "+params);
			}	
			
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
