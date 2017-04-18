package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACCommSlipService;
import com.seer.framework.util.ApplicationContextReader;

public class GIACCommSlipController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACCommSlipController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		DataSourceTransactionManager client = null;  
		boolean printLocal = true;
		
		try {
			log.info("Initializing..."+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			String tranId = request.getParameter("gaccTranId");
			int gaccTranId = tranId.trim().equals("") ? 0 : Integer.parseInt(tranId);
			DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
			
			if ("showCommSlip".equals(ACTION)) {
				log.info("Showing comm slip page...");
				GIACCommSlipService giacCommSlip = (GIACCommSlipService) APPLICATION_CONTEXT.getBean("giacCommSlipService");
				GIISParameterFacadeService giisParam = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
								
				Map<String, Object> grid = new HashMap<String, Object>();
				grid.put("gaccTranId", gaccTranId);
				grid.put("userId", USER.getUserId());
				grid = giacCommSlip.getCommSlip(grid);	// uncommented : shan 07.09.2014
				
				//request.setAttribute("commSlipGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(grid)));
				
				//marco - replaced codes above - 10.08.2013
				JSONObject json = giacCommSlip.getCommSlipJSON(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("clientUser", giisParam.getParamValueV2("COMPANY_SHORT_NAME"));
					request.setAttribute("commSlipGrid", json);
					PAGE = "/pages/accounting/officialReceipt/commSlip/commSlip.jsp";
				}
				
				//PAGE = "/pages/accounting/officialReceipt/commSlip/commSlip.jsp";
				//request.setAttribute("message", message);
				//this.doDispatch(request, response, PAGE);
			} else if ("forwardToPrintComm".equals(ACTION)) {
				log.info("Showing comm slip print modal...");
				GIACCommSlipService giacCommSlip = (GIACCommSlipService) APPLICATION_CONTEXT.getBean("giacCommSlipService");
				String vpdc = request.getParameter("vpdc") == null ? "N" : request.getParameter("vpdc");
				
				/*PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				for(int i=0; i<printers.length; i++) {
					printerNames = printerNames + printers[i].getName();
					if(i != printers.length - 1) {
						printerNames = printerNames + ",";
					}
				}*/
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
				request.setAttribute("printers", printers);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giacCommSlip.preparePrintParam(request.getParameter("parameters"), USER.getUserId(), gaccTranId, vpdc);
				
				request.setAttribute("commPrinted", request.getParameter("commPrinted") == null ? "N" : request.getParameter("commPrinted"));
				//request.setAttribute("printerNames", printerNames);
				request.setAttribute("commMap", new JSONObject(params));
				
				PAGE = "/pages/accounting/officialReceipt/commSlip/pop-ups/printCommSlip.jsp";
				
				request.setAttribute("message", message);
			} else if("printCommSlip".equals(ACTION)) {
				log.info("Printing commission slip...");
				client =  (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager"); // +env
				ApplicationWideParameters reportParam =  (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String printerName = request.getParameter("printerName");
				String reportFont = reportParam.getDefaultReportFont();
				int isDraft = Integer.parseInt(request.getParameter("isDraft") == "" || request.getParameter("isDraft") == null ? "1" : request.getParameter("isDraft"));
				Map<String, Object> params = new HashMap<String, Object>();
				String reportNameRdf = request.getParameter("reportId");
				String reportName = "";
				String reportVersion = reportsService.getReportVersion(reportNameRdf);
				if(reportNameRdf.equals("GIACR250")) {
					if(reportVersion == null || reportVersion.isEmpty()){
						reportName = "GIACR250_COMMISSION_SLIP";
					} else {
						reportName = "GIACR250_" + reportVersion;
					}
				}
				String subreportDir = "";
				
				String commSlipPref = request.getParameter("commSlipPref");
				String commSlipNo = request.getParameter("commSlipNo");
				String intmNo = request.getParameter("intmNo");
				String branchCd = request.getParameter("gaccBranchCd");
				Date commDate = request.getParameter("commSlipDate") == "" ? new Date() : df.parse(request.getParameter("commSlipDate")); // Nica 08.01.2012
				
				if(request.getParameter("isDraft") == null && ("---".equals(printerName) || "".equals(printerName))) {
					System.out.println("IsDraft? == "+request.getParameter("isDraft"));
					printerName = "";
					isDraft = 1;
				}
				
				String reportLocation = "/com/geniisys/accounting/reports/";
				subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportLocation+"/")+"/";
				
				System.out.println("tran id: "	+ tranId);
				System.out.println("reportFont: " + reportFont);
				System.out.println("reportName: "+reportName);
				System.out.println("reportDir: "+subreportDir);
				System.out.println("intm no: "+intmNo);
				System.out.println("commslip no: "+commSlipNo); 	 	 	
				System.out.println("commslip pref: "+commSlipPref);
				
				params.put("P_GACC_TRAN_ID", tranId);
				params.put("P_BRANCH_CD", branchCd);
				params.put("P_INTM_NO", intmNo);
				params.put("P_REPORT_ID", reportNameRdf);
				params.put("P_CS_NO", commSlipNo);
				params.put("P_CS_PREF", commSlipPref);
				params.put("P_CS_DATE", request.getParameter("commSlipDate"));
				params.put("P_COMM_SLIP_DATE", commDate);
				
				params.put("DRAFT", isDraft);
				params.put("P_FONT_SW", reportFont);
				params.put("P_DRAFT", 				 isDraft);
				params.put("SUBREPORT_DIR", 		 subreportDir);
				params.put("P_SUBREPORT_DIR", 		 subreportDir);
				params.put("MAIN_REPORT", 			 reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName + "_" + commSlipNo);
				params.put("GENERATED_REPORT_DIR", 	 getServletContext().getInitParameter("GENERATED_ACCOUNTING_REPORTS_DIR"));
				params.put("CONNECTION", 			 client.getDataSource().getConnection());
				params.put("P_USER_ID", 			 USER.getUserId());
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				params.put("destination", request.getParameter("destination"));
				/*
				 * commented out by reymon 11122013
				if(request.getParameter("destination") != null && request.getParameter("destination").equals("LOCAL")){
					ReportGenerator.generateJRPrintFileToServer(request.getSession().getServletContext().getRealPath(""), params);
					message = request.getHeader("Referer")+"reports/"+reportName + "_"+ commSlipNo +".jrprint";
				} else {
					printLocal = false;
					PrintingUtil.startReportGeneration(params, response, request);					
				}*/
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/accounting/cashreceipt/reports")+"/";//added by reymon 11122013
				System.out.println(params);
				this.doPrintReport(request, response, params, reportDir);//added by reymon 11122013
				System.out.println("message: "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("confirmCSPrinting".equals(ACTION)) {
				log.info("Comm slip confirmed printed...");
				GIACCommSlipService giacCommSlip = (GIACCommSlipService) APPLICATION_CONTEXT.getBean("giacCommSlipService");
				int commNo = request.getParameter("commSlipNo") == "" ? 0 : Integer.parseInt(request.getParameter("commSlipNo"));
				
				Date commDate = request.getParameter("commSlipDate") == "" ? new Date() : df.parse(request.getParameter("commSlipDate"));
				System.out.println("TEST == "+gaccTranId+", "+commNo+", "+commDate);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", gaccTranId);
				params.put("commSlipPref", request.getParameter("commSlipPref"));
				params.put("commSlipNo", commNo);
				params.put("commSlipDate", commDate);
				params.put("prnSuccess", request.getParameter("prnSuccess") == null ? "N" : request.getParameter("prnSuccess"));
				
				giacCommSlip.confirmCommSlipPrinted(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				//request.setAttribute("message", message);
				//this.doDispatch(request, response, PAGE);
			} else if("printCommSlip2".equals(ACTION)){
				client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				
				String reportId = request.getParameter("reportId");
				String reportVersion = reportsService.getReportVersion(reportId);
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				String reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				String reportName = reportVersion == null ? reportId : reportId+"_"+reportVersion;
				
				Date commDate = request.getParameter("commSlipDate") == "" ? new Date() : df.parse(request.getParameter("commSlipDate"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_GACC_TRAN_ID", tranId);
				params.put("P_BRANCH_CD", request.getParameter("gaccBranchCd"));
				params.put("P_INTM_NO", request.getParameter("intmNo"));
				params.put("P_REPORT_ID", request.getParameter("reportId"));
				params.put("P_CS_NO", request.getParameter("commSlipNo"));
				params.put("P_CS_PREF", request.getParameter("commSlipPref"));
				params.put("P_CS_DATE", request.getParameter("commSlipDate"));
				params.put("P_COMM_SLIP_DATE", commDate);
				
				params.put("P_USER_ID", USER.getUserId());
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName);
				params.put("reportTitle", request.getParameter("reportTitle"));
				params.put("reportName", reportName);
				
				printLocal = false;
				this.doPrintReport(request, response, params, reportDir);
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			ConnectionUtil.releaseConnection(client);
			if(printLocal) {
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			}
			
		}	
		
	}

}
