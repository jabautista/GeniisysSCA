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
import com.geniisys.giac.service.GIACBudgetService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACBudgetController", urlPatterns={"/GIACBudgetController"})
public class GIACBudgetController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACBudgetService giacBudgetService = (GIACBudgetService) APPLICATION_CONTEXT.getBean("giacBudgetService");
		
		try {
			if("showGiacs510".equals(ACTION)){
				JSONObject json = giacBudgetService.showGIACS510(request);
				if(request.getParameter("refresh") == null) {
					JSONObject jsonGiacBudgetPerYearList = giacBudgetService.showBudgetPerYear(request);
					request.setAttribute("jsonGiacBudgetYearList", json);
					request.setAttribute("jsonGiacBudgetPerYearList", jsonGiacBudgetPerYearList);
					PAGE = "/pages/accounting/generalLedger/report/budgetModule/subsidiaryOfExpenses/subsidiaryOfExpenses.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("showBudgetPerYear".equals(ACTION)){
				JSONObject jsonGiacBudgetPerYearList = giacBudgetService.showBudgetPerYear(request);	
				message = jsonGiacBudgetPerYearList.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddBudgetYear".equals(ACTION)){
				giacBudgetService.valAddBudgetYear(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("copyBudget".equals(ACTION)) {
				giacBudgetService.copyBudget(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGLAcctLOV".equals(ACTION)){
				JSONObject json = giacBudgetService.showGLAcctLOV(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonGLAcctLOV", json);
					PAGE = "/pages/accounting/generalLedger/report/budgetModule/subsidiaryOfExpenses/glAcctNoLovOverlay.jsp";				
				}
				request.setAttribute("year", request.getParameter("year"));
				request.setAttribute("table", request.getParameter("table"));
			} else if ("saveGiacs510".equals(ACTION)) {
				giacBudgetService.saveGiacs510(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteBudgetPerYear".equals(ACTION)){
				giacBudgetService.valDeleteBudgetPerYear(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGLAcctNo".equals(ACTION)){
				message = giacBudgetService.validateGLAcctNo(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showBudgetDtlOverlay".equals(ACTION)){
				JSONObject json = giacBudgetService.showBudgetDtlOverlay(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonGiacBudgetDtl", json);
					PAGE = "/pages/accounting/generalLedger/report/budgetModule/subsidiaryOfExpenses/giacBudgetDtlOverlay.jsp";				
				}
				request.setAttribute("year", request.getParameter("year"));
				request.setAttribute("glAcctId", request.getParameter("glAcctId"));
				request.setAttribute("nbtGlAcctNameMaster", request.getParameter("nbtGlAcctNameMaster"));
			} else if ("saveGIACS510Dtl".equals(ACTION)) {
				giacBudgetService.saveGIACS510Dtl(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkExistBeforeExtractGiacs510".equals(ACTION)){
				message = giacBudgetService.checkExistBeforeExtractGiacs510(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("extractGiacs510".equals(ACTION)){
				message = giacBudgetService.extractGiacs510(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("viewNoDtl".equals(ACTION)){
				JSONObject json = giacBudgetService.viewNoDtl(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonGlAcctNoDtl", json);
					PAGE = "/pages/accounting/generalLedger/report/budgetModule/subsidiaryOfExpenses/glAcctsWoDtlOverlay.jsp";				
				}
				request.setAttribute("year", request.getParameter("year"));
				request.setAttribute("dateBasis", request.getParameter("dateBasis"));
				request.setAttribute("tranFlag", request.getParameter("tranFlag"));
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
