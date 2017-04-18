package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
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

@WebServlet (name="PrintGIACInquiryController", urlPatterns={"/PrintGIACInquiryController"})
public class PrintGIACInquiryController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5106235824838416741L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {	
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try {
			if("printReport".equals(ACTION)){
				String reportId = request.getParameter("reportId");	
				String reportVersion = reportsService.getReportVersion(reportId);	//added by Gzelle 08122014
				Map<String, Object> params = new HashMap<String, Object>();
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/inquiry/reports")+"/";
				
				if("GIACR235".equals(reportId)){
					params.put("P_OR_FLAG", request.getParameter("orFlag"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_FROM_DATE", df.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", df.parse(request.getParameter("toDate")));
					params.put("P_TRAN_FLAG", request.getParameter("tranFlag"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("mediaSizeName", "US_STD_FANFOLD");
				}else if("GIACR235A".equals(reportId)){
					params.put("P_FROM_DATE", df.parse(request.getParameter("fromDate")));
					params.put("P_TO_DATE", df.parse(request.getParameter("toDate")));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_USER_ID", USER.getUserId());
				}else if ("GIACR211".equals(reportId)) {		//added by gzelle 03.12.2013
					params.put("P_TRAN_CLASS", request.getParameter("tranClass"));
					params.put("P_TRAN_FLAG", request.getParameter("tranFlag"));
					params.put("P_BRANCH_CD", request.getParameter("branchCd"));
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_USER_ID", USER.getUserId());
				}else if("GIACR050".equals(reportId)){
					params.put("P_OR_PREF", request.getParameter("orPref"));
					params.put("P_OR_NO", Integer.parseInt(request.getParameter("orNo")));
					params.put("P_TRAN_ID", Integer.parseInt(request.getParameter("tranId")));
					
//					ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
					reportId = reportVersion == "" ? reportId : reportId+"_"+reportVersion;	//added by Gzelle 08122014
				}
				
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportId);
				
				this.doPrintReport(request, response, params, reportDir);
			}
		} catch (SQLException e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
