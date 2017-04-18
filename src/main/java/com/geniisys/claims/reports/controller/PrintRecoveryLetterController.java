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

import com.geniisys.claims.reports.util.ClaimReportsPropertiesUtil;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="PrintRecoveryLetterController", urlPatterns="/PrintRecoveryLetterController")
public class PrintRecoveryLetterController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 652946816600360438L;	
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());		
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		Logger log = Logger.getLogger(PrintPreliminaryLossAdviceController.class);
		message = "SUCCESS";
		
		try{				
			Map<String, Object> params = new HashMap<String, Object> ();
			String reportDir = null;
			
			if("printRecoveryLetter".equals(ACTION)){				
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = StringUtils.isEmpty(reportVersion) ? reportId+"_CPI" : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				String filename = reportId + "-" + request.getParameter("claimNo");
				
				log.info("CREATING REPORT : "+reportName);
				
				params.put("P_CLAIM_ID", "".equals(request.getParameter("claimId")) ? null :Integer.parseInt(request.getParameter("claimId")));
				params.put("P_RECOVERY_ID", "".equals(request.getParameter("recoveryId")) ? null :Integer.parseInt(request.getParameter("recoveryId")));
				params.put("P_PAYOR_CD", "".equals(request.getParameter("payorCd")) ? null :Integer.parseInt(request.getParameter("payorCd")));
				params.put("P_PAYOR_CLASS_CD", request.getParameter("payorClassCd"));
				params.put("P_DEMAND_LETTER_DATE", request.getParameter("DemandLetterDate"));
				params.put("P_DEMAND_LETTER_DATE2", request.getParameter("DemandLetterDate2"));
				params.put("P_DEMAND_LETTER_DATE3", request.getParameter("DemandLetterDate3"));
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
				
				if(reportId.equals("GICLR025_D")){
					params.put("P_DATE", request.getParameter("DeedOfSaleDate"));
					params.put("P_PLACE", request.getParameter("DeedOfSalePlace"));
				}
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
