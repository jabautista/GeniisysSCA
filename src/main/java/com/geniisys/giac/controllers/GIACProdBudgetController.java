package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;

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
import com.geniisys.giac.service.GIACProdBudgetService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACProdBudgetController", urlPatterns={"/GIACProdBudgetController"})
public class GIACProdBudgetController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACProdBudgetService giacProdBudgetService = (GIACProdBudgetService) APPLICATION_CONTEXT.getBean("prodBudgetService");
		
		try {
			if("showGiacs360".equals(ACTION)){
				JSONObject jsonYear = giacProdBudgetService.getGiacs360YearMonth(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					JSONObject json = giacProdBudgetService.showGiacs360(request, USER.getUserId());
					request.setAttribute("jsonBudgetList", json);
					request.setAttribute("jsonBudgetYearList", jsonYear);
					PAGE = "/pages/accounting/generalLedger/report/budgetModule/budgetMaintenance/budgetMaintenance.jsp";
				} else {
					message = jsonYear.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getBudgetRecList".equals(ACTION)){
				JSONObject json = giacProdBudgetService.showGiacs360(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("valDeleteRec".equals(ACTION)){
				giacProdBudgetService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giacProdBudgetService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";		
			} else if ("valAddYearRec".equals(ACTION)){
				giacProdBudgetService.valAddYearRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";					
			} else if ("saveGiacs360".equals(ACTION)) {
				giacProdBudgetService.saveGiacs360(request, USER.getUserId());
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
