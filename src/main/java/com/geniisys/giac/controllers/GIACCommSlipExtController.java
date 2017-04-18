package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACCommSlipExtService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACCommSlipExtController", urlPatterns={"/GIACCommSlipExtController"})
public class GIACCommSlipExtController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACCommSlipExtService giacCommSlipExtService = (GIACCommSlipExtService) APPLICATION_CONTEXT.getBean("giacCommSlipExtService");
		
		try {
			if("showGIACS250".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				giacCommSlipExtService.getBatchCommSlip(request);
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/batchCommSlipPrinting/batchCommSlipPrinting.jsp";
			}else if("getBatchCommSlip".equals(ACTION)){
				JSONObject json = giacCommSlipExtService.getBatchCommSlip(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCommSlipNo".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacCommSlipExtService.getCommSlipNo(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			}else if("tagAll".equals(ACTION)){
				giacCommSlipExtService.tagAll(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("untagAll".equals(ACTION)){
				giacCommSlipExtService.untagAll();
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateCommSlipNo".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacCommSlipExtService.generateCommSlipNo(request)));
				PAGE = "/pages/genericObject.jsp";
			}else if("saveGenerateFlag".equals(ACTION)){
				giacCommSlipExtService.saveGenerateFlag(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBatchCommSlipReports".equals(ACTION)){
				request.setAttribute("object", new JSONArray(giacCommSlipExtService.getBatchCommSlipReports()));
				PAGE = "/pages/genericObject.jsp";
			}else if("updateCommSlip".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacCommSlipExtService.updateCommSlip(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			}else if("clearCommSlipNo".equals(ACTION)){
				giacCommSlipExtService.clearCommSlipNo(request);
				message = "SUCCESS";
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
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
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
