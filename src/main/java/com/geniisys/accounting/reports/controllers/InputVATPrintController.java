package com.geniisys.accounting.reports.controllers;

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
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="InputVATPrintController", urlPatterns="/InputVATPrintController")
public class InputVATPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3583292231527961030L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_MODULE_ID", "GIACS104");
				params.put("P_BRANCH_CD", request.getParameter("branchCd"));
				params.put("P_FROM_DATE", request.getParameter("fromDate"));
				params.put("P_TO_DATE", request.getParameter("toDate"));
				params.put("P_TRAN_POST", request.getParameter("tranPost"));
				params.put("P_INCLUDE", request.getParameter("include"));
				params.put("P_USER_ID", USER.getUserId());
				
				if("GIACR104".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_INCLUDE", request.getParameter("include"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_TRAN_POST", request.getParameter("tranPost"));
					params.put("csvAction", "printGIACR104");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_INPUT_VAT1");
				} else if("GIACR214".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_TRAN_POST", request.getParameter("tranPost"));
					params.put("csvAction", "printGIACR214");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_INPUT_VAT2");
				} else if("GIACR214B".equals(reportId)){
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/generalledger/reports")+"/";
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_TRAN_POST", request.getParameter("tranPost"));
					params.put("csvAction", "printGIACR214B");
					params.put("packageName", "CSV_VAT");
					params.put("functionName", "CSV_INPUT_VAT3");
				}
				
				reportName = reportId;
				System.out.println(params);
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				
				this.doPrintReport(request, response, params, reportDir);
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
