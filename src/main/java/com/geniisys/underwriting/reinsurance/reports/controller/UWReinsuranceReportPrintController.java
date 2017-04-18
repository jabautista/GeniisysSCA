package com.geniisys.underwriting.reinsurance.reports.controller;

import java.io.IOException;
import java.sql.SQLException;
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

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="UWReinsuranceReportPrintController", urlPatterns={"/UWReinsuranceReportPrintController"})
public class UWReinsuranceReportPrintController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(UWReinsuranceReportPrintController.class);
	
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			String reportsLocation = "/com/geniisys/underwriting/";
			String reportId = request.getParameter("reportId");
			String filename = reportId;
			
			if (reportId.equals("GIEXR106") || reportId.equals("GIEXR107")){
				reportsLocation = reportsLocation + "renewal/reports/";
			}else{
				reportsLocation = reportsLocation +"reinsurance/reports/";
			}
			
			String subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportsLocation+"/")+"/";
			
			DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
			
			if("printUWRiBinderReport".equals(ACTION)) {
				log.info("Printing UW Reinsurance Binder Report...");				
				
				if ("GIRIR121".equals(reportId)){
					log.info("Printing RI Agreement Bond...");
					GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
					Integer fnlBinderId = Integer.parseInt(request.getParameter("fnlBinderId"));
					String version = giisReportsService.getReportVersion(reportId);
					reportId = reportId + "_" + version;
					filename = reportId;
					
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
					
					params.put("P_FINAL_BINDER_ID", fnlBinderId);
					params.put("P_RI_SIGNATORY", request.getParameter("riAgrmntBndName"));
					params.put("P_RI_SIG_DESIGNATION", request.getParameter("riAgrmntBndDesignation"));
					params.put("P_ATTEST", request.getParameter("riAgrmntBndAttest"));
				} else{
					String lineCd = request.getParameter("lineCd");
					Integer binderYy = Integer.parseInt(request.getParameter("binderYy").replaceAll(" ", ""));
					Integer binderSeqNo = Integer.parseInt(request.getParameter("binderSeqNo").replaceAll(" ", ""));
					
					if("GIRIR001".equals(request.getParameter("reportId"))){
						reportId = reportId+"_MAIN";
						filename = reportId;
					}else if ("GIRIR001B".equals(request.getParameter("reportId"))){
						params.put("P_ATTENTION", "REINSURANCE DEPARTMENT");
						// apollo 08.12.2015 - sr#19929 - merging of GIRIR001 and GIRIR001B
						reportId = "GIRIR001_MAIN";
						filename = reportId;
					}
					/*else if ("GIRIR123".equals(request.getParameter("reportId"))){
					}else if ("GIRIR035".equals(request.getParameter("reportId"))){
						params.put("P_PRINT_OPTION", request.getParameter("printOption"));
					}else if("GIRIR038".equals(request.getParameter("reportId"))){
					}*/
					
					filename = filename+"_"+lineCd+"-"+binderYy+"-"+binderSeqNo;
					
					System.out.println("subreportDir: " + subreportDir);
					params.put("P_LINE_CD", lineCd);
					params.put("P_BINDER_YY", binderYy);
					params.put("P_BINDER_SEQ_NO", binderSeqNo);
					
				}
				
				Debug.print("UW Reinsurance Binder Report Params: "+ params);			
				
			}else if("printUWRiOutAcceptReport".equals(ACTION)){
				if ("GIRIR101".equals(reportId) || "GIRIR037".equals(reportId)){	//acceptance report/letter
					params.put("P_RI_CD", request.getParameter("riCd"));
					//Date oarPrintDate = request.getParameter("oarPrintDate").equals("")? null : df.parse(request.getParameter("oarPrintDate"));
					Integer moreThan = request.getParameter("moreThan").equals("")? 0 : Integer.parseInt(request.getParameter("moreThan"));
					Integer lessThan = request.getParameter("lessThan").equals("")? 0 : Integer.parseInt(request.getParameter("lessThan"));

					params.put("P_LINE_CD", request.getParameter("lineCd"));
					params.put("P_OAR_PRINT_DATE", request.getParameter("oarPrintDate"));
					params.put("P_MORETHAN", moreThan);
					params.put("P_LESSTHAN", lessThan);
					params.put("P_DATE_SW", request.getParameter("dateSw"));
					params.put("packageName", "CSV_UW_RI_REPORTS");		//added by carlo de guzman 02/10/16 SR-5339
					params.put("functionName", "csv_girir101");			//added by carlo de guzman 02/10/16 SR-5339
					params.put("csvAction", "printGIRIR101CSV");		//added by carlo de guzman 02/10/16	SR-5339
				}else{
					//for Binders and FRPS report
					Date fromDate = request.getParameter("fromDate").equals("")? null : df.parse(request.getParameter("fromDate"));
					Date toDate = request.getParameter("toDate").equals("")? null : df.parse(request.getParameter("toDate"));
					
					if("GIRIR036".equals(reportId)){	//for Binders report
						params.put("P_RI_CD", request.getParameter("riCd"));
						params.put("P_LINE_CD", request.getParameter("lineCd"));
						params.put("P_FROM_DATE", fromDate);
						params.put("P_TO_DATE", toDate);
						params.put("packageName", "CSV_UW_RI_REPORTS");		/* start - carlo de guzman SR5338 - 02092016 */
						params.put("functionName", "get_girir036");
						params.put("csvAction", "printGIRIR036CSV");		/* end - carlo de guzman SR5338 - 02092016 */						
					}else if("GIRIR105".equals(reportId)){ //for FRPS report
						params.put("P_FROM_DATE", request.getParameter("fromDate"));
						params.put("P_TO_DATE", request.getParameter("toDate"));
						params.put("P_LINE_CD", request.getParameter("lineCd")); //temporarily used line_cd by robert 09262013	//in CS, it is not being passed correctly
					}
					
				}
				
				Debug.print("UW Reinsurance Outstanding Report Params: " + params);
				
			}else if("printUWRiAssumedReport".equals(ACTION)){
				// for GIRIR103(Assumed Premium Production (Posted)) and GIRIR104 (Assumed Production Comparative Study)
				params.put("P_REPORT_MONTH", request.getParameter("reportMonth"));
				params.put("P_REPORT_YEAR", request.getParameter("reportYear"));
				Debug.print("UW Reinsurance Assumed Report Params: " + params);
			}else if("printUWRiExpListReport".equals(ACTION)){
				if (reportId.equals("GIRIR110") || reportId.equals("GIEXR107")){ 	//GIRIR110 - Facultative Reinsurance Renewal Request, GIEXR107 - Expiry List of Outward Reinsurance 
					params.put("P_REINSURER", request.getParameter("riSname"));
					params.put("P_LINE", request.getParameter("lineName"));
					params.put("P_EXPIRY_YEAR", request.getParameter("expiryYear"));
					params.put("P_USER_ID", USER.getUserId()); //added by robert 09272013
					
					if(reportId.equals("GIRIR110")){
						params.put("P_EXPIRY_MONTH", request.getParameter("expiryMonth"));						
					}else{
						String expiryMonth = request.getParameter("expiryMonth") == "" ? "" : request.getParameter("expiryMonth").substring(0, 3).toUpperCase();
						params.put("P_EXPIRY_MONTH", expiryMonth);						
					}
				}else if(reportId.equals("GIRIR114") || reportId.equals("GIEXR106")){  //GIRIR114 - Inward Reinsurance Expiry List, GIEXR106 - Expiry List of Assumed Business 
					params.put("P_EXTRACT_ID", Integer.parseInt(request.getParameter("extractId")));
					params.put("P_EXPIRY_MONTH", request.getParameter("expiryMonth"));
					params.put("P_EXPIRY_YEAR", request.getParameter("expiryYear"));
				}
				System.out.println(request.getParameter("extractId"));
			}else if("printUWRiExpPPWReport".equals(ACTION)){	
				// GIRIR122 (List of Inward Policies with Expired PPW) 
				Date asOfDate = request.getParameter("asOfDate").equals("")? null : df.parse(request.getParameter("asOfDate"));
				
				params.put("P_REINSURER", request.getParameter("riName"));
				params.put("P_LINE", request.getParameter("lineName"));
				params.put("P_AS_OF_DATE", asOfDate);
				params.put("P_REP_DATE", request.getParameter("repDate"));
				Debug.print("UW Reinsurance Expiry PPW Report Params: " + params);
			}else if("printUWRiFacultativeReport".equals(ACTION)){
				// for GIRIR106(Facultative Reinsurance Register (Detailed)) and GIRIR107 (Facultative Reinsurance Register (Summary))
				params.put("P_REPORT_MONTH", request.getParameter("reportMonth").toUpperCase());
				params.put("P_REPORT_YEAR", request.getParameter("reportYear"));
				Debug.print("UW Reinsurance Facultative RI Report Params: " + params);
			}else if("printUWRiOutwardReport".equals(ACTION)){
				// for GIRIR108(Outward Reinsurance Summary Report) 
				params.put("P_REPORT_MONTH", request.getParameter("reportMonth").toUpperCase());
				params.put("P_REPORT_YEAR", request.getParameter("reportYear"));
				Debug.print("UW Reinsurance Outward RI Report Params: " + params);
			}else if("printUWRiTreatyReport".equals(ACTION)){
				// for GIRIR109(Treaty Bordereaux Report) 
				params.put("P_REPORT_MONTH", request.getParameter("reportMonth").toUpperCase());
				params.put("P_REPORT_YEAR", request.getParameter("reportYear"));
				if (reportId.equals("GIRIR124") || reportId.equals("GIRIR124_CSV")){ //benjo 01.24.2017 SR-5917
					params.put("P_TRANSACTION", request.getParameter("transaction").toUpperCase());
				}
				Debug.print("UW Reinsurance Treaty Report Params: " + params);
			}else if("printUWRiListingReport".equals(ACTION)){
				// for GIRIR011 (List of Reinsurer/Broker)
				params.put("P_RI_TYPE_DESC", request.getParameter("riTypeDesc"));
				Debug.print("UW Reinsurance Listing Report Params: " + params);
			}else if("printUWRiRenewalReport".equals(ACTION)){
				//for GIRIR020 (Facultative Business Report)
				Date fromDate = request.getParameter("fromDate").equals("")? null : df.parse(request.getParameter("fromDate"));
				Date toDate = request.getParameter("toDate").equals("")? null : df.parse(request.getParameter("toDate"));
				
				params.put("P_RI_SNAME", request.getParameter("riSname"));
				params.put("P_MONTH", request.getParameter("month"));
				params.put("P_YEAR", request.getParameter("year"));
				params.put("P_START_DATE", fromDate);
				params.put("P_END_DATE", toDate);
				Debug.print("UW Reinsurance Renewal Report Params: "+ params);
			}else if("printUWRiReciprocityReport".equals(ACTION)){
				//for GIRIR029 (RI Facultative Reciprocity Report)
				params.put("P_RI_CD", request.getParameter("riCd"));
				Debug.print("UW Reinsurance Reciprocity Report Params: " + params);
			} else if("printSampleBinder".equals(ACTION)) { // Apollo Cruz 07.31.2015 UW-SPECS-2015-014
				if(request.getParameter("preBinderId") != null && request.getParameter("preBinderId") != "")
					params.put("P_PRE_BINDER_ID", Integer.parseInt(request.getParameter("preBinderId")));
				
				params.put("P_USER_ID", USER.getUserId());
			}
			
			params.put("MAIN_REPORT", reportId+".jasper");
			params.put("OUTPUT_REPORT_FILENAME", filename);
			params.put("reportName", reportId);
			System.out.println(reportId + " PARAMS: " + params.toString());
			
			log.info("Creating UW RI Report: " + filename);
			
			this.doPrintReport(request, response, params, subreportDir);
			
		}catch(SQLException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
