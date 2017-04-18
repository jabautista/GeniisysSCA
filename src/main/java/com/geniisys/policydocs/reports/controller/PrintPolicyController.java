package com.geniisys.policydocs.reports.controller;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISDocumentService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.pack.service.GIPIPackPARListService;
import com.geniisys.gipi.pack.service.GIPIPackPolbasicService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.policydocs.reports.exception.EmptyFileReadException;
import com.geniisys.policydocs.reports.service.PolicyReportGenerator;
import com.geniisys.policydocs.reports.util.PolicyReportsPropertiesUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class PrintPolicyController extends BaseController {

	private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(PrintPolicyController.class);
	
	private PrintServiceLookup printServiceLookup;
		
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings({ "static-access", "unused"})
	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) 
		throws ServletException, IOException {
		
		FileOutputStream os = null;
		ServletOutputStream out = null;
		FileInputStream fis = null;
		DataSourceTransactionManager client = null;
		
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
			GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");			
			GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService"); //Dren 02.02.2016 SR-5266	
			
			if ("showPolicyPrintingPage".equals(ACTION) || "showRegeneratePolicyDocumentsPage".equals(ACTION)){
				GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIISDocumentService docServ = (GIISDocumentService) APPLICATION_CONTEXT.getBean("giisDocumentService");
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != (printers.length-1)){
						printerNames = printerNames + ",";
					}
				}
				request.setAttribute("printerNames", printerNames);
				request.setAttribute("vValue", serv.getParamValueV2("PRINT_BILL"));
				request.setAttribute("vShowField", serv.getParamValueV2("SHOW_FIELDS"));
				request.setAttribute("vAccSlip", serv.getParamValueV2("PRINT_ACCEPTANCE_SLIP"));
				request.setAttribute("vMed", serv.getParamValueV2("LINE_CODE_MD"));
				request.setAttribute("reports2", giisReportsService.getReportsListing());
				request.setAttribute("ackReportVersion", giisReportsService.getReportVersion("ACK")); // andrew - 06.1.2012 - to handle the special case in republic
				log.info("printerNames: "+printerNames);			
				
				if ("showPolicyPrintingPage".equals(ACTION)){								
					int parId = Integer.parseInt(request.getParameter("globalParId")== ""? "0": request.getParameter("globalParId"));
					int packParId = Integer.parseInt(request.getParameter("globalPackParId")== ""? "0": request.getParameter("globalPackParId"));
					//int parId = 957;//SU37009;//CA1452;//AV41431;//44172;//EN41349;//MH55372;//MN1059;//FI1176;//MC957;//40112;//957;
					//int packParId = 0;
					String packPol = "";
					if (0 != packParId){
						packPol = "1";
						parId = packParId; // andrew - 07.18.2011 - set packParId as the parameter if package 
						
						GIPIPackPolbasicService gipiPackPolbasicService = (GIPIPackPolbasicService) APPLICATION_CONTEXT.getBean("gipiPackPolbasicService");
						request.setAttribute("withMc", gipiPackPolbasicService.checkIfWithMc(packParId));
					} else if (0 != parId){
						packPol = "0";
					} else {//if parId = 0
						packPol = "0";
					}
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("packPol", packPol);
					System.out.println(parId+", "+packPol);
					GIPIPolbasic pol = gipiPolbasicService.getPolicyDetails(params);
					//log.info("policyId: "+pol.getPolicyId());
					String[] policyId = {pol.getPolicyId().toString()};
					request.setAttribute("printOrder", "1");
					request.setAttribute("pol", StringFormatter.escapeHTMLInObject(pol)); //added stringformatter reymon 02202013
					request.setAttribute("packPol", packPol);
					request.setAttribute("endtTax2", StringFormatter.escapeHTMLInObject(gipiPolbasicService.getEndtTax2GIPIS091(pol.getPolicyId()))); //added stringformatter reymon 02202013					
					request.setAttribute("printPremDetails", StringFormatter.escapeHTMLInObject(docServ.checkPrintPremiumDetails(pol.getLineCd()))); //added stringformatter reymon 02202013 //marco - 11.19.2012 - for "print premium details"
					
					if (packPol.equals("1")) {// added for pack policy printing - irwin , 11.16.11
						request.setAttribute("invoiceListing", lovHelper.getList(LOVHelper.POLICY_PACK_INVOICE_LISTING, policyId));
					}else{
						request.setAttribute("invoiceListing", lovHelper.getList(LOVHelper.POLICY_INVOICE_LISTING, policyId));
						
						GIPIPARListService gipiPARListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
						String lineCd = gipiPARListService.getGIPIPARDetails(parId).getLineCd();
						String menuLineCd = giisLineService.getMenuLineCd(lineCd); //Dren 02.02.2016 SR-5266					
						
						if (lineCd.equals("SU") || menuLineCd.equals("SU") || giisLineService.getPackPolFlag(lineCd).equals("Y")) {
							request.setAttribute("vWarcla", "N");
						} else {
							request.setAttribute("vWarcla", serv.getParamValueV2("ALLOW_PRINT_WARCLA_ATTACHMENT"));
						}; //Dren 02.02.2016 SR-5266
					}
					
					PAGE = "/pages/underwriting/policyPrinting.jsp";
				} else if ("showRegeneratePolicyDocumentsPage".equals(ACTION)){
					request.setAttribute("printOrder", "2");
					request.setAttribute("printSpoiledPolTag", serv.getParamValueV2("PRINT_SPOILED_POLICIES"));
					PAGE = "/pages/underwriting/regeneratePolicyDocuments.jsp";
				}
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("showReportGenerator".equals(ACTION)){
				GIISDocumentService docServ = (GIISDocumentService) APPLICATION_CONTEXT.getBean("giisDocumentService");
				
				GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");//DRENX
				
				int parId = Integer.parseInt(request.getParameter("globalParId")== ""? "0": request.getParameter("globalParId"));
				int packParId = Integer.parseInt(request.getParameter("globalPackParId")== ""? "0": request.getParameter("globalPackParId"));
				log.info("Showing report generator for PAR ID - "+parId+" PACK_PAR_ID - "+ packParId +"...");
				String packPol = "";
				if (0 != packParId){
					packPol = "1";
				} else if (0 != parId){
					packPol = "0";
				} else {//if parId = 0
					packPol = "0";
				}
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("packPol", packPol);
				GIPIPolbasic pol = gipiPolbasicService.getPolicyDetails(params);
				if (pol != null){
					request.setAttribute("policyId", pol.getPolicyId());
				}
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("reportType", request.getParameter("reportType"));
				
				// added by: nica 08.10.2011 - to be used for cover note printing
				if(request.getParameter("reportType").equals("coverNote")){
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					Map<String, Object> coverNoteParams = new HashMap<String, Object>();
					coverNoteParams.put("parId", parId);
					coverNoteParams = gipiWPolbasService.getCoverNoteDetails(coverNoteParams);
					request.setAttribute("coverNoteExpiry", coverNoteParams.get("coverNoteExpiry"));
					request.setAttribute("cnDatePrinted", coverNoteParams.get("cnDatePrinted"));
					request.setAttribute("cnNoOfDays", coverNoteParams.get("cnNoOfDays"));
				}else if(request.getParameter("reportType").equals("policy")){ //marco - 11.19.2012 - for "print premium details"
					if(pol != null){
						request.setAttribute("printPremDetails", docServ.checkPrintPremiumDetails(pol.getLineCd()));

					System.out.println("POL>>>!");
						
					}else{
						String lineCd = "";
						if(packPol.equals("1")){ //marco - 07.18.2013 - handling for package
							GIPIPackPARListService gipiPackPARListService = (GIPIPackPARListService) APPLICATION_CONTEXT.getBean("gipiPackPARListService");
							lineCd = gipiPackPARListService.getGIPIPackParDetails(parId).getLineCd();
						}else{
							GIPIPARListService gipiPARListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
							lineCd = gipiPARListService.getGIPIPARDetails(parId).getLineCd();
						}
						request.setAttribute("printPremDetails", docServ.checkPrintPremiumDetails(lineCd));
						
						String menuLineCd = giisLineService.getMenuLineCd(lineCd); //Dren 02.02.2016 SR-5266	
						
						if (lineCd.equals("SU") || menuLineCd.equals("SU") || giisLineService.getPackPolFlag(lineCd).equals("Y")) {
							request.setAttribute("printWarcla", "N");
						} else {
							request.setAttribute("printWarcla", serv.getParamValueV2("ALLOW_PRINT_WARCLA_ATTACHMENT"));
						}; //Dren 02.02.2016 SR-5266
					}
				}
				
				String printerNames = "";
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != (printers.length-1)){
						printerNames = printerNames + ",";
					}
				}
				request.setAttribute("printerNames", printerNames);
				log.info("printerNames: "+printerNames);
				PAGE = "/pages/underwriting/pop-ups/reportGenerator.jsp";
				message = "";
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("printPolicyReport".equals(ACTION)) {
				long heapSpace = Runtime.getRuntime().totalMemory();
				log.info("HEAP: " + heapSpace + " - Printing policy documents...");
				client =  (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager"); // +env
				ApplicationWideParameters reportParam =  (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams"); // nica 12.02.2010
				//GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");	
				//MarketingReportsPropertiesUtil propsUtil = new MarketingReportsPropertiesUtil();
				PolicyReportsPropertiesUtil policyRepUtil = new PolicyReportsPropertiesUtil();
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportId = request.getParameter("reportId");
				String lineCd = request.getParameter("lineCd");
				
				Integer policyId = Integer.parseInt(request.getParameter("policyId") == ""? "0" : request.getParameter("policyId"));
				Integer extractId = Integer.parseInt(request.getParameter("extractId")== ""? "0" : request.getParameter("extractId"));
				String printerName = request.getParameter("printerName");
				String reportFont = reportParam.getDefaultReportFont();
				int isDraft = Integer.parseInt(request.getParameter("isDraft") == "" || request.getParameter("isDraft") == null || request.getParameter("isDraft").equals("undefined") ? "1" : request.getParameter("isDraft"));
				Map<String, Object> params = new HashMap<String, Object>();
				String reportName = "";
				String subreportDir = "";
				SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
				
				if (request.getParameter("isDraft") == null && ("---".equals(printerName) || "".equals(printerName))){
					System.out.println("IS DRAFT::::::::"+request.getParameter("isDraft"));
					printerName = "";
					isDraft = 1;
				}
                System.out.println("reportId "+ reportId);
                params.put("P_POLICY_ID", policyId);
				if ("BONDS".equalsIgnoreCase(reportId) || "SURETYSHIP".equalsIgnoreCase(reportId)){
					String bondParType = request.getParameter("bondParType");
					Integer parId = Integer.parseInt(request.getParameter("parId") == ""? "0" : request.getParameter("parId"));
					String sublineCd = request.getParameter("sublineCd");
					System.out.println(" REPORT ID: "  + reportId);
					System.out.println("sublineCd: "+ sublineCd);
					System.out.println("bond par type: "+bondParType);
					System.out.println(" REPORT ID = "  + reportId);
					
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
					
					params.put("P_PAR_ID", parId);
					params.put("P_EXTRACT_ID", extractId);
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_REPORT_ID", reportId); //added by steven 9/20/2012
					params.put("P_REG_DEED_NO", request.getParameter("regDeedNo"));
					params.put("P_REG_DEED", request.getParameter("regDeed"));
					params.put("P_DATE_ISSUED", request.getParameter("dateIssued"));
					params.put("P_BOND_TITLE", request.getParameter("bondTitle"));
					params.put("P_REASON", request.getParameter("reason"));
					params.put("P_SAVINGS_ACCT_NO", request.getParameter("savingsAcctNo"));
					params.put("P_CASE_NO", request.getParameter("caseNo"));
					params.put("P_VERSUS_A", request.getParameter("versusA"));
					params.put("P_VERSUS_B", request.getParameter("versusB"));
					params.put("P_VERSUS_C", request.getParameter("versusC"));
					params.put("P_VERSUS_D", request.getParameter("sheriffLoc"));
					params.put("P_JUDGE", request.getParameter("judge"));
					params.put("P_PART_A", request.getParameter("partA"));
					params.put("P_PART_B", request.getParameter("partB"));
					params.put("P_PART_C", request.getParameter("partC"));
					params.put("P_PART_D", request.getParameter("partD"));
					params.put("P_PART_E", request.getParameter("partE"));
					params.put("P_PART_F", request.getParameter("partF"));
					params.put("P_BRANCH", request.getParameter("branch"));
					params.put("P_BRANCH_LOC", request.getParameter("branchLoc"));
					params.put("P_APP_DATE", request.getParameter("appDate"));
					params.put("P_GUARDIAN", request.getParameter("guardian"));
					params.put("P_COMPLAINANT", request.getParameter("complainant"));
					params.put("P_VERSUS", request.getParameter("versus"));
					params.put("P_SECTION", request.getParameter("section"));
					params.put("P_RULE", request.getParameter("rule"));
					params.put("P_SIGN_A", request.getParameter("signA"));
					params.put("P_SIGN_B", request.getParameter("signB"));
					params.put("P_SIGNATORY", request.getParameter("signatory"));

					if(bondParType.equals("E")) {
						String version = reportsService.getReportVersion("BONDS_ENDT", lineCd);
						reportName = "BONDS_ENDT" + (version != null && version != "" ? "_" + version : "");
						subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_POLDOC");
					} else {
						//reportName = policyRepUtil.getReportName(sublineCd)+"_"+reportsService.getReportVersion("BONDS", lineCd);	//added lineCd Gzelle 11132014
						reportName = sublineCd+"_"+reportsService.getReportVersion("BONDS", lineCd); //replaced above code SR 23956 Daniel Marasigan 03.06.2017, to cater other bond sublines not included in hardcoded list of bond reports 
					}
				} else if ("ACK".equalsIgnoreCase(reportId)){	
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
					
					params = addNotaryParametersToMap(params, request);					
					String reportVersion = reportsService.getReportVersion("ACK");					
					if(reportVersion.equals("RSIC")) { // special case for republic only
						params.put("P_AOJ_SW", request.getParameter("aojSw")); // andrew - 05.31.2012 - used for republic
					}
					
					System.out.println(params.toString());
					reportName = reportId + "_" + reportVersion;
				} else if ("INDEM".equalsIgnoreCase(reportId)){
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
										
					params.put("P_PERIOD", request.getParameter("period"));
					params.put("P_ACK_LOCATION", request.getParameter("ackLoc"));
					params.put("P_ACK_DATE", request.getParameter("ackDate"));
					params.put("P_SIGN_A", request.getParameter("signA"));
					params.put("P_SIGN_B", request.getParameter("signB"));
					
					params = addNotaryParametersToMap(params, request);
					System.out.println("Indem params ::: "+params.toString());
					reportName = policyRepUtil.getReportName(reportId) + "_" + reportsService.getReportVersion("INDEM");
				} else if ("AOJ".equalsIgnoreCase(reportId)){
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
					
					params = addNotaryParametersToMap(params, request);
					System.out.println(params.toString());
					reportName = policyRepUtil.getReportName(reportId) + "_" + reportsService.getReportVersion("AOJ");
				} else {
					reportName = policyRepUtil.getReportName(reportId);
				}
				
				System.out.println("reportId: " + reportId);
				System.out.println("policyId: " + policyId);
				System.out.println("extractId: " + extractId);
				System.out.println("reportFont: " + reportFont);
				System.out.println("reportName: " + reportName);
				
				if ("POLICY_DOCUMENT_MAIN".equals(reportName)){
					String version = reportsService.getReportVersion(reportId, lineCd);	//added lineCd Gzelle 09052014
					
					reportName += (version != null && version != "" ? "_" + version : "");
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_POLDOC");
					
					params.put("EXTRACT_ID", extractId);
					params.put("REPORT_ID", reportId);
					params.put("PREM_DET", "Y");
					params.put("P_ABBREVIATION", request.getParameter("abbreviation"));
					params.put("DRAFT", isDraft);
					params.put("P_FONT_SW", reportFont); 
					params.put("P_PRINT_PREMIUM", request.getParameter("printPremium"));											
				}else if ("PACK_POLICY_DOCUMENT_MAIN".equals(reportName)){					
					System.out.println("Package Policy Document");
					String version = reportsService.getReportVersion(reportId);
					reportName += (version != null && version != "" ? "_" + version : "");
					params.put("EXTRACT_ID", extractId);
					params.put("REPORT_ID", reportId);
					params.put("PREM_DET", "Y");
					params.put("P_ABBREVIATION", request.getParameter("abbreviation") == null || request.getParameter("abbreviation").isEmpty() ? "N" : request.getParameter("abbreviation"));
					params.put("DRAFT", isDraft);
					params.put("P_FONT_SW", reportFont);
					params.put("P_PRINT_PREMIUM", request.getParameter("printPremium")); //marco - 11.20.2012 - added parameter
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_POLDOC_PK");
				}else if ("GIPIR913".equals(reportId) || "GIPIR913A".equals(reportId) || "GIPIR025".equals(reportId) || "GIPIR913C".equals(reportId) || "GIPIR913D".equals(reportId)) { //belle 01.26.2012
					String version = reportsService.getReportVersion(reportId, lineCd);
					reportName = reportId + (version != null ? "_" + version : ""); 
					params.put("P_POLICY_ID", policyId); // P_POLICY_ID parameter should be integer
					//params.put("EXTRACT_ID", extractId);
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_PRINT_DATE", df.format(new Date()));
					params.put("REPORT_ID", reportId);
					params.put("DRAFT", isDraft);
					params.put("P_FONT_SW", reportFont); 
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
				}else if("GIRIR009".equals(reportId)){					
					String version = reportsService.getReportVersion(reportId, lineCd);					
					reportName = reportId + (version != null ? "_" + version : ""); 
					params.put("P_POLICY_ID", policyId); // P_POLICY_ID parameter should be integer
					//params.put("EXTRACT_ID", extractId);
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_PRINT_DATE", df.format(new Date()));
					params.put("REPORT_ID", reportId);
					params.put("DRAFT", isDraft);
					params.put("P_FONT_SW", reportFont); 
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");					
				}else if ("GIPIR913B".equals(reportId) || "GIRIR009A".equals(reportId)) {					
					String version = reportsService.getReportVersion(reportId);
					reportName = reportId + (version != null ? "_" + version : "");					
					params.put("P_POLICY_ID", policyId); // P_POLICY_ID parameter should be integer
					params.put("EXTRACT_ID", extractId);
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_PRINT_DATE", df.format(new Date()));
					params.put("REPORT_ID", reportId);
					params.put("DRAFT", isDraft);
					params.put("P_FONT_SW", reportFont); 
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
				} else if ("GIPIR914".equals(reportId) || "GIPIR915".equals(reportId)){
					String version = reportsService.getReportVersion(reportId);
					reportName = reportId + (version != null ? "_" + version : ""); 
					params.put("P_POLICY_ID", policyId); // P_POLICY_ID parameter must be integer
					params.put("REPORT_ID", reportId);
					params.put("DRAFT", isDraft);
					params.put("P_FONT_SW", reportFont);

					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");

					Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
					params.put("P_ITEM_NO", itemNo);
					System.out.println("COC Report Params "+itemNo+"::: "+params);
				} else if("GIPIR049".equals(reportId) || "GIPIR049A".equals(reportId)){
					reportName = reportId;
					params.put("P_POLICY_ID", policyId);
					subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+PolicyReportsPropertiesUtil.otherReportsLocation)+"/";
				} else if("GIPIR152".equals(reportId)){ // added by pjd 10.22.13 for bonds renewal
					String version = reportsService.getReportVersion(reportId, lineCd);	
					//reportName = reportId + (version != null ? "_" + version : ""); 
					reportName = reportId + (version == null || version.equals("CPI") ? "" : "_" + version); 
					params.put("P_POLICY_ID", policyId); 
					params.put("REPORT_ID", reportId);
					params.put("P_EXTRACT_ID", extractId);
					System.out.println("P_EXTRACT_ID:::::::::::::: "+ extractId);
					System.out.println("reportName: "+reportName);
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = (version == null || version.equals("CPI") ? getServletContext().getRealPath("WEB-INF/classes/"+PolicyReportsPropertiesUtil.otherReportsLocation)+"/" :  giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW"));
					//subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+PolicyReportsPropertiesUtil.otherReportsLocation)+"/";
				} else if ("GIPIR153".equals(reportId)) { 
					params.put("P_POLICY_ID", policyId); 
					params.put("P_USER_ID", USER.getUserId());
					params.put("P_PRINT_DATE", df.format(new Date()));
					params.put("DRAFT", isDraft);					 
					params.put("EXTRACT_ID", extractId);
					params.put("REPORT_ID", reportId);
					params.put("P_FONT_SW", reportFont);
					reportName = reportId;
					GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
					subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
				}
				/********** End of Report Query Parameter ********/
				
				System.out.println("isDraft: "+isDraft);
				params.put("P_DRAFT", 				 	isDraft);
				params.put("MAIN_REPORT", 			 	reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", 	policyRepUtil.getTargetFilename(reportId)+extractId);
				params.put("reportTitle", 				request.getParameter("reportTitle"));
				params.put("reportName", 				reportName);
				params.put("P_DESTINATION",             request.getParameter("destination")); //Added by pjsantos 01/17/2017, GENQA 5904
				System.out.println("Complete Print Params: "+params);
				
				this.doPrintReport(request, response, params, subreportDir);
				
				PAGE = "/pages/genericMessage.jsp";				
			}else if("printCoverNote".equals(ACTION)){
				PolicyReportsPropertiesUtil policyRepUtil = new PolicyReportsPropertiesUtil();
				ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
				client =  (DataSourceTransactionManager) appContext.getBean("transactionManager");
				Integer parId = Integer.parseInt(request.getParameter("globalParId")== ""? null : request.getParameter("globalParId"));
				Integer noOfDays = Integer.parseInt(request.getParameter("noOfDays")== ""? "0" : request.getParameter("noOfDays"));
				String reportId = request.getParameter("reportId");
				String reportName = policyRepUtil.getReportName(reportId);
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+PolicyReportsPropertiesUtil.otherReportsLocation)+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_PAR_ID", parId);
				params.put("P_DAYS", noOfDays);
				params.put("MAIN_REPORT", 			 	reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", 	policyRepUtil.getTargetFilename(reportId)+parId);
				params.put("reportTitle", 				request.getParameter("reportTitle"));
				params.put("reportName", 				reportName);
				
				this.doPrintReport(request, response, params, subreportDir);			
				
				PAGE = "/pages/genericMessage.jsp";	
			}else if("printBatchCoverNote".equals(ACTION)){
				PolicyReportsPropertiesUtil policyRepUtil = new PolicyReportsPropertiesUtil();
				ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
				Integer parId = Integer.parseInt(request.getParameter("parId"));
				String reportId = request.getParameter("reportId");
				String reportName = policyRepUtil.getReportName(reportId);
				String subreportDir = getServletContext().getRealPath("WEB-INF/classes/"+PolicyReportsPropertiesUtil.otherReportsLocation)+"/";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("P_PAR_ID", parId);
				params.put("MAIN_REPORT", 			 	reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", 	policyRepUtil.getTargetFilename(reportId)+parId);
				params.put("reportTitle", 				request.getParameter("reportTitle"));
				params.put("reportName", 				reportName);
				
				this.doPrintReport(request, response, params, subreportDir);			
				
				PAGE = "/pages/genericMessage.jsp";	
			}else {
				log.info("Initializing " + this.getClass().getSimpleName());
				ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
				client =  (DataSourceTransactionManager) appContext.getBean("transactionManager");
				ApplicationWideParameters reportParam =  (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams"); // nica 12.02.2010
				
				PolicyReportGenerator polReportGenerator = new PolicyReportGenerator();
				int parId = Integer.parseInt(request.getParameter("parId"));
				String lineName = request.getParameter("lineName");
				String reportFont = reportParam.getDefaultReportFont();
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("DRAFT", "preview".equals(ACTION) ? new Integer(1) : new Integer(0));
				params.put("EXTRACT_ID", new Integer(200));
				params.put("REPORT_ID", lineName.replace(" ", "")); //
				params.put("SUBREPORT_DIR", getServletContext().getRealPath("WEB-INF/classes/"+PolicyReportsPropertiesUtil.reportsLocation)+"/");
				params.put("MAIN_REPORT", "POLICY_DOCUMENT_MAIN.jasper");
				params.put("OUTPUT_REPORT_FILENAME", new Integer(200));
				params.put("GENERATED_REPORT_DIR", getServletContext().getInitParameter("GENERATED_POLICY_REPORTS_DIR"));
				params.put("CONNECTION", client.getDataSource().getConnection());
				// nica 12.01.2010 -- added parameter P_FONT_SW to designate font for the report
				params.put("P_FONT_SW", reportFont);
				
				if (polReportGenerator.generateReport(params)) {
					String filePath = params.get("GENERATED_REPORT_DIR").toString() + 200+".pdf";
					//FileInputStream fis = new FileInputStream(filePath);
					fis = new FileInputStream(filePath);
					byte[] pdfByte = new byte[fis.available()];
					fis.read(pdfByte);
					//fis.close();
					if (null==pdfByte) {
						throw new EmptyFileReadException("Failed to generate policy report because the file is empty...");
					} else {
						File newFile = File.createTempFile("quotation", ".pdf");
						//FileOutputStream os = new FileOutputStream(newFile);
						os = new FileOutputStream(newFile);
						System.out.println("byte size:" + pdfByte.length);
						os.write(pdfByte);
						os.flush();
						//os.close();
						//ServletOutputStream out = response.getOutputStream();
						out = response.getOutputStream();
						response.setContentType("application/pdf");
						ByteArrayInputStream bais = new ByteArrayInputStream(pdfByte);
						int i = 0;
						while ((i = bais.read()) != -1){
							out.write(i);
						}
						out.flush();
						//out.close();
					}
				}
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (EmptyFileReadException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} finally {
			if(fis != null){
				fis.close();	
			}
			if(os != null){
				os.close();			
			}
			if(out != null){
				out.close();
			}
		}
	}
	
	/**
	 * 
	 * @param params
	 * @param request
	 * @return
	 */
	private Map<String, Object> addNotaryParametersToMap(Map<String, Object> params, HttpServletRequest request){
		params.put("P_DOC_NO", request.getParameter("docNo"));
		params.put("P_PAGE_NO", request.getParameter("pageNo"));
		params.put("P_BOOK_NO", request.getParameter("bookNo"));
		params.put("P_SERIES", request.getParameter("series"));
		
		return params;
	}
	
}
