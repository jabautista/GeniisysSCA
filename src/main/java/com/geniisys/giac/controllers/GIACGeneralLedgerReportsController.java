package com.geniisys.giac.controllers;

import java.io.File;
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
import com.geniisys.giac.service.GIACGeneralLedgerReportService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACGeneralLedgerReportsController", urlPatterns="/GIACGeneralLedgerReportsController")
public class GIACGeneralLedgerReportsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private PrintServiceLookup printServiceLookup;

	@SuppressWarnings("static-access")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACGeneralLedgerReportService giacGeneralLedgerReportService = (GIACGeneralLedgerReportService) APPLICATION_CONTEXT.getBean("giacGeneralLedgerReportService");
			
			if("showGIACS127".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalLedger/report/jvRegister.jsp";
			}else if("showMonthlyTrialBalance".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalLedger/report/trialBalance/monthlyTrialBalance/monthlyTrialBalance.jsp";
			}else if("showGIACS108".equals(ACTION)){
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalLedger/report/evat.jsp";
			}else if ("showGIACS060".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalLedger/report/printGLTransactions.jsp";
			}else if ("showGIACS342".equals(ACTION)) { //added by jet 11.23.2015 AP/AR Enhancement
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalLedger/report/printOutstandingApArAccounts/printOutstandingApArAccounts.jsp";
			}else if("showGIACS110".equals(ACTION)){
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalLedger/report/taxesWithheldFromPayees.jsp";
			} else if("extractGiacs501".equals(ACTION)){
				message = giacGeneralLedgerReportService.extractGiacs501(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateReportId".equals(ACTION)){
				GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				message = giisReportsService.validateReportId(request.getParameter("reportId"));
				PAGE = "/pages/genericMessage.jsp";
			} else if("showTrialBalancePerSL".equals(ACTION)){
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				Map<String, Object> params = giacGeneralLedgerReportService.getGiacs503NewFormInstance();
				request.setAttribute("printers", printers);
				request.setAttribute("params", params != null ? new JSONObject(params) : new JSONObject());
				PAGE = "/pages/accounting/generalLedger/report/trialBalance/trialBalancePerSL.jsp";
			} else if("postSLForGiacs503".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("year", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
				params.put("month", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
				params.put("firstPostingDate", (request.getParameter("firstPostingDate") != null && !request.getParameter("firstPostingDate").equals("")) ? Integer.parseInt(request.getParameter("firstPostingDate")) : null);
				params.put("message", "");
				params = giacGeneralLedgerReportService.postGiacs503SL(params);
				JSONObject json = params != null ? new JSONObject(params) : new JSONObject();
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGiacs503BeforePrint".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("year", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
				params.put("month", (request.getParameter("month") != null && !request.getParameter("month").equals("")) ? Integer.parseInt(request.getParameter("month")) : null);
				Integer glAcctId = giacGeneralLedgerReportService.validateGiacs503BeforePrint(params);
				message = glAcctId != null ? glAcctId.toString() : null;
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePayeeCdGiacs110".equals(ACTION)){
				message = giacGeneralLedgerReportService.validatePayeeCdGiacs110(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateTaxCdGiacs110".equals(ACTION)){
				message = giacGeneralLedgerReportService.validateTaxCdGiacs110(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePayeeNoGiacs110".equals(ACTION)){
				message = giacGeneralLedgerReportService.validatePayeeNoGiacs110(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("showTrialBalanceAsOf".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalLedger/report/trialBalance/trialBalanceAsOf/trialBalanceAsOf.jsp";
			} else if("extractMotherAccounts".equals(ACTION)){
				message = giacGeneralLedgerReportService.extractMotherAccounts(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("extractMotherAccountsDetail".equals(ACTION)){
				message = giacGeneralLedgerReportService.extractMotherAccountsDetail(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGIACS115".equals(ACTION)){
				JSONObject jsonBIRAlphalist = giacGeneralLedgerReportService.showBIRAlphalist(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonBIRAlphalist.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonBIRAlphalist", jsonBIRAlphalist);
					PAGE = "/pages/accounting/generalLedger/report/birAlphalist.jsp";
				}
			}else if("checkExtractGIACS115".equals(ACTION)){
				message = giacGeneralLedgerReportService.checkExtractGIACS115(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractGIACS115".equals(ACTION)){
				message = giacGeneralLedgerReportService.extractGIACS115(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateCSVGIACS115".equals(ACTION)){
				message = giacGeneralLedgerReportService.generateCSVGIACS115(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("deleteFile".equals(ACTION)){
				String realPath = request.getSession().getServletContext().getRealPath("");
				String url = request.getParameter("url");
				String fileName = url.substring(url.lastIndexOf("/")+1, url.length());
				(new File(realPath + "\\bir_temp\\" + fileName)).delete();
			}
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
