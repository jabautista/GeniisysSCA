package com.geniisys.giuts.controllers;

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

@WebServlet (name="GIUTSPrintReportController", urlPatterns={"/GIUTSPrintReportController"})
public class GIUTSPrintReportController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {	
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try {
			if("printReport".equals(ACTION)){
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportId = request.getParameter("reportId");
				String version  = reportsService.getReportVersion(reportId);
				version = version != "" ? "_" + version : version;
				String reportName = reportId + version;
				String userId = USER.getUserId();
				System.out.println("reportid : " + reportId);
				System.out.println("reportName : " + reportName);
				System.out.println("policyId : " + request.getParameter("policyId"));
				System.out.println("itemNo : " + request.getParameter("itemNo"));
				System.out.println("groupedItemNo: " + request.getParameter("groupedItemNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				String reportDir = null;
				
				if("GIPIR311".equals(reportId) || "GIPIR311_OTH".equals(reportId)) {
					params.put("P_POLICY_ID", Integer.parseInt(request.getParameter("policyId")));
					params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
					if("GIPIR311".equals(reportId)){
						Double loop = new Double(request.getParameter("groupedItemNo").length()/4000); 
						Double remainder = new Double(request.getParameter("groupedItemNo").length()%4000);
						int lastIteration = 0;
						
						for (int i=1; i <= loop; i++) {
							params.put("P_GROUPED_ITEM_NO"+i, request.getParameter("groupedItemNo").substring(((i-1)*4000), (i*4000)-1));
							lastIteration = i;
						}
						
						if(remainder != 0){
							params.put("P_GROUPED_ITEM_NO"+(lastIteration+1), request.getParameter("groupedItemNo").substring((lastIteration * 4000), request.getParameter("groupedItemNo").length()));
						}
						params.put("OUTPUT_REPORT_FILENAME", reportName);
					}else if("GIPIR311_OTH".equals(reportId)){
				        Double loop = new Double(request.getParameter("groupedItemNo").length()/4000); //SR-5553 06.15.2016 - Start
						Double remainder = new Double(request.getParameter("groupedItemNo").length()%4000);
						int lastIteration = 0;
						
						for (int i=1; i <= loop; i++) {
							params.put("P_GROUPED_ITEM_NO"+i, request.getParameter("groupedItemNo").substring(((i-1)*4000), (i*4000)-1));
							lastIteration = i;
						}
						
						if(remainder != 0){
							params.put("P_GROUPED_ITEM_NO"+(lastIteration+1), request.getParameter("groupedItemNo").substring((lastIteration * 4000), request.getParameter("groupedItemNo").length()));
						} //SR-5553 06.15.2016 - End
						params.put("OUTPUT_REPORT_FILENAME", reportName + "-" + request.getParameter("groupedItemNo"));
					}
					
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
				} else if("GIPIR198".equals(reportId)){
					reportName = reportId;
					params.put("OUTPUT_REPORT_FILENAME", reportName);
					params.put("P_STARTING_DATE", request.getParameter("pStartingDate"));
					params.put("P_ENDING_DATE", request.getParameter("pEndingDate"));
					params.put("P_USER_ID", userId);
					params.put("packageName", "CSV_UW_INQUIRIES");	/* start - Alejandro Burgos SR-5327 */
					params.put("functionName", "get_gipir198");
					params.put("csvAction", "printGIPIR198CSV");	/* end - Alejandro Burgos SR-5327  */						
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/underwriting/other/reports")+"/";
				} else if("GIPIR950".equals(reportId)){
					
					reportName = reportId;
					params.put("OUTPUT_REPORT_FILENAME", reportName);
					params.put("P_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_TO_DATE", request.getParameter("toDate"));
					params.put("P_DATE_BASIS", request.getParameter("basis"));
					params.put("P_USER_ID", USER.getUserId());
					params.put("packageName", "CSV_UW_INQUIRIES_GIPIR950");	//Badz 03.28.2016 SR-5335
					params.put("functionName", "csv_gipir950"); 			//Badz 03.28.2016 SR-5335    
					params.put("csvAction", "printGIPIR950CSV");       		//Badz 03.28.2016 SR-5335
										
					reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/underwriting/other/reports")+"/";
					
					System.out.println("PARAMS");
					System.out.println(params);
				}
				
				params.put("MAIN_REPORT", reportName+".jasper");				
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("mediaSizeName", "US_STD_FANFOLD");
									
				this.doPrintReport(request, response, params, reportDir);
				
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
