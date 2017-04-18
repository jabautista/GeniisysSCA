package com.geniisys.accounting.reports.controllers;

import java.io.IOException;
import java.sql.SQLException;
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
import com.geniisys.common.report.PrintingUtil;
import com.geniisys.common.report.ReportGenerator;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACOpTextService;
import com.geniisys.giac.service.GIACOrderOfPaymentService;
import com.seer.framework.util.ApplicationContextReader;

public class PrintORController extends BaseController{

private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(PrintORController.class);
	
	//private PrintServiceLookup printServiceLookup;
	
	private static PrintingUtil PrintingUtil = new PrintingUtil();
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		DataSourceTransactionManager client = null;
		boolean doDispatch = true;
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			//GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
			String strGaccTranId = request.getParameter("globalGaccTranId") == null ? "0" : request.getParameter("globalGaccTranId");
			Integer gaccTranId= strGaccTranId.trim().equals("") ? 0 : Integer.parseInt(strGaccTranId);
			String gaccBranchCd = request.getParameter("globalGaccBranchCd") == null ? "" :request.getParameter("globalGaccBranchCd");
			String gaccFundCd = request.getParameter("globalGaccFundCd") == null ? "" :request.getParameter("globalGaccFundCd");
			
			if("showPrintOR".equals(ACTION)) {
				log.info("show print or");
								
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				for(int i=0; i<printers.length; i++) {
					printerNames = printerNames + printers[i].getName();
					if(i != printers.length - 1) {
						printerNames = printerNames + ",";
					}
				}
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId);
				params.put("branchCd", gaccBranchCd);
				params.put("fundCd", gaccFundCd);
				params.put("user", USER.getUserId());
				params.put("orType", request.getParameter("orPref"));
				params = giacOpTextService.newFormInstanceGIACS050(params);
				
				request.setAttribute("orType", request.getParameter("orPref"));
				request.setAttribute("prnORMap", new JSONObject(params));
				System.out.println("Show PRint OR - pref ::: "+request.getParameter("orPref"));
				request.setAttribute("printerNames", printerNames);
				log.info("printerNames: "+printerNames);
				PAGE = "/pages/accounting/officialReceipt/orPreview/pop-ups/printOR2.jsp";
				
