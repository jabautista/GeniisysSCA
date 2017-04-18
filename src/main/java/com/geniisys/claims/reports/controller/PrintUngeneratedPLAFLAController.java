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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;

@WebServlet(name="PrintUngeneratedPLAFLAController", urlPatterns={"/PrintUngeneratedPLAFLAController"})
public class PrintUngeneratedPLAFLAController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(PrintUngeneratedPLAFLAController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			if("printReport".equals(ACTION)){
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports")+"/";
				String reportLocation = "/com/geniisys/claims/reports/";
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportLocation+"/")+"/";
				String reportId = request.getParameter("reportId");
				Map<String, Object> params = new HashMap<String, Object>();
				
				if("GICLR050B".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER", (request.getParameter("userId") != null && !request.getParameter("userId").equals("")) ? request.getParameter("userId") : null);
				} else if("GICLR051B".equals(reportId)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_USER", (request.getParameter("userId") != null && !request.getParameter("userId").equals("")) ? request.getParameter("userId") : null);
				}							
				
				log.info("CREATING REPORT : "+reportId);
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				//params.put("SUBREPORT_DIR", subreportDir);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				params.put("mediaSizeName", "US_STD_FANFOLD");
				System.out.println("params to jasper: "+ params);
				
				this.doPrintReport(request, response, params, reportDir);
			}
		} catch (JRException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (SQLException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}
}
