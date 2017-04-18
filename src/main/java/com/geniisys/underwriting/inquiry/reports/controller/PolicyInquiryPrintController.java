package com.geniisys.underwriting.inquiry.reports.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="PolicyInquiryPrintController", urlPatterns={"/PolicyInquiryPrintController"})
public class PolicyInquiryPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		DataSourceTransactionManager client = null;
		client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try {
			String reportId = request.getParameter("reportId");
			String reportVersion = reportsService.getReportVersion(reportId);
			String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/underwriting/inquiry/reports")+"/";
			String reportName = reportVersion == null ? reportId : reportId+"_"+reportVersion;
			Map<String, Object> params = new HashMap<String, Object>();
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			
			if("printGIPIR206".equals(ACTION)){
				params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
				params.put("P_FROM_DATE", request.getParameter("fromDate"));
				params.put("P_TO_DATE", request.getParameter("toDate"));
				params.put("P_PLATE_ENDING", request.getParameter("plateEnding"));
				params.put("P_PLATE", request.getParameter("plate"));
				params.put("P_RANGE", request.getParameter("range"));
				params.put("P_REINSURANCE", request.getParameter("reinsurance"));
				params.put("P_DATE_BASIS", request.getParameter("dateBasis"));
				params.put("P_MODULE_ID", request.getParameter("moduleId"));
				params.put("P_REPORT_ID", USER.getUserId());
				params.put("P_CRED_BRANCH", request.getParameter("credBranch"));	// start - SR5328 - 02042016 
				params.put("packageName", "CSV_UW_INQUIRIES");
				params.put("functionName", "get_gipir206");
				params.put("csvAction", "printGIPIR206CSV");	// end - SR5328 - 02042016  
				params.put("mediaSizeName", "US_STD_FANFOLD");
				System.out.println("GIPIR206 params: " + params);
			} else if("printGIPIR209".equals(ACTION)){
				String searchBy = request.getParameter("searchBy");
				params.put("P_AS_OF_DATE", request.getParameter("defaultAsOfDate"));
				
				if("inceptDate".equals(searchBy)){
					params.put("P_INC_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_INC_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_INC_TO_DATE", request.getParameter("toDate"));
				} else if("effectivityDate".equals(searchBy)){
					params.put("P_EFF_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_EFF_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_EFF_TO_DATE", request.getParameter("toDate"));
				} else if("issueDate".equals(searchBy)){
					params.put("P_ISS_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_ISS_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_ISS_TO_DATE", request.getParameter("toDate"));
				} else if("expiryDate".equals(searchBy)){
					params.put("P_EXP_AS_OF_DATE", request.getParameter("asOfDate"));
					params.put("P_EXP_FROM_DATE", request.getParameter("fromDate"));
					params.put("P_EXP_TO_DATE", request.getParameter("toDate"));
				}					
			} else if("printGIPIR192".equals(ACTION)){
				params.put("P_MAKE_CD", request.getParameter("makeCd"));
				params.put("P_COMPANY_CD", request.getParameter("companyCd"));
				params.put("mediaSizeName", "US_STD_FANFOLD");
				params.put("P_SEARCH_BY", request.getParameter("searchBy"));	/* start - SR5324 - 02042016 */
				params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
				params.put("P_FROM_DATE", request.getParameter("fromDate"));
				params.put("P_TO_DATE", request.getParameter("toDate"));
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_CRED_BRANCH", request.getParameter("credBranch"));	
				params.put("packageName", "CSV_UW_INQUIRIES");
				params.put("functionName", "get_gipir192");
				params.put("csvAction", "printGIPIR192CSV");					/* end - SR5324 - 02042016  */
				System.out.println("GIPIR192 params: " + params);
			} else if("printGIPIR111".equals(ACTION)){
				params.put("P_EXPIRY_TAG", request.getParameter("excludeExpired"));
				params.put("P_EFF_TAG", request.getParameter("excludeNotEff"));
				params.put("P_LOCATION_CD", request.getParameter("locationCd"));
				params.put("mediaSizeName", "US_STD_FANFOLD");
				System.out.println(reportId+" params: " + params);
			}else if("printGIPIR110".equals(ACTION)){
				params.put("P_EXPIRY_TAG", request.getParameter("excludeExpired"));
				params.put("P_EFF_TAG", request.getParameter("excludeNotEff"));
				params.put("mediaSizeName", "US_STD_FANFOLD");
			}else if("printGIPIR193".equals(ACTION)){
				params.put("P_PLATE_NO", request.getParameter("plateNo"));
				params.put("mediaSizeName", "US_STD_FANFOLD");
				params.put("P_COMPANY_CD", request.getParameter("companyCd"));	//Carlo Rubenecia  start - SR5325 - 02042016 
				params.put("P_SEARCH_BY", request.getParameter("dateType"));
				params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));
				params.put("P_FROM_DATE", request.getParameter("fromDate"));
				params.put("P_TO_DATE", request.getParameter("toDate"));
				params.put("P_USER_ID", request.getParameter("plateNo"));
				params.put("P_CRED_BRANCH", request.getParameter("credBranch"));
				params.put("packageName", "CSV_UW_INQUIRIES");	
				params.put("functionName", "get_gipir193");
				params.put("csvAction", "printGIPIR193CSV");	//Carlo Rubenecia end - SR5325 - 02042016
			} else if("printGipis212Reports".equals(ACTION)){
				String polOrDate = request.getParameter("polOrDate");
				String dateOption = request.getParameter("dateOption");
				params.put("P_USER_ID", USER.getUserId());  // jhing 04.01.2016 GENQA 5307
				if("1".equals(polOrDate)){
					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
					params.put("P_ISS_CD", request.getParameter("issCd"));
					params.put("P_ISSUE_YY", request.getParameter("issueYy"));
					params.put("P_POL_SEQ_NO", request.getParameter("polSeqNo"));
					params.put("P_RENEW_NO", request.getParameter("renewNo"));
				} else {
					if("1".equals(dateOption)){
						params.put("P_E_FROM", request.getParameter("fromDate") /*sdf.parse(request.getParameter("fromDate"))*/);	// shan 07.11.2014
						params.put("P_E_TO", request.getParameter("toDate") /*sdf.parse(request.getParameter("toDate"))*/);	// shan 07.11.2014
					} else if("2".equals(dateOption)){
						params.put("P_A_FROM", request.getParameter("fromDate") /*sdf.parse(request.getParameter("fromDate"))*/);	// shan 07.11.2014
						params.put("P_A_TO", request.getParameter("toDate") /*sdf.parse(request.getParameter("toDate"))*/);	// shan 07.11.2014
					} else if("3".equals(dateOption)){
						params.put("P_I_FROM", request.getParameter("fromDate") /*sdf.parse(request.getParameter("fromDate"))*/);	// shan 07.11.2014
						params.put("P_I_TO", request.getParameter("toDate") /*sdf.parse(request.getParameter("toDate"))*/);	// shan 07.11.2014
					} else if(/*"3"*/"4".equals(dateOption)){
						params.put("P_F", request.getParameter("fromDate") /*sdf.parse(request.getParameter("fromDate"))*/);	// shan 07.11.2014
						params.put("P_T", request.getParameter("toDate") /*sdf.parse(request.getParameter("toDate"))*/);	// shan 07.11.2014
					}
				}
				//added by clperello 06.10.2014
				if("GIPIR210".equals(reportId)) {
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_gipir210");
					params.put("csvAction", "printGIPIR210");	
				}else if("GIPIR211".equals(reportId)) {
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_gipir211");
					params.put("csvAction", "printGIPIR211");	
				}else if("GIPIR212".equals(reportId)) {
					params.put("packageName", "CSV_UNDRWRTNG");
					params.put("functionName", "csv_gipir212");
					params.put("csvAction", "printGIPIR212");	
				}
			}else if("printGIPIR194".equals(ACTION)){
				params.put("P_MOT_TYPE", request.getParameter("motType"));
				params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
				params.put("P_AS_OF_DATE", request.getParameter("asOfDate"));	/* start - SR5326 - 02042016 */
				params.put("P_FROM_DATE", request.getParameter("fromDate"));
				params.put("P_TO_DATE", request.getParameter("toDate"));
				params.put("P_DATE_TYPE", request.getParameter("dateType"));
				params.put("P_USER_ID", USER.getUserId());
				params.put("packageName", "CSV_UW_INQUIRIES");
				params.put("functionName", "get_gipir194");
				params.put("csvAction", "printGIPIR194CSV");					/* end - SR5326 - 02042016  */
			}else if("printGIPIR208".equals(ACTION)){				
			    params.put("P_DATE_OPT", request.getParameter("dateOpt"));
				params.put("P_AS_OF_DATE", request.getParameter("dateAsOf"));
				params.put("P_FROM_DATE", request.getParameter("dateFrom"));
				params.put("P_TO_DATE", request.getParameter("dateTo"));
				params.put("P_NOTE_TYPE", request.getParameter("noteType"));
				params.put("P_ALARM_FLAG", request.getParameter("alarmFlag"));
				params.put("P_PAR_ID", request.getParameter("parId"));
				System.out.println("GIPIR208 params: " + params);
			}
			params.put("P_USER_ID", USER.getUserId());
			params.put("MAIN_REPORT", reportName+".jasper");
			params.put("OUTPUT_REPORT_FILENAME", reportName);
			params.put("reportTitle", request.getParameter("reportTitle"));
			params.put("reportName", reportName);
			
			this.doPrintReport(request, response, params, reportDir);
			
		} catch (SQLException e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} finally {
			ConnectionUtil.releaseConnection(client);
		}
		
	}
	
}
