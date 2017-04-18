package com.geniisys.gipi.controllers;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISInspectorService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.entity.GIPIInspData;
import com.geniisys.gipi.entity.GIPIInspDataWc;
import com.geniisys.gipi.service.GIPIInspDataDtlService;
import com.geniisys.gipi.service.GIPIInspDataService;
import com.geniisys.gipi.service.GIPIInspDataWcService;
import com.geniisys.policydocs.reports.exception.EmptyFileReadException;
import com.geniisys.policydocs.reports.service.PolicyReportGenerator;
import com.geniisys.policydocs.reports.util.PolicyReportsPropertiesUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIInspectionReportController extends BaseController{

	private static final long serialVersionUID = 2249814896135120098L;
	private static Logger log = Logger.getLogger(GIPIInspectionReportController.class);
	
	@SuppressWarnings({ "deprecation", "unused", "unchecked" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
		GIPIInspDataService inspDataService = (GIPIInspDataService) APPLICATION_CONTEXT.getBean("gipiInspDataService");
		GIISParameterFacadeService paramService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		DataSourceTransactionManager client = null;
		

		try {
			if ("showInspectionListing".equals(ACTION)){
				JSONObject json = inspDataService.getGipiInspData1TableGrid2(request);
				request.setAttribute("inspDataTableGrid", json);
				PAGE = "/pages/underwriting/utilities/inspectionReport/inspectionListing.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("refreshInspectionListing".equals(ACTION)){
				JSONObject json = inspDataService.getGipiInspData1TableGrid2(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("showInspectionReport".equals(ACTION)){
				JSONObject inspDataObj = inspDataService.showInspectionReport(request, USER.getUserId());
				request.setAttribute("inspData1", inspDataObj);
				PAGE = "/pages/underwriting/utilities/inspectionReport/inspectionReportMain.jsp";
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("getInspItemInformation".equals(ACTION)){
				Integer inspNo = Integer.parseInt(request.getParameter("inspNo"));
				List<GIPIInspData> inspItemInfoListing = (List<GIPIInspData>) StringFormatter.escapeHTMLInList2(inspDataService.getInspDataItemInfo(inspNo)); //added by steven 10/30/2012 - StringFormatter.escapeHTMLInList2
				
				request.setAttribute("inspItemInfoListing", new JSONArray(inspItemInfoListing));  
				PAGE = "/pages/underwriting/utilities/inspectionReport/subPages/inspectionReportItemInfoTable.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("showCity".equals(ACTION)){
				String[] cityParams = {"", request.getParameter("provinceCd")};
				request.setAttribute("cityListing", helper.getList(LOVHelper.CITY_BY_PROVINCE_LISTING, cityParams));
				request.setAttribute("column", request.getParameter("column"));
				
				PAGE = "/pages/underwriting/utilities/inspectionReport/pop-ups/city.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("showBlock".equals(ACTION)){
				String[] blockParams = {"", request.getParameter("provinceCd"), request.getParameter("cityCd"), request.getParameter("districtNo")};
				request.setAttribute("blockListing",helper.getList(LOVHelper.BLOCK_LISTING, blockParams));
				request.setAttribute("column", request.getParameter("column"));
				PAGE = "/pages/underwriting/utilities/inspectionReport/pop-ups/block.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("openSearchInspector".equals(ACTION)){ //subject to transfer if inspector controller is created
				
				
				PAGE = "/pages/underwriting/utilities/inspectionReport/pop-ups/searchInspector.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("getInspectorListing".equals(ACTION)){
				GIISInspectorService inspectorService = (GIISInspectorService) APPLICATION_CONTEXT.getBean("giisInspectorService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("page", Integer.parseInt(request.getParameter("pageNo")) - 1);
				params.put("keyword", request.getParameter("keyword"));
				PaginatedList inspectorList = inspectorService.getInspectorListing(params);
				
				request.setAttribute("inspDataListing", inspectorList);
				request.setAttribute("pageNo", inspectorList.getPageIndex()+1);
				request.setAttribute("noOfPages", inspectorList.getNoOfPages());
				PAGE = "/pages/underwriting/utilities/inspectionReport/pop-ups/searchInspectorAjaxResult.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("showInspWarrantyAndClauseModal".equals(ACTION)){
				GIPIInspDataWcService wcService = (GIPIInspDataWcService) APPLICATION_CONTEXT.getBean("gipiInspDataWcService");
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				Integer inspNo = Integer.parseInt(request.getParameter("inspNo"));
				String[] args = {"FI"}; //hard-coded for now
				request.setAttribute("currentWc", new JSONArray((List<GIPIInspDataWc>) StringFormatter.escapeHTMLInList(wcService.getGipiInspDataWc(inspNo))));
				
				PAGE = "/pages/underwriting/utilities/inspectionReport/pop-ups/warrantyAndClauses.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("saveInspectionReport".equals(ACTION)){
				inspDataService.saveGipiInspData(request.getParameter("parameters"), USER.getUserId());
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("getBlockId".equals(ACTION)){ //temporary
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("provinceCd", request.getParameter("provinceCd"));
				params.put("cityCd", request.getParameter("cityCd"));
				params.put("districtNo", request.getParameter("districtNo"));
				params.put("blockNo", request.getParameter("blockNo"));
				
				message = inspDataService.getBlockId(params);
				PAGE = "/pages/genericMessage.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("generateInspNo".equals(ACTION)){
		
				message = inspDataService.generateInspNo().toString();
				PAGE = "/pages/genericMessage.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("showOtherDetails".equals(ACTION)){
				Map<String, Object> inspRepParams = new HashMap<String, Object>();
				Map<String, Object> otherParams = new HashMap<String, Object>();
				otherParams.put("inspNo", Integer.parseInt(request.getParameter("inspNo")));
				otherParams.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				inspRepParams.put("ora2010Sw", paramService.getParamValueV2("ORA2010_SW"));
				GIPIInspDataDtlService inspDataDtlService = (GIPIInspDataDtlService) APPLICATION_CONTEXT.getBean("gipiInspDataDtlService");
				
				request.setAttribute("inspDataDtl", inspDataDtlService.getInspDataDtl(Integer.parseInt(request.getParameter("inspNo"))));
				request.setAttribute("inspDataDtl2", inspDataService.getInspOtherDtls(otherParams));
				request.setAttribute("parameters", new JSONObject(inspRepParams));
				PAGE = "/pages/underwriting/utilities/inspectionReport/pop-ups/inspDataOtherDtls.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("showPrintModal".equals(ACTION)) { //block for printing are temporary
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				String inspNo = request.getParameter("inspNo");
				
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != printers.length - 1){
						printerNames = printerNames + ",";
					}
				}
				
				request.setAttribute("inspNo", inspNo);
				request.setAttribute("printerNames", printerNames);
				
				log.info("Printer names : " + printerNames);
				
				PAGE = "/pages/underwriting/utilities/inspectionReport/pop-ups/printInspectionReport.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if("convertInspectionToPAR".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", request.getParameter("parId"));
				params.put("inspNo", request.getParameter("inspNo"));
				params.put("userId", USER.getUserId());
				message = inspDataService.saveInspectionToPAR(params);
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("copyAttachments".equals(ACTION)) {
				GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				
				Map<String, Object> params = new HashMap<String, Object> ();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("parId", request.getParameter("parId"));
				params.put("parNo", request.getParameter("parNo"));
				params.put("inspNo", request.getParameter("inspNo"));
				params.put("mediaPathUW", giisParameterFacadeService.getParamValueV2("MEDIA_PATH_UW"));
				params.put("mediaPathINSP", giisParameterFacadeService.getParamValueV2("MEDIA_PATH_INSP"));
				
				message = inspDataService.copyAttachments(params);
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
			}else if("printInspectionReport".equals(ACTION)){
				log.info("Printing inspection report...");
				
				client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
				ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
				Map<String, Object> params = new HashMap<String, Object>();
				
				String inspNo = request.getParameter("inspNo");
				String printerName = request.getParameter("printerName");
				String reportFont = reportParam.getDefaultReportFont();
				
				String reportId = "GIPIR197";
				String reportVersion = reportsService.getReportVersion(reportId);
				String reportName = StringUtils.isEmpty(reportVersion) ? reportId : reportId+"_"+reportVersion;
				
				String subreportDir = "";
				
				if ("---".equals(printerName) || "".equals(printerName)){
					printerName = "";
				}
				
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				subreportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_UW");
				
				params.put("P_FONT_SW", reportFont);
				params.put("P_USER_NAME", USER.getUsername());
				params.put("P_INSP_NO", Integer.parseInt(inspNo));
				params.put("reportName", reportName);	
				
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", "INSPECTION_REPORT_" + inspNo);
				
				this.doPrintReport(request, response, params, subreportDir);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveWarrAndClauses".equals(ACTION)){
				inspDataService.saveWarrAndClauses(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else if ("saveInspectionInformation".equals(ACTION)){ //added by john 3.21.2016 SR#5470
				inspDataService.saveInspectionInformation(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				this.doDispatch(request, response, PAGE);
			} else {
				log.info("Initializing " + this.getClass().getSimpleName());
				
				ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
				client =  (DataSourceTransactionManager) appContext.getBean("transactionManager");
				ApplicationWideParameters reportParam =  (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams"); // nica 12.02.2010
				
				PolicyReportGenerator polReportGenerator = new PolicyReportGenerator();
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
					String filePath = params.get("GENERATED_UTILITIES_REPORTS_DIR").toString() + 200+".pdf";
					FileInputStream fis = new FileInputStream(filePath);
					byte[] pdfByte = new byte[fis.available()];
					fis.read(pdfByte);
					fis.close();
					if (null==pdfByte) {
						throw new EmptyFileReadException("Failed to generate inspection report because the file is empty...");
					} else {
						File newFile = File.createTempFile("inspection report", ".pdf");
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
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
