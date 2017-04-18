package com.geniisys.accounting.reports.controllers;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.geniisys.giac.service.GIACApdcPaytService;
import com.geniisys.gipi.service.GIPIWCommInvoiceService;
import com.geniisys.policydocs.reports.exception.EmptyFileReadException;
import com.geniisys.policydocs.reports.service.PolicyReportGenerator;
import com.geniisys.policydocs.reports.util.PolicyReportsPropertiesUtil;
import com.seer.framework.util.ApplicationContextReader;

public class PrintAcknowledgmentReceiptController extends BaseController{

	private static final long serialVersionUID = 5038760242358832085L;

	private Logger log = Logger.getLogger(PrintAcknowledgmentReceiptController.class);
	
	@SuppressWarnings("unused")
	private PrintServiceLookup printServiceLookup;
		
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		DataSourceTransactionManager client = null;
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACApdcPaytService apdcPaytService = (GIACApdcPaytService) APPLICATION_CONTEXT.getBean("giacApdcPaytService");
			
			if ("showPrintAR".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				String apdcNo = request.getParameter("apdcNo");
				String fundCd = request.getParameter("fundCd");
				String branchCd = request.getParameter("branchCd");
				String newApdcNo = "";
				
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != printers.length - 1){
						printerNames = printerNames + ",";
					}
				}
				
				if (!("".equals(apdcNo))){
					newApdcNo = apdcNo;
				} else {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("branchCd", branchCd);
					params.put("fundCd", fundCd);
					newApdcNo = String.format("%010d", apdcPaytService.getDocSeqNo(params));
				}
				
				request.setAttribute("apdcNo", newApdcNo);
				request.setAttribute("apdcId", request.getParameter("apdcId"));
				request.setAttribute("printerNames", printerNames);
				
				log.info("Printer names : " + printerNames);
				
				PAGE = "/pages/accounting/PDCPayment/pop-ups/printAcknowledgmentReceipt.jsp";
				this.doDispatch(request, response, PAGE);
			} else if ("verifyARPrinting".equals(ACTION)){
				Map<String, Object> verifyPrintParamsMap = new HashMap<String, Object>();
				Integer apdcNo = Integer.parseInt(request.getParameter("apdcNo"));
				verifyPrintParamsMap.put("apdcNo", apdcNo);
				verifyPrintParamsMap.put("apdcPref", request.getParameter("apdcPref"));
				verifyPrintParamsMap.put("branchCd", request.getParameter("branchCd"));
				verifyPrintParamsMap.put("fundCd", request.getParameter("fundCd"));
				
				message = apdcPaytService.verifyApdcNo(verifyPrintParamsMap);
				
				PAGE = "/pages/genericMessage.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			}else if ("prepareARReportVariables".equals(ACTION)){
				GIPIWCommInvoiceService commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> printVarMap = new HashMap<String, Object>();
				printVarMap.put("company", commInvoiceService.getAccountingParameter("COMPANY_NAME"));
				printVarMap.put("companyAddr", commInvoiceService.getAccountingParameter("COMPANY_ADDRESS"));
				
				System.out.println(printVarMap.toString());
				
				JSONObject json = new JSONObject(printVarMap);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("printAcknowledgmentReceipt".equals(ACTION)){
log.info("Printing acknowledgment receipt...");
				
				client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
				ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				Map<String, Object> params = new HashMap<String, Object>();
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
								
				Integer apdcId = Integer.parseInt(request.getParameter("apdcId"));
				Integer apdcNo = Integer.parseInt(request.getParameter("apdcNo")); //added by jeffdojello 12.13.2013
				String company = request.getParameter("company");
				String companyAddr = request.getParameter("companyAddr");
				String printerName = request.getParameter("printerName");
				String reportFont = reportParam.getDefaultReportFont();
				
				String reportName = "GIACR090_ACKNOWLEDGMENT_RECEIPT";
				String reportVersion = reportsService.getReportVersion("GIACR090");
				
				String subreportDir = "";
				
				if(reportVersion == null || reportVersion.isEmpty()){
					reportName = "GIACR090_ACKNOWLEDGMENT_RECEIPT";
				} else {
					reportName = "GIACR090_" + reportVersion;
				}
				
				if ("---".equals(printerName) || "".equals(printerName)){
					printerName = "";
				}
				
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_AC");
				
				params.put("P_FONT_SW", reportFont);
				params.put("P_USER_NAME", USER.getUsername());
				params.put("P_COMPANY", company);
				params.put("P_COMPANY_ADDR", companyAddr);
				params.put("P_APDC_ID", apdcId);
				params.put("P_APDC_NO", apdcNo); //added by jeffdojello 12.12.2013
				params.put("reportName", reportName);
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportName + apdcId);
				
				this.doPrintReport(request, response, params, subreportDir);
				
				PAGE = "/pages/genericMessage.jsp";;
			} else if ("savePrintChanges".equals(ACTION)){
				String apdcId = request.getParameter("apdcId");
				String apdcNo = request.getParameter("apdcNo");
				Integer newSeqNo = Integer.parseInt(apdcNo) + 1;
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("apdcId", Integer.parseInt(apdcId));
				params.put("apdcNo", Integer.parseInt(apdcNo));
				params.put("newSeqNo", newSeqNo);
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("cicPrintTag", request.getParameter("cicPrintTag"));
				params.put("appUser", USER.getUserId()); //added by albert 10.18.2016: UCPBGEN SR 23081
				apdcPaytService.savePrintChanges(params);
				
				/*Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("branchCd", request.getParameter("branchCd"));
				params2.put("fundCd", request.getParameter("fundCd"));
				params2.put("keyword", "%%");
				params2.put("apdcId", Integer.parseInt(apdcId));
				
				GIACApdcPayt apdcPayt = apdcPaytService.getGIACApdcPayt(Integer.parseInt(apdcId));
				
				System.out.println(apdcPayt.getApdcNo());
				
				message = apdcPayt.toString();*/
				PAGE = "/pages/genericMessage.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else {
				log.info("Initializing " + this.getClass().getSimpleName());
			
				ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
				client =  (DataSourceTransactionManager) appContext.getBean("transactionManager");
				ApplicationWideParameters reportParam =  (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams"); // nica 12.02.2010
				
				PolicyReportGenerator polReportGenerator = new PolicyReportGenerator();
//				int apdcId = Integer.parseInt(request.getParameter("apdcId"));
				String reportFont = reportParam.getDefaultReportFont();
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("DRAFT", "preview".equals(ACTION) ? new Integer(1) : new Integer(0));
				params.put("EXTRACT_ID", new Integer(200));
				params.put("SUBREPORT_DIR", getServletContext().getRealPath("WEB-INF/classes/"+PolicyReportsPropertiesUtil.reportsLocation)+"/");
				params.put("MAIN_REPORT", "GIACR090_ACKNOWLEDGMENT_RECEIPT.jasper");
				params.put("OUTPUT_REPORT_FILENAME", new Integer(200));
				params.put("GENERATED_REPORT_DIR", getServletContext().getInitParameter("GENERATED_ACCOUNTING_REPORTS_DIR"));
				params.put("CONNECTION", client.getDataSource().getConnection());
				// nica 12.01.2010 -- added parameter P_FONT_SW to designate font for the report
				params.put("P_FONT_SW", reportFont);
				
				if (polReportGenerator.generateReport(params)) {
					String filePath = params.get("GENERATED_ACCOUNTING_REPORTS_DIR").toString() + 200+".pdf";
					FileInputStream fis = new FileInputStream(filePath);
					byte[] pdfByte = new byte[fis.available()];
					fis.read(pdfByte);
					fis.close();
					if (null==pdfByte) {
						throw new EmptyFileReadException("Failed to generate acknowledgment receipt because the file is empty...");
					} else {
						File newFile = File.createTempFile("acknowledgment receipt", ".pdf");
						FileOutputStream os = new FileOutputStream(newFile);
						System.out.println("byte size:" + pdfByte.length);
						os.write(pdfByte);
						os.flush();
						os.close();
						ServletOutputStream out = response.getOutputStream();
						response.setContentType("application/pdf");
						ByteArrayInputStream bais = new ByteArrayInputStream(pdfByte);
						int i = 0;
						while ((i = bais.read()) != -1) {
							out.write(i);
						}
						out.flush();
						out.close();
					}
				}
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = "Failed to generate acknowledgment receipt report...<br />"+e.getLocalizedMessage();
		} finally {
			ConnectionUtil.releaseConnection(client);
		}
		
	}

}
