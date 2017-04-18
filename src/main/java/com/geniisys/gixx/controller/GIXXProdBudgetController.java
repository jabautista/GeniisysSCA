package com.geniisys.gixx.controller;

import java.io.IOException;
import java.sql.SQLException;

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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gixx.service.GIXXProdBudgetService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIXXProdBudgetController", urlPatterns={"/GIXXProdBudgetController"})
public class GIXXProdBudgetController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIXXProdBudgetService gixxProdBudgetService = (GIXXProdBudgetService) APPLICATION_CONTEXT.getBean("gixxProdBudgetService");
		
		try {
			if("showBudgetProduction".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalLedger/report/budgetModule/budgetProduction/budgetProduction.jsp";
			}else if("extractBudgetProduction".equals(ACTION)){
				request.setAttribute("object", new JSONObject(gixxProdBudgetService.extractBudgetProduction(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
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
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
