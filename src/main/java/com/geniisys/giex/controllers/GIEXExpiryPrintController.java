package com.geniisys.giex.controllers;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.geniisys.framework.util.Debug;
import com.geniisys.giex.service.GIEXExpiryService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIEXExpiryPrintController", urlPatterns={"/GIEXExpiryPrintController"})
public class GIEXExpiryPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		
		try{
			if("printGiexs006Report".equals(ACTION)){
				//Integer policyId = request.getParameter("policyId") == "" ? null : Integer.parseInt(request.getParameter("policyId")); comment out by kenneth 11.24.2014
				
				String reportName = request.getParameter("reportName");
				String reportsLocation = "/com/geniisys/underwriting/renewal/reports/";
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportsLocation+"/")+"/";
				String printBy = request.getParameter("printBy");
				Integer policyId = null; // added by kenneth 11.24.2014
				String strPolicyId = null;
				
				Map<String, Object> params = new HashMap<String, Object>();
				//modified by kenneth 11.24.2014 to pass string policy_id parameter when printing renewal and non renewal reports
				if(reportName.equals("RENEW") || reportName.equals("RENEW_PACK") || reportName.equals("NON_RENEW") || reportName.equals("NON_RENEW_PK")){
					strPolicyId = request.getParameter("policyId");
					Integer length = strPolicyId.length();
					
					if(length <= 4000){
						params.put("P_POLICY_ID", strPolicyId.substring(0, strPolicyId.length()));
					}else if(length <= 8000){
						params.put("P_POLICY_ID", strPolicyId.substring(0, 4000));
						params.put("P_POLICY_ID2", strPolicyId.substring(4001,strPolicyId.length()));
					}else if(length <= 12000){
						params.put("P_POLICY_ID", strPolicyId.substring(0, 4000));
						params.put("P_POLICY_ID2", strPolicyId.substring(4001,8000));
						params.put("P_POLICY_ID3", strPolicyId.substring(8001,strPolicyId.length()));
					}
				}else{
					policyId = request.getParameter("policyId") == "" ? null : Integer.parseInt(request.getParameter("policyId"));
					params.put("P_POLICY_ID", policyId);
				}
				
				//Map<String, Object> params = new HashMap<String, Object>();
				//params.put("P_POLICY_ID", policyId);
				params.put("P_IS_PACKAGE", "");
				params.put("reportName", reportName);
				params.put("P_NON_RENEWAL_OPTION1", request.getParameter("reason1")); // PJD 09/30/2013 parameter for non renewal
				params.put("P_NON_RENEWAL_OPTION2", request.getParameter("reason2")); // PJD 09/30/2013 parameter for non renewal
				params.put("P_NON_RENEWAL_OPTION3", request.getParameter("reason3")); // PJD 09/30/2013 parameter for non renewal
				params.put("P_NON_RENEWAL_REMARKS", request.getParameter("reason4")); // PJD 09/30/2013 parameter for non renewal
				params.put("P_CONTACT_NO1", request.getParameter("telNo1")); //jeffdojello 10.17.2013 renewal parameter
				params.put("P_CONTACT_NO2", request.getParameter("telNo2")); //jeffdojello 10.17.2013 renewal parameter
				params.put("P_CONTACT_NO3", request.getParameter("telNo3")); //jeffdojello 10.17.2013 renewal parameter
				params.put("P_CONTACT_NO4", request.getParameter("telNo4")); //jeffdojello 10.17.2013 renewal parameter
				params.put("P_SALES_ASST1", request.getParameter("salesAsst1")); //jeffdojello 10.17.2013 renewal parameter
				params.put("P_SALES_ASST2", request.getParameter("salesAsst2")); //jeffdojello 10.17.2013 renewal parameter
				params.put("P_SALES_ASST3", request.getParameter("salesAsst3")); //jeffdojello 10.17.2013 renewal parameter
							
				if(reportName.equals("RENEW") || reportName.equals("RENEW_PACK") || reportName.equals("NON_RENEW") || reportName.equals("NON_RENEW_PK")){
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
					
					if(reportName.equals("RENEW_PACK") || reportName.equals("NON_RENEW_PK")){ // cherrie 11.22.2012
						params.put("P_PACK_POLICY_ID", strPolicyId);
					}
					Map<String, Object> params2 = new HashMap<String, Object>();
					if (reportName.equals("RENEW")||reportName.equals("RENEW_PACK")){
						params2.put("userId", USER.getUserId());
						//params2.put("policyId", policyId);
						if(reportName.equals("RENEW")){
							params2.put("isPack", "N");
						}else if(reportName.equals("RENEW_PACK")){
							params2.put("isPack", "Y");
						}
						params2.put("userId2", USER.getUserId());
						GIEXExpiryService giexExpiryService = (GIEXExpiryService) APPLICATION_CONTEXT.getBean("giexExpiryService");
						//modified by kenneth 11.24.2014 to update print tag of the record
						String[] polIdArr = request.getParameter("policyId").split(",");
						for (int i = 0; i < polIdArr.length; i++) {
							params2.put("policyId", Integer.parseInt(polIdArr[i]));
							giexExpiryService.updatePrintTag(params2);
						}
					}
					
					String version = giisReportsService.getReportVersion(reportName);
					String reportId = reportName + "_" + version;
					params.put("reportName", reportId); //marco - 04.15.2013 - overwrite reportName for print to file
					params.put("MAIN_REPORT", reportId+".jasper");
					//params.put("OUTPUT_REPORT_FILENAME", reportId+"_"+policyId); replaced by kenneth 11.24.2014 
					params.put("OUTPUT_REPORT_FILENAME", reportId);
					params.put("mediaSizeName", "LETTER");
				}else if(reportName.equals("GIEXR101A") || reportName.equals("GIEXR101B") || reportName.equals("GIEXR102")
						|| reportName.equals("GIEXR102A") || reportName.equals("GIEXR103A") || reportName.equals("GIEXR103B")
						|| reportName.equals("GIEXR104") || reportName.equals("GIEXR104A") || reportName.equals("GIEXR105")
						|| reportName.equals("GIEXR105A") || reportName.equals("GIEXR106A")
						|| reportName.equals("GIEXR106B") || reportName.equals("GIEXR113")
						|| reportName.equals("GIEXR101B_CSV") || reportName.equals("GIEXR101A_CSV")
						|| reportName.equals("GIEXR102A_CSV") || reportName.equals("GIEXR102_CSV")
						|| reportName.equals("GIEXR103A_CSV") || reportName.equals("GIEXR103B_CSV")){
					
					if (reportName.equals("GIEXR104")) {				/* start - SR5320 - 02042016 */
						params.put("packageName", "CSV_UW_RENEWAL");	
						params.put("functionName", "get_giexr104");
						params.put("csvAction", "printGIEXR104CSV");
					} else if (reportName.equals("GIEXR105")) {
						params.put("packageName", "CSV_UW_RENEWAL");	
						params.put("functionName", "get_giexr105");
						params.put("csvAction", "printGIEXR105CSV");
					} else if (reportName.equals("GIEXR113")) {
						params.put("packageName", "CSV_UW_RENEWAL");	
						params.put("functionName", "get_giexr113");
						params.put("csvAction", "printGIEXR113CSV");						
					}													/* end - SR5320 - 02052016  */
					
					if(printBy.equals("batch")){
						params.put("P_ASSD_NO", request.getParameter("assdNo") == "" ? null : Integer.parseInt(request.getParameter("assdNo")));
						params.put("P_INTM_NO", request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo")));
						params.put("P_ISS_CD", request.getParameter("issCd"));
						params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
						params.put("P_LINE_CD", request.getParameter("lineCd"));
						params.put("P_INCLUDE_PACK", request.getParameter("includePackage"));
						params.put("P_CLAIMS_FLAG", request.getParameter("claimsOnly").toString().equals("undefined") ? null : request.getParameter("claimsOnly"));
						params.put("P_BALANCE_FLAG", request.getParameter("premBalanceOnly").toString().equals("undefined") ? null : request.getParameter("premBalanceOnly"));
						
						DateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
						String sDate = request.getParameter("startDate");
						String startDate;
						if(sDate.equals("") || sDate.equals("undefined")){
							startDate = "";
						}else{
							Date strtDate = df.parse(request.getParameter("startDate"));
							startDate = df.format(strtDate);
						}				
						Date eDate = df.parse(request.getParameter("endDate"));
						String endDate = df.format(eDate);
						params.put("P_STARTING_DATE", startDate);
						params.put("P_ENDING_DATE", endDate);
						
						if(reportName.equals("GIEXR106A")){	// Start: added by Kevin Sumalinog 3-28-2016 SR: 5322
							params.put("packageName", "CSV_UW_RENEWAL");	
							params.put("functionName", "CSV_GIEXR106A");
							params.put("csvAction", "printGIEXR106ACSV");
						}else if(reportName.equals("GIEXR106B")){
							params.put("packageName", "CSV_UW_RENEWAL");	
							params.put("functionName", "CSV_GIEXR106B");
							params.put("csvAction", "printGIEXR106BCSV"); // end: added by Kevin Sumalinog 3-28-2016 SR: 5322
						}
					}
					params.put("P_USER_ID", USER.getUserId()); //apollo cruz 03.04.2015
					params.put("mediaSizeName", "US_STD_FANFOLD");
					params.put("OUTPUT_REPORT_FILENAME", reportName);
					params.put("MAIN_REPORT", reportName+".jasper");
					params.put("filePath", getServletContext().getInitParameter("GENERATED_EXPIRY_REPORTS_DIR")+reportName+".pdf");
				}else if(reportName.equals("GIEXR107")){
					if(printBy.equals("batch")){
						params.put("P_LINE", request.getParameter("lineName"));
						params.put("P_EXPIRY_MONTH", request.getParameter("expiryMonth"));
						params.put("P_EXPIRY_YEAR", request.getParameter("expiryYear"));
						params.put("P_USER_ID", USER.getUserId()); //added by robert 09272013
					}
					params.put("mediaSizeName", "US_STD_FANFOLD");
					params.put("OUTPUT_REPORT_FILENAME", reportName);
					params.put("MAIN_REPORT", reportName+".jasper");
				}

				Debug.print("GIEXS006 Report Params: "+ params);
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}
		}catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
