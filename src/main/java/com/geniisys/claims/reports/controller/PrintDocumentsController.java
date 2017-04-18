/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.claims.reports.controller
	File Name: PrintDocumentsController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 19, 2011
	Description: 
*/


package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.claims.reports.util.ClaimReportsPropertiesUtil;
import com.geniisys.common.entity.GIISReports;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.report.PrintingUtil;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.gicl.service.GICLReqdDocsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="PrintDocumentsController", urlPatterns={"/PrintDocumentsController"})
public class PrintDocumentsController extends BaseController{

	private static final long serialVersionUID = 4495175421813601953L;
	private static PrintingUtil printingUtil = new PrintingUtil();
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		DataSourceTransactionManager client = null;
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		try{
			if(ACTION.equals("prePrint")){
				System.out.println(request.getParameter("callOut"));
				GICLReqdDocsService giclReqdDocsService = (GICLReqdDocsService) APPLICATION_CONTEXT.getBean("giclReqdDocsService");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != printers.length - 1){
						printerNames = printerNames + ",";
					}
				}
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("assuredName", request.getParameter("assuredName"));
				params.put("callOut", request.getParameter("callOut"));
				
				PAGE = "/pages/claims/claimRequiredDocs/subPages/claimDocsPrePrint.jsp";
				request.setAttribute("title", request.getParameter("title"));
				request.setAttribute("callOut", request.getParameter("callOut"));
				request.setAttribute("message", message);
				request.setAttribute("printerNames", printerNames);
				request.setAttribute("details", giclReqdDocsService.getPrePrintDetails(params));
				request.setAttribute("assuredName", request.getParameter("assuredName"));
				System.out.println(giclReqdDocsService.getPrePrintDetails(params));
				this.doDispatch(request, response, PAGE);
			}else if (ACTION.equals("printClaimDocument")) {
				client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
				ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportId = "GICLR011";
				String reportFont = reportParam.getDefaultReportFont();
				String reportVersion = reportsService.getReportVersion(reportId);
				reportId += "_"+reportVersion;
				System.out.println("REPORT ID AND VERSION: "+reportId);
				String subreportDir = "";
				
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				
				Map<String, Object>params = new HashMap<String, Object>();
				// print parameters from page
				Integer claimId = Integer.parseInt(request.getParameter("claimId"));
				params.put("P_CLAIM_ID", claimId);
				params.put("P_ATTENTION", request.getParameter("attention"));
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_ISS_CD", request.getParameter("issCd"));
				params.put("P_CLAIM_NO", request.getParameter("claimNo"));
				params.put("P_POLICY_NO", request.getParameter("policyNo"));
				params.put("P_LOSS_DATE", request.getParameter("lossDate"));
				params.put("P_CALL_OUT", request.getParameter("callOut"));
				params.put("P_BEGINNING_TEXT", request.getParameter("beginningText"));
				params.put("P_ENDING_TEXT", request.getParameter("endingText"));
				params.put("P_RECIPIENT", request.getParameter("sendTo"));  //added P_RECIPIENT & P_ADDRESS by Christian Santos
				params.put("P_ADDRESS", request.getParameter("address"));
				//end
				String filename = request.getParameter("title")== null ? reportId : (request.getParameter("title").toUpperCase()+"_"+ claimId).replaceAll(" ", "");

				params.put("P_FONT_SW", reportFont);
				params.put("P_USER_NAME", USER.getUsername());
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportId);
				
				System.out.println("printClaimDocuments params" + params);
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}else if ("showReportListing".equals(ACTION)) {
				GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String lineCd = request.getParameter("lineCd");
				List<GIISReports> reportsList = giisReportsService.getReportsListing2(lineCd);
				request.setAttribute("reportsList",reportsList);
				PAGE = "/pages/claims/claimReportsPrintDocs/subPages/repParams.jsp";
				this.doDispatch(request, response, PAGE);
			}else if ("populatePrintDocs".equals(ACTION)){
				//GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
				String reportId = request.getParameter("reportId");
				String version  = request.getParameter("version");
				System.out.println(":::::::::::::VERSION: "+version+"::::::::::::::REPORTID: "+reportId+"::::::::::::");
				String reportName = version == "" ? reportId : reportId+"_"+version ;
				String reportDir = getServletContext().getRealPath("WEB-INF/classes/"+ClaimReportsPropertiesUtil.claimsReports)+"/";
				Map<String, Object> params = new HashMap<String, Object> ();
				
					if ("GICLR036".equals(reportId)){
	                	params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd")); 
		                params.put("P_PAYEE_CD", request.getParameter("payeeCd")); 
						params.put("P_AFF_OF_DESIST_WIT1", request.getParameter("affOfDesistWit1"));
	                    params.put("P_AFF_OF_DESIST_WIT2", request.getParameter("affOfDesistWit2"));
	                    params.put("P_ASSD_NAME", request.getParameter("assdName"));
	                    params.put("P_PLATE_NO", request.getParameter("plateNo"));
	                    params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo"))); // added by: Nica 04.04.2013
	                    params.put("P_ITEM_TITLE", request.getParameter("itemTitle"));
	                    params.put("P_TP_NAME2", request.getParameter("tpName2"));
	                    params.put("P_TP_ADDRESS", request.getParameter("tpAddress"));  //added by jeffdojello 05.09.2013
	                    params.put("P_LOSS_AMT_PAID", request.getParameter("totalPdAmt"));  //added by jeffdojello 05.09.2013
	                    params.put("P_AFF_OF_DESIST_PLACE", request.getParameter("affOfDesistPlace"));
	                    params.put("P_PAYEE_NAME", request.getParameter("payeeName"));
	                    params.put("P_DATE", request.getParameter("date"));
	                    params.put("P_WITNESS1", request.getParameter("witness1"));// added by: Nica 04.06.2013
	                    params.put("P_WITNESS2", request.getParameter("witness2"));// added by: Nica 04.06.2013
	                    //params.put("P_LANGUAGE", request.getParameter("language"));// added by: Nica 04.06.2013 //commented out by jeffdojello 05.09.2013
	                    params.put("P_LANGUAGE", request.getParameter("tpLanguage"));  //added by jeffdojello 05.09.2013
	                    params.put("P_VEHICLE", request.getParameter("tpVehicle"));  //added by robert 09302013
	                    
	                    // marco - 03.24.2014 - added block below
	                    if("UCPB".equals(version)){
	                    	params.put("P_PLATE_NO", request.getParameter("plateNo").replace("<", "&#60;"));
	                    	params.put("P_TP_NAME2", request.getParameter("tpName2").replace("<", "&#60;"));
	                    	params.put("P_AFF_OF_DESIST_PLACE", request.getParameter("affOfDesistPlace").replace("<", "&#60;"));
	                    }
					}else if ("GICLR037".equals(reportId) ){
                 		params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd")); 
		                params.put("P_PAYEE_CD", request.getParameter("payeeCd"));
		                params.put("P_PAYEE_NAME", request.getParameter("payeeName")); //added by christian 07.27.2012
		                params.put("P_SIGNATORY", request.getParameter("signatory"));  //added by christian 07.27.2012
                 		params.put("P_WITNESS1", request.getParameter("witness1"));
	                    params.put("P_WITNESS2", request.getParameter("witness2"));
	                    params.put("P_WITNESS3", request.getParameter("witness3")); //added parameter for WITNESS3 since GICLS041 has field for WITNESS3 by MAC 09/28/2013.
		                params.put("P_WITNESS4", request.getParameter("witness4")); //added parameter for WITNESS4 since GICLS041 has field for WITNESS4 by MAC 09/28/2013.
	                    params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
	                    params.put("P_GROUPED_ITEM_NO", Integer.parseInt(request.getParameter("groupedItemNo")));
	                    params.put("P_TOTAL_PAID_AMT", new BigDecimal(request.getParameter("totalPdAmt").isEmpty() ? "0.00" : request.getParameter("totalPdAmt")));
	                    params.put("P_PLACE", request.getParameter("place"));
	                    params.put("P_DATE", request.getParameter("date"));  //added by christian 07.27.2012
	                    params.put("P_CURRENCY_CD", request.getParameter("currencyCd")); // bonok :: 09.26.2012
					}else if ("GICLR038".equals(reportId)){
						params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd")); //added payee class code by MAC 11/27/2012
		                params.put("P_PAYEE_CD", request.getParameter("payeeCd")); //added payee code by MAC 11/27/2012
	            	   	params.put("P_VENDOR", request.getParameter("vendor")); 
		                params.put("P_VENDOR_ADDRESS", request.getParameter("vendorAddress"));
                		params.put("P_TOTAL_PAID_AMT", request.getParameter("totalPdAmt"));
	                    params.put("P_VENDEE", request.getParameter("vendee"));
	                    params.put("P_VENDEE_ADDRESS", request.getParameter("vendeeAddress"));
	                    params.put("P_PLACE", request.getParameter("place"));
	                    params.put("P_VENDEE_TIN", request.getParameter("vendeeTin"));
	                    params.put("P_VENDOR_TIN", request.getParameter("vendorTin"));
	                	params.put("P_WITNESS1", request.getParameter("witness1")); 
		                params.put("P_WITNESS2", request.getParameter("witness2"));
                		params.put("P_DATE", request.getParameter("date"));
	                    params.put("P_CURRENCY_CD", Integer.parseInt(request.getParameter("currencyCd")));
	                    params.put("P_ENTERED_AMOUNT", request.getParameter("enteredAmount").replaceAll(",", "")); //added user entered amount by MAC 12/4/2012
	                    params.put("P_CLM_LOSS_ID", request.getParameter("clmLossId")); //added clm_loss_id field by MAC 12/4/2012
	                    if(version.equals("UCPB")){//added by kenneth L 03.25.2014 to handle html entities in parameters
	                    	params.put("P_VENDOR", request.getParameter("vendor").replaceAll("<", "&#60"));
	                    	params.put("P_PLACE", request.getParameter("place").replaceAll("<", "&#60"));
	                    	params.put("P_VENDEE_ADDRESS", request.getParameter("vendeeAddress").replaceAll("<", "&#60"));
	                    	params.put("P_VENDOR_ADDRESS", request.getParameter("vendorAddress").replaceAll("<", "&#60"));
	                    	params.put("P_WITNESS1", request.getParameter("witness1").replaceAll("<", "&#60")); 
	                    }
	               }else if ("GICLR039".equals(reportId)){
						params.put("P_TOTAL_PAID_AMT", new BigDecimal(request.getParameter("totalPdAmt").isEmpty() ? "0.00" : request.getParameter("totalPdAmt")));
						params.put("P_PAYEE_NAME", request.getParameter("payeeName"));
	                    params.put("P_LANGUAGE", request.getParameter("language"));
	                    params.put("P_DATE", request.getParameter("date"));
	                    params.put("P_PLACE", request.getParameter("place"));
	                    params.put("P_WITNESS1", request.getParameter("witness1")); 
		                params.put("P_WITNESS2", request.getParameter("witness2"));
		                params.put("P_WITNESS3", request.getParameter("witness3")); 
		                params.put("P_WITNESS4", request.getParameter("witness4"));
		                params.put("P_CURRENCY_CD", Integer.parseInt(request.getParameter("currencyCd")));
		                params.put("P_SIGNATORY", request.getParameter("signatory"));  //added by robert 11.08.2013
	                } else if ("GICLR039B".equals(reportId)) {
	                    params.put("P_CLAIM_ID", request.getParameter("claimId"));
	                    params.put("P_ITEM_NO", request.getParameter("itemNo"));
	                    params.put("P_PERIL_CD", request.getParameter("perilCd"));
	                    params.put("P_CURRENCY_CD", request.getParameter("currencyCd"));
	                    params.put("P_TOTAL_PAID_AMT", request.getParameter("totalPdAmt"));
	                    params.put("P_SIGNATORY", request.getParameter("signatory"));
	                    params.put("P_PLACE", request.getParameter("place"));
	                    params.put("P_DOCUMENT_DATE", request.getParameter("date"));
	                    params.put("P_WITNESS_1", request.getParameter("witness1"));
	                    params.put("P_WITNESS_2", request.getParameter("witness2"));
	                } else if ("GICLR041".equals(reportId)){
						params.put("P_TOTAL_PAID_AMT", request.getParameter("totalPdAmt"));
	                    params.put("P_GIDO_PLACE", request.getParameter("place"));
	                    params.put("P_GIDO_DATE", request.getParameter("date"));
	                    params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
	                    params.put("P_SIGNATORY", request.getParameter("signatory"));
	                    params.put("P_PAYEE_NAME", request.getParameter("payeeName"));
	                    params.put("P_CURRENCY_CD", Integer.parseInt(request.getParameter("currencyCd")));
	                }else if ("GICLR042".equals(reportId) ){
                 		params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd")); 
		                params.put("P_PAYEE_CD", request.getParameter("payeeCd"));
                 		params.put("P_WITNESS1", request.getParameter("witness1"));
	                    params.put("P_WITNESS2", request.getParameter("witness2"));
	                    params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
	                    params.put("P_GROUPED_ITEM_NO", Integer.parseInt(request.getParameter("groupedItemNo")));
	                    params.put("P_TOTAL_PAID_AMT", request.getParameter("totalPdAmt"));
	                    params.put("P_PLACE", request.getParameter("place"));
	                    params.put("P_PAYEE_NAME", request.getParameter("payeeName"));
	                    params.put("P_SIGNATORY", request.getParameter("signatory"));
	                    params.put("P_MAIN_CURRENCY_CD", request.getParameter("currencyCd")); // bonok :: 09.24.2012
	                }else if ("GICLR042B".equals(reportId)){	            
	                	GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
	                	version  = reportsService.getReportVersion("GICLR042B");
	                	reportName = version == "" ? reportId : reportId+"_"+version ;
	                	System.out.println(":::::::::::::VERSION: "+version+"::::::::::::::REPORTID: "+reportId+"::::::::::::REPORTNAME: "+reportName+":::::::");
                 		params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd")); 
		                params.put("P_PAYEE_CD", request.getParameter("payeeCd"));
                 		params.put("P_ADVICE_ID", Integer.parseInt(request.getParameter("adviceId")) ); 
		                params.put("P_LINE_CD", request.getParameter("lineCd"));
		                params.put("P_TOTAL_PAID_AMT", request.getParameter("totalPdAmt"));
	                    params.put("P_PAYEE_NAME", request.getParameter("payeeName"));
	                    //params.put("P_CLAIM_ID", Integer.parseInt(request.getParameter("claimId")));
	                    params.put("P_WITNESS1", request.getParameter("witness1"));
	                    params.put("P_WITNESS2", request.getParameter("witness2"));
	                    params.put("P_DATE", request.getParameter("date"));
	                    params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
	                    params.put("P_SIGNATORY", request.getParameter("signatory")); // Nante 10.21.2013
	                    params.put("P_PLACE", request.getParameter("place"));         // Nante 10.21.2013
					}else if ("GICLR045".equals(reportId)){
						params.put("P_TOTAL_PAID_AMT", request.getParameter("totalPdAmt").equals(null) || request.getParameter("totalPdAmt").equals("")? new BigDecimal(0) : new BigDecimal(request.getParameter("totalPdAmt")));  //added by steven 7/30/2012
	                    params.put("P_GIDO_DATE", request.getParameter("date"));
	                    params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
	                    params.put("P_PERIL_CD", request.getParameter("perilCd")); // added by: Nica 04.04.2013
	                    params.put("P_GROUPED_ITEM_NO", Integer.parseInt(request.getParameter("groupedItemNo")));
	                    params.put("P_WITNESS1", request.getParameter("witness1"));
	                    params.put("P_WITNESS2", request.getParameter("witness2"));
	                    params.put("P_WITNESS3", request.getParameter("witness3"));
	                    params.put("P_WITNESS4", request.getParameter("witness4"));
	                    params.put("P_PAYEE_NAME", request.getParameter("payeeName"));
	                    params.put("P_SIGNATORY", request.getParameter("signatory"));
	                    params.put("P_CURRENCY_CD", request.getParameter("currencyCd"));
					}else if ("GICLR046".equals(reportId)){
                    	params.put("P_PAYEE_NAME", request.getParameter("payeeName"));
                    	params.put("P_TOTAL_PAID_AMT", new BigDecimal(request.getParameter("totalPdAmt").isEmpty() ? "0.00" : request.getParameter("totalPdAmt")));
	                    params.put("P_GIDO_DATE", request.getParameter("date"));
	                    params.put("P_GIDO_PLACE", request.getParameter("place"));
	                    params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")) );
	                    params.put("P_GROUPED_ITEM_NO", Integer.parseInt(request.getParameter("groupedItemNo")) );
	                    params.put("P_WITNESS1", request.getParameter("witness1"));
	                    params.put("P_WITNESS2", request.getParameter("witness2"));
	                    params.put("P_WITNESS3", request.getParameter("witness3"));
	                    params.put("P_WITNESS4", request.getParameter("witness4"));
	                    params.put("P_SIGNATORY", request.getParameter("signatory"));
	                    params.put("P_CURRENCY_CD", request.getParameter("currencyCd"));
	                    params.put("P_DATE", request.getParameter("date"));  //added by christian 07.30.2012
	                    params.put("P_PERIL_CD", request.getParameter("perilCd")); // Nante 10.21.2013
                    }else if ("GICLR047".equals(reportId)){
                 		params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd")); 
		                params.put("P_PAYEE_CD", request.getParameter("payeeCd"));
                 		params.put("P_TOTAL_PAID_AMT", request.getParameter("totalPdAmt")); 
	                    params.put("P_PAYEE_NAME", request.getParameter("payeeName"));
	                    params.put("P_DATE", request.getParameter("date"));
	                    params.put("P_PLACE", request.getParameter("place"));
	                    params.put("P_SIGNATORY", request.getParameter("signatory"));
	                    params.put("P_WITNESS1", request.getParameter("witness1"));
	                    params.put("P_WITNESS2", request.getParameter("witness2"));
	                    params.put("P_CURRENCY_CD", request.getParameter("currencyCd"));  //added by steve 8/6/2012
                    }else if ("GICLR048".equals(reportId) ){
                 		params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd")); 
		                params.put("P_PAYEE_CD", request.getParameter("payeeCd"));
                 		params.put("P_WITNESS1", request.getParameter("witness1"));
	                    params.put("P_WITNESS2", request.getParameter("witness2"));
	                    params.put("P_ITEM_NO", Integer.parseInt(request.getParameter("itemNo")));
	                    params.put("P_GROUPED_ITEM_NO", Integer.parseInt(request.getParameter("groupedItemNo")));
	                    params.put("P_TOTAL_PAID_AMT", request.getParameter("totalPdAmt"));
	                    params.put("P_PLACE", request.getParameter("place"));
	                    params.put("P_SIGNATORY", request.getParameter("signatory"));
	                    params.put("P_DATE", request.getParameter("date"));
	                    params.put("P_CURRENCY_CD", request.getParameter("currencyCd"));
                    }else if ("GICLR049".equals(reportId)){
	                	params.put("P_PAYEE_CLASS_CD", request.getParameter("payeeClassCd")); 
		                params.put("P_PAYEE_CD", request.getParameter("payeeCd"));
		                params.put("P_CURRENCY_CD", request.getParameter("currencyCd"));
	                	params.put("P_TOTAL_PAID_AMT", request.getParameter("totalPdAmt"));
	                    params.put("P_POLICY_NO", request.getParameter("policyNo"));
	                    params.put("P_LOSS_CTGRY", request.getParameter("lossCtgry"));
	                    params.put("P_DSP_LOSS_DATE", request.getParameter("lossDate"));
	                    params.put("P_WITNESS1", request.getParameter("witness1"));
	                    params.put("P_WITNESS2", request.getParameter("witness2"));
	                    params.put("P_DATE", request.getParameter("date"));
	                    params.put("P_PAYEE_NAME", request.getParameter("payeeName"));
	                    params.put("P_PLACE", request.getParameter("place"));         // nante 10.18.2013 auii
	                    params.put("P_WITNESS3", request.getParameter("witness3"));   // nante 10.18.2013 auii
	                    params.put("P_WITNESS4", request.getParameter("witness4"));   // nante 10.18.2013 auii
	                    params.put("P_SIGNATORY", request.getParameter("signatory")); // Nante 10.21.2013 auii
	                }
                    
                    System.out.println(reportId +" PARAMS :::: " + params);

				params.put("P_CLAIM_ID", Integer.parseInt(request.getParameter("claimId"))); // reports P_CLAIM_ID parameter must be in java.lang.Integer datatype
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", request.getParameter("title") == null ? reportId : request.getParameter("title"));
				params.put("reportName", reportName);
				
				if("GICLR036".equals(reportId) || "GICLR037".equals(reportId) || "GICLR038".equals(reportId) || "GICLR039".equals(reportId) || "GICLR041".equals(reportId)	
						|| "GICLR042".equals(reportId) || "GICLR042B".equals(reportId)	|| "GICLR045".equals(reportId) || "GICLR046".equals(reportId) || "GICLR047".equals(reportId) 
						|| "GICLR048".equals(reportId) || "GICLR049".equals(reportId) || ("GICLR039B".equals(reportId))){
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				}
				
				System.out.println(":::::::::::PARAMS:::::::::::"+params.toString());
				this.doPrintReport(request, response, params, reportDir);
				
			} else if ("printRecAE".equals(ACTION)) {
				String reportId = request.getParameter("reportId");
				
				String reportLocation = ClaimReportsPropertiesUtil.claimsReports;
				String subreportDir = "";
				subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportLocation+"/")+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				String tranId = request.getParameter("tranId");
				params.put("P_TRAN_ID", tranId);
				params.put("P_TRAN_NO", request.getParameter("tranNo"));
				params.put("MAIN_REPORT", reportId+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", reportId+"_"+ tranId);
				
				this.doPrintReport(request, response, params, subreportDir);
				
			}
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
