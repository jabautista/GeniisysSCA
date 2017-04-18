package com.geniisys.giuts.controllers;

import java.io.IOException;
import java.sql.SQLException;
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

import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISReports;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giuts.service.BatchPrintingService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="BatchPrintingController", urlPatterns="/BatchPrintingController")
public class BatchPrintingController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1749272928373874018L;

	private PrintServiceLookup printServiceLookup;
	
	@SuppressWarnings("static-access")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		BatchPrintingService batchPrintingService = (BatchPrintingService) APPLICATION_CONTEXT.getBean("batchPrintingService");
		
		try {
			if("showBatchPrinting".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				List<GIISReports> docTypeList = batchPrintingService.getDocTypeList();
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut = batchPrintingService.initializVariable(paramsOut);
				request.setAttribute("docTypeList", docTypeList);
				request.setAttribute("paramsOut", paramsOut);
				request.setAttribute("allUserSw", USER.getAllUserSw());
				request.setAttribute("currentUser", USER.getUserId());
				PAGE = "/pages/underwriting/reportsPrinting/batchPrinting/batchPrinting.jsp";
			}else if("getPolicyEndtId".equals(ACTION)) {
				message = new JSONArray(batchPrintingService.getPolicyEndtId(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";			
			}else if("deleteExtractTables".equals(ACTION)) {
				batchPrintingService.deleteExtractTables(Integer.parseInt(request.getParameter("extractId")));
			}else if("updatePolRec".equals(ACTION)) {
				batchPrintingService.updatePolRec(Integer.parseInt(request.getParameter("policyId")));
			}else if("extractPolDocRec".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				message = batchPrintingService.extractPolDocRec(params);
				PAGE = "/pages/genericMessage.jsp";	
			}else if("getBatchBinderId".equals(ACTION)) {
				message = new JSONArray(batchPrintingService.getBatchBinderId(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";			
			}else if("updateBinderRec".equals(ACTION)) {
				batchPrintingService.updateBinderRec(Integer.parseInt(request.getParameter("binderId")));
			}else if("getBatchCoverNote".equals(ACTION)) {
				message = new JSONArray(batchPrintingService.getBatchCoverNote(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";			
			}else if("updateCoverNoteRec".equals(ACTION)) {
				batchPrintingService.updateCoverNoteRec(Integer.parseInt(request.getParameter("parId")));
			}else if("getBatchCoc".equals(ACTION)) {
				message = new JSONArray(batchPrintingService.getBatchCoc(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";			
			}else if("updateCocRec".equals(ACTION)) {
				batchPrintingService.updateCocRec(Integer.parseInt(request.getParameter("policyId")));
			}else if("getBatchInvoice".equals(ACTION)) {
				message = new JSONArray(batchPrintingService.getBatchInvoice(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";			
			}else if("updateInvoiceRec".equals(ACTION)) {
				batchPrintingService.updateInvoiceRec(Integer.parseInt(request.getParameter("policyId")));
			}else if("getBatchRiInvoice".equals(ACTION)) {
				message = new JSONArray(batchPrintingService.getBatchRiInvoice(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";		
			}else if("getBondsRenewalPolId".equals(ACTION)) {
				message = new JSONArray(batchPrintingService.getBondsRenewalPolId(request)).toString();
				PAGE = "/pages/genericMessage.jsp";		
			}else if("getRenewalPolId".equals(ACTION)) {
				message = new JSONArray(batchPrintingService.getRenewalPolId(request)).toString();
				PAGE = "/pages/genericMessage.jsp";		
			}else if("getBondsPolicyPolId".equals(ACTION)) {
				message = new JSONArray(batchPrintingService.getBondsPolicyPolId(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";		
			}
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
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