				this.doDispatch(request, response, PAGE);
			} else if("changeORPref".equals(ACTION)) {
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				String orPref = request.getParameter("orPref");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId);
				params.put("branchCd", gaccBranchCd);
				params.put("fundCd", gaccFundCd);
				params.put("user", USER.getUserId());
				params.put("orType", orPref);
				params = giacOpTextService.newFormInstanceGIACS050(params);
				
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
				this.doDispatch(request, response, PAGE);
			} else if("checkVATOR".equals(ACTION)) {
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				String check = giacOpTextService.checkVATOR(gaccTranId, gaccBranchCd, gaccFundCd);
				System.out.println("Check VAT OR Result : "+check);
				request.setAttribute("message", check);
				PAGE = "/pages/genericMessage.jsp";
				this.doDispatch(request, response, PAGE);
			} else if("validateBeforePrint".equals(ACTION)) {
				log.info("validating OR for Printing");
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				
				String orPref = request.getParameter("orPref");
				System.out.println("OR PREFIX:: "+orPref);
				String orNo = request.getParameter("orNo") == null ? "0" : request.getParameter("orNo");
				String orType = request.getParameter("orType");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", gaccTranId);
				params.put("branchCd", gaccBranchCd);
				params.put("fundCd", gaccFundCd);
				params.put("userId", USER.getUserId());
				params.put("orPref", orPref);
				params.put("orNo", Integer.parseInt(orNo));
				params.put("orType", orType);
				params.put("editOrNo", request.getParameter("editOrNo"));
				
				params = giacOpTextService.validateORForPrint(params);
				Debug.print("validate o.r. - "+params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
				
				this.doDispatch(request, response, PAGE);
			} else if("printCurrentOR".equals(ACTION)) {
				log.info("Printing OR...");
				client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
				ApplicationWideParameters reportParam =  (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams"); // nica 12.02.2010
				
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				
				String orPref = request.getParameter("orPref");
				System.out.println("OR PREFIX:: "+orPref);
				String orNo = request.getParameter("orNo");
				String printerName = request.getParameter("printerName");
				String reportFont = reportParam.getDefaultReportFont();
				int isDraft = Integer.parseInt(request.getParameter("isDraft") == "" || request.getParameter("isDraft") == null ? "1" : request.getParameter("isDraft"));
				Map<String, Object> params = new HashMap<String, Object>();
				//String reportName = "GIACR050_" + reportsService.getReportVersion("GIACR050");
				//belle 11.21.2011
				//String reportName = "GIACR050_UCPB"; 
				String version = reportsService.getReportVersion("GIACR050");
				String reportId = request.getParameter("reportId");
				String reportName = (version == "" ? reportId :  reportId+"_"+version);
				//end 
				
				String subreportDir = "";
				
				if (request.getParameter("isDraft") == null && ("---".equals(printerName) || "".equals(printerName))){
					System.out.println("IS DRAFT::::::::"+request.getParameter("isDraft"));
					printerName = "";
					isDraft = 1;
				}
				
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				
				System.out.println("tran id: "	+ gaccTranId);
				System.out.println("reportFont: " + reportFont);
				System.out.println("reportName: "+reportName);
				System.out.println("reportDir: "+subreportDir);
				
				params.put("P_OR_PREF", orPref);
				params.put("P_OR_NO", Integer.parseInt(orNo));
				params.put("P_TRAN_ID", gaccTranId);
				params.put("DRAFT", isDraft);
				params.put("P_FONT_SW", reportFont);
				
				params.put("P_DRAFT", 				 isDraft);
				params.put("SUBREPORT_DIR", 		 subreportDir);//*getServletContext().getRealPath("WEB-INF/classes/"+PolicyReportsPropertiesUtil.reportsLocation)+"/");*/
				params.put("P_SUBREPORT_DIR", 		 subreportDir);
				params.put("MAIN_REPORT", 			 reportName+".jasper");
				//params.put("OUTPUT_REPORT_FILENAME", orPref+ " - " +orNo);
				params.put("OUTPUT_REPORT_FILENAME", reportName+ "_" +orPref+ "_" +orNo);
				params.put("GENERATED_REPORT_DIR", 	 getServletContext().getInitParameter("GENERATED_REPORTS_DIR"));
				params.put("CONNECTION", 			 client.getDataSource().getConnection());
				params.put("P_USER_ID", 			 USER.getUserId());
				params.put("reportName", reportName);
				params.put("destination", request.getParameter("destination"));
				
				if(request.getParameter("destination") != null && request.getParameter("destination").equals("LOCAL")) {
					ReportGenerator.generateJRPrintFileToServer(request.getSession().getServletContext().getRealPath(""), params);
					message = request.getHeader("Referer")+"reports/"+reportName + "_"+ orPref+ "_" +orNo +".jrprint";
				} else {
					PrintingUtil.startReportGeneration(params, response, request);
				}
				System.out.println("Test @ Print OR Controller -"+message);
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
				
				if(request.getParameter("destination") != null && request.getParameter("destination").equals("LOCAL")) {
					this.doDispatch(request, response, PAGE);
				} /*else {
					doDispatch = false;
				}*/
			} else if("insUpdGIOP".equals(ACTION)) {
				GIACOrderOfPaymentService GIOP = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				String orPref = request.getParameter("orPref");
				System.out.println("OR PREFIX:: "+orPref);
				String orNo = request.getParameter("orNo") == null ? "0" : request.getParameter("orNo");
				String orType = request.getParameter("orType");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", gaccTranId);
				params.put("branchCd", gaccBranchCd);
				params.put("fundCd", gaccFundCd);
				params.put("orPref", orPref);
				params.put("orNo", Integer.parseInt(orNo));
				params.put("userId", USER.getUserId());
				params.put("orType", orType);
				params.put("editOrNo", request.getParameter("editOrNo"));
				
				log.info("Test insUpdGIOP params - "+params);
				params = GIOP.giacs050InsUpdGIOP(params);
				String updResult = (String) params.get("pResult");
				if(updResult.equals("ORA1")) {
					params = GIOP.insUpdGIOPNewOR(params);
				}
				log.info("params after insUpdGIOP : "+params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
				
				this.doDispatch(request, response, PAGE);
			} else if("spoilPrintedOR".equals(ACTION)) {
				GIACOrderOfPaymentService GIOP = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				String orPref = request.getParameter("orPref");
				System.out.println("OR PREFIX:: "+orPref);
				String orNo = request.getParameter("orNo");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", gaccTranId);
				params.put("branchCd", gaccBranchCd);
				params.put("fundCd", gaccFundCd);
				params.put("orPref", orPref);
				params.put("orNo", orNo.equals("") || orNo == null ? null : Integer.parseInt(orNo));
				params.put("userId", USER.getUserId());
				params.put("orType", request.getParameter("orType"));
				
				params = GIOP.spoilPrintedOR(params);
				String result = (String) params.get("pResult");
				System.out.println("Spoil OR Result: "+result);
				request.setAttribute("message", result);
				PAGE = "/pages/genericMessage.jsp";
				this.doDispatch(request, response, PAGE);
			}
			//new OR validation
			else if ("validateOR".equals(ACTION)) {
				GIACOrderOfPaymentService giacOrderOfPaytService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId);
				params.put("branchCd", gaccBranchCd);
				params.put("fundCd", gaccFundCd);
				params.put("userId", USER.getUserId());
				params.put("orPref", request.getParameter("orPref"));
				params.put("orNo", request.getParameter("orNo") == null ? "0" : Integer.parseInt(request.getParameter("orNo")));
				params.put("orType", request.getParameter("orType"));
				params.put("editOrNo", request.getParameter("editOrNo"));
				System.out.println("Validate OR Params: "+params);
				giacOrderOfPaytService.validateOR2(params);
				JSONObject obj= new JSONObject(params);
				log.info("Validate OR Results: "+obj);
				message = obj.toString();
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
				this.doDispatch(request, response, PAGE);
			} else if ("generateNewORNo".equals(ACTION)) {
				GIACOrderOfPaymentService giacOrderOfPaytService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("branchCd", gaccBranchCd);
				params.put("fundCd", gaccFundCd);
				params.put("userId", USER.getUserId());
				params.put("orPref", request.getParameter("orPref"));
				params.put("orNo", request.getParameter("orNo") == null ? "0" : Integer.parseInt(request.getParameter("orNo")));
				params.put("editOrNo", request.getParameter("editOrNo"));
				params.put("orType", request.getParameter("orType"));
				System.out.println("Generate New OR Params: "+params);
				message = new JSONObject(giacOrderOfPaytService.generateNewOR(params)).toString();
				log.info("Generate New OR Result: "+message);
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
				this.doDispatch(request, response, PAGE);
			} else if("processPrintedOR".equals(ACTION)) {
				GIACOrderOfPaymentService giacOrderOfPaytService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", gaccTranId);
				params.put("branchCd", gaccBranchCd);
				params.put("fundCd", gaccFundCd);
				params.put("orPref", request.getParameter("orPref"));
				params.put("orNo", Integer.parseInt(request.getParameter("orNo") == null ? "0" : request.getParameter("orNo")));
				params.put("userId", USER.getUserId());
				params.put("appUser", USER.getUserId());
				params.put("orType", request.getParameter("orType"));
				params.put("editOrNo", request.getParameter("editOrNo"));
				giacOrderOfPaytService.processPrintedOR(params);
				message = "SUCCESS";
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
				this.doDispatch(request, response, PAGE);
			}else if("notSuccPrinting".equals(ACTION)) { //added by steven 2/26/2013
				GIACOrderOfPaymentService giacOrderOfPaytService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", gaccTranId);
				params.put("branchCd", gaccBranchCd);
				params.put("fundCd", gaccFundCd);
				
				giacOrderOfPaytService.delOR(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				this.doDispatch(request, response, PAGE);
			}
		} catch (SQLException e) {
			/*e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = "Failed to generate O.R. due to sql error...<br />"+e.getCause();*/
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				//message = ExceptionHandler.handleException(e, USER);
				message = "Failed to generate O.R. due to sql error...<br />"+e.getCause();
			}
			request.setAttribute("message", message);
			PAGE = "/pages/genericMessage.jsp";
			this.doDispatch(request, response, PAGE);
/*		} catch (EmptyFileReadException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = "Failed to generate policy information report because file is empty...";
*/		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = "Failed to generate OR...<br />"+e.getLocalizedMessage();
			request.setAttribute("message", message);
			PAGE = "/pages/genericMessage.jsp";
			this.doDispatch(request, response, PAGE);
		} finally {
			/*if(doDispatch) {
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			}*/
			ConnectionUtil.releaseConnection(client);
			//this.doDispatch(request, response, PAGE);
		}
	}

}
