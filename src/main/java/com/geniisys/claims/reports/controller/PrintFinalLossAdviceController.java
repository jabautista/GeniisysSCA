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
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.underwriting.reinsurance.reports.controller.ReinsuranceAcceptanceController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="PrintFinalLossAdviceController", urlPatterns="/PrintFinalLossAdviceController")
public class PrintFinalLossAdviceController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(ReinsuranceAcceptanceController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			Map<String, Object> params = new HashMap<String, Object> ();
			String reportDir = null;
			
			if("printFlaXol".equals(ACTION)){
				String reportId = "GICLR033_XOL";
				String reportVersion = reportsService.getReportVersion("GICLR033_XOL");
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				String filename = "FLA-" + request.getParameter("lineCd") + "-" + request.getParameter("laYy") + "-" + request.getParameter("flaSeqNo");
				
				log.info("CREATING REPORT : "+reportName);
				
				params.put("P_CLAIM_ID", Integer.parseInt(request.getParameter("claimId")));
				params.put("P_GRP_SEQ_NO", Integer.parseInt(request.getParameter("grpSeqNo")));
				params.put("P_ADVICE_ID", Integer.parseInt(request.getParameter("adviceId")));
				params.put("P_FLA_ID", Integer.parseInt(request.getParameter("flaId")));
				params.put("P_RI_CD", "".equals(request.getParameter("riCd")) ? null :Integer.parseInt(request.getParameter("riCd"))); //added by Nica 04.05.2013
				params.put("P_FLA_TITLE", request.getParameter("flaTitle"));
				params.put("P_FLA_HEADER", request.getParameter("flaHeader"));
				params.put("P_FLA_FOOTER", request.getParameter("flaFooter"));
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
				Debug.print("Print FLA XOL Params: "+params);
				
			}else if("printFla".equals(ACTION)){
				String reportId = "GICLR033";
				String reportVersion = reportsService.getReportVersion("GICLR033");
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				String filename = "FLA-" + request.getParameter("lineCd") + "-" + request.getParameter("laYy") + "-" + request.getParameter("flaSeqNo");
				
				log.info("CREATING REPORT : "+reportName);
				
				params.put("P_CLAIM_ID", Integer.parseInt(request.getParameter("claimId")));
				params.put("P_RI_CD", Integer.parseInt(request.getParameter("riCd")));
				//params.put("P_FLA_ID", Integer.parseInt(request.getParameter("flaId")));
				params.put("P_FLA_TITLE", request.getParameter("flaTitle"));
				params.put("P_FLA_HEADER", request.getParameter("flaHeader"));
				params.put("P_FLA_FOOTER", request.getParameter("flaFooter"));
				params.put("P_ADVICE_ID",Integer.parseInt(request.getParameter("adviceId"))); 
				params.put("P_GRP_SEQ_NO",Integer.parseInt(request.getParameter("grpSeqNo"))); 
				params.put("P_SHARE_TYPE",Integer.parseInt(request.getParameter("shareType")));
				params.put("P_ADV_FLA_ID",Integer.parseInt(request.getParameter("advFlaId")));
				params.put("P_WITH_RECOVERY", request.getParameter("withRecovery"));
				params.put("P_LINE_CD",request.getParameter("lineCd")); 
				params.put("P_LA_YY",request.getParameter("laYy")); 
				params.put("P_FLA_SEQ_NO",Integer.parseInt(request.getParameter("flaSeqNo")));
				params.put("P_FLA_ID", "".equals(request.getParameter("flaId")) ? null :Integer.parseInt(request.getParameter("flaId")));				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
				Debug.print("Print FLA Params: "+params);
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
