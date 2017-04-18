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
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="PrintAdjusterController", urlPatterns="/PrintAdjusterController")
public class PrintAdjusterController extends BaseController{

	private Logger log = Logger.getLogger(PrintPreliminaryLossAdviceController.class);
	private static final long serialVersionUID = 1L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		message = "SUCCESS";
		
		try{
			Map<String, Object> params = new HashMap<String, Object> ();
			String reportDir = null;
			
			if("populateGiclr060".equals(ACTION)){
				String reportId = "GICLR060";
				String reportFont = reportParam.getDefaultReportFont();
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = StringUtils.isEmpty(reportVersion) ? reportId+"_UCPB" : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				String filename = "ADJ-" + request.getParameter("claimNo")+"-"+ request.getParameter("payeeNo")+"-"+request.getParameter("privAdjCd");
				
				log.info("CREATING REPORT : "+reportName);
				
				params.put("P_PAYEE_NO", "".equals(request.getParameter("payeeNo")) ? null :Integer.parseInt(request.getParameter("payeeNo")));
				params.put("P_POLICY_ID", "".equals(request.getParameter("policyId")) ? null :Integer.parseInt(request.getParameter("policyId")));
				params.put("P_CLAIM_ID", "".equals(request.getParameter("claimId")) ? null :Integer.parseInt(request.getParameter("claimId")));
				params.put("P_CLM_ADJ_ID", "".equals(request.getParameter("clmAdjId")) ? null :Integer.parseInt(request.getParameter("clmAdjId")));
				
				params.put("P_FONT_SW", reportFont);
				params.put("P_USER_NAME", USER.getUsername());
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
				log.info("GICLR060 parmeters : "+params);
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
