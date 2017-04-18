package com.geniisys.common.report;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.report.util.CommonReportsPropertiesUtil;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="PrintLineController", urlPatterns="/PrintLineController")
public class PrintLineController extends BaseController{

	private Logger log = Logger.getLogger(PrintLineController.class);
	private static final long serialVersionUID = 1L;
	private static PrintingUtil printingUtil = new PrintingUtil();

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {


		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
		DataSourceTransactionManager client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		message = "SUCCESS";
		
		try {
			if("printLineReport".equals(ACTION)){
				String reportId = "GIISS001";
				String reportFont = reportParam.getDefaultReportFont();
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = StringUtils.isEmpty(reportVersion) ? reportId : reportId+"_"+reportVersion;
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/"+CommonReportsPropertiesUtil.commonReports)+"/";
				String filename = request.getParameter("lineCd");
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}

}
