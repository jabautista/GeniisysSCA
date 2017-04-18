package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.giac.service.GIACCashReceiptsReportService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIACCashReceiptsReportController", urlPatterns="/GIACCashReceiptsReportController")
public class GIACCashReceiptsReportController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 483005784733734056L;
	
	private PrintServiceLookup printServiceLookup;

	@SuppressWarnings("static-access")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACCashReceiptsReportService giacDailyCollectionRepService = (GIACCashReceiptsReportService) APPLICATION_CONTEXT.getBean("giacCashReceiptsReportService");

			
			

			GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
			

			if ("showDailyCollectionRep".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/reports/dailyCollectionReport/dailyCollectionReport.jsp";
			}else if ("getDailyCollectionRecord".equals(ACTION)){
				message = giacDailyCollectionRepService.getDailyCollectionRecord(request,USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGIACS178".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/reports/directPremiumCollections/directPremiumCollections.jsp";
			
			// GIACS170
			}else if("showAdvancedPremPaytPage".equals(ACTION)){
				PrintService printers[] = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/reports/advancedPremiumPayment/advancedPremiumPayment.jsp";
			}else if("validateGiacs170BranchCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				message = giacBranchService.validateGIACS170BranchCd(params);
				PAGE = "/pages/genericMessage.jsp";
				
			// GIACS117
			}else if("showCashReceiptRegisterPage".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				//System.out.println(printers[0].getName()); //marco - 10.08.2014 - comment out @FGIC - error pag walang printer
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/reports/cashReceiptRegister/cashReceiptRegister.jsp";
			}else if("validateGiacs117BranchCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				message = giacBranchService.validateGIACS117BranchCd(params);
				PAGE = "/pages/genericMessage.jsp";
				
			//GIACS093
			}else if("showPDCRegisterPage".equals(ACTION)){
				PrintService printers[] = PrintServiceLookup.lookupPrintServices(null, null);
				Map<String, Object> params = giacDailyCollectionRepService.getLastExtractParam(USER.getUserId());
				request.setAttribute("lastExtractParams", params);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/reports/pdcRegister/pdcRegister.jsp";
			} else if ("validateGiacs093BranchCd".equals(ACTION)){
				message = giacDailyCollectionRepService.validateGIACS093BranchCd(request.getParameter("branchCd"), USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("populateGiacPdc".equals(ACTION)){
				GIACCashReceiptsReportService giacPdcRegisterService = (GIACCashReceiptsReportService) APPLICATION_CONTEXT.getBean("giacCashReceiptsReportService");
				JSONObject json = giacPdcRegisterService.populateGiacPdc(request, USER.getUserId());
				message = json.toString();
				System.out.println("populateGiacPdc: "+message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateReportId".equals(ACTION)){
				GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				message = giisReportsService.validateReportId(request.getParameter("reportId"));
				PAGE = "/pages/genericMessage.jsp";
				
			//GIACS078
			}else if("showCollectionAnalysisPage".equals(ACTION)){
				PrintService printers[] = PrintServiceLookup.lookupPrintServices(null, null);
				JSONObject json = giacDailyCollectionRepService.getGIACS078InitialValues(USER.getUserId());
				message = json.toString();
				
				if (json.has("dateFrom")){
					request.setAttribute("dateFrom", json.get("dateFrom").equals(null) ? "" : json.get("dateFrom"));
				}
				if(json.has("dateTo")){
					request.setAttribute("dateTo", json.get("dateTo").equals(null) ? "" : json.get("dateTo"));
				}
				if(json.has("branchCd")){
					request.setAttribute("branchCd", json.get("branchCd").equals(null) ? "" : StringFormatter.replaceQuotes(json.get("branchCd").toString()));
				}
				if(json.has("intmNo")){
					request.setAttribute("intmNo", json.get("intmNo").equals(null) ? "" : json.get("intmNo"));
				}
				if(json.has("branchName")){
					request.setAttribute("branchName", json.get("branchName").equals(null) ? "" : StringFormatter.replaceQuotes(json.get("branchName").toString()));
				}
				if(json.has("intmName")){
					request.setAttribute("intmName", json.get("intmName").equals(null) ? "" : StringFormatter.replaceQuotes(json.get("intmName").toString()));
				}
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/reports/collectionAnalysis/collectionAnalysis.jsp";
			}else if ("validateIntmNo".equals(ACTION)){
				Integer intmNo = Integer.parseInt(request.getParameter("intmNo"));
				message = giacDailyCollectionRepService.validateIntmNo(intmNo);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGiacs078BranchCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				message = giacBranchService.validateGIACS078BranchCd(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractGiacs078Records".equals(ACTION)){
				message = giacDailyCollectionRepService.extractGiacs078Records(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if ("countGiacs078ExtractedRecords".equals(ACTION)){
				message = giacDailyCollectionRepService.countGiacs078ExtractedRecords(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("showSchedOfAppliedComm".equals(ACTION)){
				PrintService printers[] = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/reports/schedOfAppliedComm/schedOfAppliedComm.jsp";
			} else if ("showListOfBankDeposits".equals(ACTION)) {
				PrintService printers[] = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/reports/listOfBankDeposits/listOfBankDeposits.jsp";
			} else if ("validateGIACS281BankAcctCd".equals(ACTION)) {
				GIACCashReceiptsReportService service = (GIACCashReceiptsReportService) APPLICATION_CONTEXT.getBean("giacCashReceiptsReportService");
				request.setAttribute("object", service.validateGIACS281BankAcctCd(request));
				//request.setAttribute("object", service.validateGIACS281BankAcctCd(request));
				PAGE = "/pages/genericObject.jsp";
			}
			
			System.out.println("========== " +message);
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
