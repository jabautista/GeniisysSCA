/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.controllers
	File Name: GICLMcEvaluationPrintController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 20, 2012
	Description: 
*/


package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;
@WebServlet (name="GICLMcEvaluationPrintController", urlPatterns={"/GICLMcEvaluationPrintController"})
public class GICLMcEvaluationPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7722661999334289979L;
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try{
			if ("printEvaluationSheet".equals(ACTION)) {
				Integer evalId = Integer.parseInt(request.getParameter("evalId"));
				String claimNo = request.getParameter("claimNo");
				String updateSw = request.getParameter("updateSw");
				
				String reportId = request.getParameter("reportId");
				String fileName = request.getParameter("reportTitle").replaceAll(" ", "_");
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports")+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", fileName);
				params.put("reportName", reportId);
				
				params.put("P_CLAIM_NO", claimNo);
				params.put("P_EVAL_ID", evalId);
				params.put("P_UPDATE_SW", updateSw);
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}else if("printCSL".equals(ACTION)){
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportId = request.getParameter("reportId");
				String fileName = request.getParameter("reportTitle").replaceAll(" ", "_");
				
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				String subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				String reportVersion = reportsService.getReportVersion(reportId);
				
				reportId += "_"+reportVersion;
				System.out.println("REPORT ID AND VERSION: "+reportId);
				
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("P_CLAIM_ID", Integer.parseInt(request.getParameter("claimId")));
				params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd"));
				params.put("P_PAYEE_CD", Integer.parseInt(request.getParameter("payeeCd")));
				params.put("P_TP_CLASS_CD", request.getParameter("tpClassCd"));  //koks
				params.put("P_TP_PAYEE_CD", request.getParameter("tpPayeeCd").equals("") ? null : Integer.parseInt(request.getParameter("tpPayeeCd"))); //koks
				params.put("P_EVAL_ID", request.getParameter("evalId").equals("") ? null : Integer.parseInt(request.getParameter("evalId")));
				params.put("P_ISS_CD", request.getParameter("clmIssCd"));
				params.put("P_LINE_CD", request.getParameter("clmLineCd"));
				params.put("P_CLASS_DESC", request.getParameter("classDesc"));
				params.put("P_CLM_LOSS_ID", request.getParameter("clmLossId").equals("") ? null : Integer.parseInt(request.getParameter("clmLossId")));
				params.put("P_PERIL_CD", request.getParameter("perilCd").equals("") ? null : Integer.parseInt(request.getParameter("perilCd")));
				params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
				params.put("P_REMARKS", request.getParameter("remarks"));  //added by steven 8.2.2012
				//params.put("P_FROM_MC_EVAL", request.getParameter("fromMcEval"));
				//params.put("P_PAYEE_NO", Integer.parseInt(request.getParameter("payeeNo")));
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("P_CSL_NO", request.getParameter("cslNo"));
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", fileName);
				params.put("reportName", reportId);
				
				System.out.println("PARAMETERS ::::::::::::::::::::"+params);
				this.doPrintReport(request, response, params, subreportDir);
				
			}else if ("printLOA".equals(ACTION)) {
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportId = request.getParameter("reportId");
				String fileName = request.getParameter("reportTitle").replaceAll(" ", "_");
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				String subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				String reportVersion = reportsService.getReportVersion(reportId);
				reportId += "_"+reportVersion;
				System.out.println("REPORT ID AND VERSION: "+reportId);
				
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("P_CLAIM_ID", Integer.parseInt(request.getParameter("claimId")));
				params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd"));
				params.put("P_PAYEE_CD", Integer.parseInt(request.getParameter("payeeCd")));
				params.put("P_MAIN_PAYEE_CLASS_CD", request.getParameter("mainPayeeClassCd"));
				params.put("P_MAIN_PAYEE_NO", request.getParameter("mainPayeeNo").equals("") ? null : Integer.parseInt(request.getParameter("mainPayeeNo")));
				params.put("P_EVAL_ID", request.getParameter("evalId").equals("") ? null : Integer.parseInt(request.getParameter("evalId")));
				params.put("P_ISS_CD", request.getParameter("clmIssCd"));
				params.put("P_LINE_CD", request.getParameter("clmLineCd"));
				params.put("P_LOA_NO", request.getParameter("loaNo"));
				params.put("P_TP_SW", request.getParameter("tpSw"));
				params.put("P_CLM_LOSS_ID", request.getParameter("clmLossId").equals("") ? null : Integer.parseInt(request.getParameter("clmLossId")));
				params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("P_TP_CLASS_CD", request.getParameter("tpClassCd"));  //koks
				params.put("P_TP_PAYEE_CD", request.getParameter("tpPayeeCd").equals("") ? null : Integer.parseInt(request.getParameter("tpPayeeCd"))); //koks
				params.put("P_REMARKS", request.getParameter("remarks")); //pass value of Remarks in LOA by MAC 04/08/2013.
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", fileName);
				params.put("reportName", reportId);
				System.out.println(params);				
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}	
	}

}
