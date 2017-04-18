package com.geniisys.giac.controllers;

import java.io.IOException;
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
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACS052PrintController", urlPatterns={"/GIACS052PrintController"})
public class GIACS052PrintController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6636295047238738596L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try{
			if("printGIACS052Report".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String fileName = request.getParameter("reportTitle");
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				String subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("OUTPUT_REPORT_FILENAME", (fileName != null ? fileName.replaceAll(" ", "_") : reportId));
				
				GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				
				String version = giisReportsService.getReportVersion(reportId);
				String reportIdVersion = reportId + (version != null ? "_" + version : "");
				params.put("P_GACC_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
				params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
				params.put("P_ITEM_NO", (request.getParameter("itemNo") != null && !request.getParameter("itemNo").isEmpty() ? Integer.parseInt(request.getParameter("itemNo")) : null));
				params.put("P_CHECK_DATE", (request.getParameter("checkDate") != null && !request.getParameter("checkDate").isEmpty() ? sdf.parse(request.getParameter("checkDate")) : null));
				params.put("P_CHK_PREFIX", request.getParameter("checkPref"));
				params.put("P_CHECK_NO", request.getParameter("checkNo"));
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_DOCUMENT_CD", request.getParameter("documentCd"));
				params.put("P_REPORT_ID", reportId);
				params.put("MAIN_REPORT", reportIdVersion +".jasper");
				params.put("reportName", reportIdVersion);				
					
				this.doPrintReport(request, response, params, subreportDir);
				
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
