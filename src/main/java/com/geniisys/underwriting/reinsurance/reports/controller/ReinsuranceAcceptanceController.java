package com.geniisys.underwriting.reinsurance.reports.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.giri.service.GIRIBinderService;
import com.geniisys.policydocs.reports.util.PolicyReportsPropertiesUtil;
import com.geniisys.underwriting.reinsurance.reports.util.RiAcceptanceUtil;
import com.seer.framework.util.ApplicationContextReader;

public class ReinsuranceAcceptanceController extends BaseController{

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
		GIRIBinderService giriBinderService = (GIRIBinderService) APPLICATION_CONTEXT.getBean("giriBinderService");
		GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			if ("doPrintFrps".equals(ACTION)) {
				log.info("printing facultative reinsurance binder...");
				
				String lineCd = request.getParameter("lineCd");
				Integer binderYy = Integer.parseInt(request.getParameter("binderYy"));
				Integer binderSeqNo = Integer.parseInt(request.getParameter("binderSeqNo"));
				Integer fnlBinderId = Integer.parseInt(request.getParameter("fnlBinderId"));
				String reportName = "GIRIR001_MAIN";
				String printerName = request.getParameter("printerName");
				String subreportDir = "";
				subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+RiAcceptanceUtil.riReportsLocation)+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_LINE_CD", lineCd);
				params.put("P_BINDER_YY", binderYy);
				params.put("P_BINDER_SEQ_NO", binderSeqNo);
				params.put("P_FNL_BINDER_ID", fnlBinderId);
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName+"_"+lineCd+"-"+binderYy+"-"+binderSeqNo);
				params.put("reportName", reportName);
				
				Debug.print("GIRIR001_MAIN Report Params: "+ params);
				
				this.doPrintReport(request, response, params, subreportDir);
								
				if(printerName!=null){
					giriBinderService.updateBinderPrintDateCnt(fnlBinderId);
				}
			}else if("doRiAgreementBond".equals(ACTION)){
				log.info("Printing RI Agreement Bond...");
				
				Integer fnlBinderId = Integer.parseInt(request.getParameter("fnlBinderId"));
				String reportName = "GIRIR121";
				String version = giisReportsService.getReportVersion(reportName);
				String reportId = reportName + "_" + version;
				String subreportDir = "";
				//subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+RiAcceptanceUtil.riReportsLocation)+"/"; replaced by robert SR 20437 09.24.15
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService"); //added by robert SR 20437 09.24.15
				subreportDir = (version == null || version.equals("") ? getServletContext().getRealPath("WEB-INF/classes/"+ RiAcceptanceUtil.riReportsLocation)+ "/"
						: giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW")); //added by robert SR 20437 09.24.15
				
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("P_FINAL_BINDER_ID", fnlBinderId);
				params.put("P_RI_SIGNATORY", request.getParameter("riAgrmntBndName"));
				params.put("P_RI_SIG_DESIGNATION", request.getParameter("riAgrmntBndDesignation"));
				params.put("P_ATTEST", request.getParameter("riAgrmntBndAttest"));
				
				System.out.println("P_FINAL_BINDER_ID "+ fnlBinderId);
				System.out.println("P_RI_SIGNATORY "+ request.getParameter("riAgrmntBndName"));
				System.out.println("P_RI_SIG_DESIGNATION "+ request.getParameter("riAgrmntBndDesignation"));
				System.out.println("P_ATTEST "+ request.getParameter("riAgrmntBndAttest"));
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId+"_"+fnlBinderId);
				params.put("reportName", reportId);
				
				Debug.print("GIRIR121_PCIC Report Params: " + params);
				
				this.doPrintReport(request, response, params, subreportDir);
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
