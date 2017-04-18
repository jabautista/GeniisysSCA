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
import com.geniisys.giac.service.GIACChartOfAcctsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACChartOfAcctsController", urlPatterns={"/GIACChartOfAcctsController"})
public class GIACChartOfAcctsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACChartOfAcctsService giacChartOfAcctsService = (GIACChartOfAcctsService) APPLICATION_CONTEXT.getBean("giacChartOfAcctsService");
		
		try {
			if("showGiacs311".equals(ACTION)){
				JSONObject json = giacChartOfAcctsService.showGiacs311(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonChartOfAcctsList", json);
					PAGE = "/pages/accounting/maintenance/chartOfAccounts/chartOfAccounts.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valUpdateRec".equals(ACTION)){
				giacChartOfAcctsService.valUpdateRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giacChartOfAcctsService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if ("valDelRec".equals(ACTION)){
				giacChartOfAcctsService.valDelRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";						
			} else if ("saveGiacs311".equals(ACTION)) {
				giacChartOfAcctsService.saveGiacs311(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGiacs311AddLevel".equals(ACTION)) {
				request.setAttribute("level", request.getParameter("level"));
				request.setAttribute("glAcctId", request.getParameter("glAcctId"));
				JSONObject json = giacChartOfAcctsService.getChildRecList(request, USER.getUserId());
				request.setAttribute("jsonChildRecList", json);
				PAGE = "/pages/accounting/maintenance/chartOfAccounts/subPages/addLevel.jsp";
			} else if ("getChildRecList".equals(ACTION)) {
				JSONObject json = giacChartOfAcctsService.getChildRecList(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getGlMotherAcct".equals(ACTION)) {
				message = giacChartOfAcctsService.getGlMotherAcct(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getIncrementedLevel".equals(ACTION)) {
				message = giacChartOfAcctsService.getIncrementedLevel(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getChildChartOfAccts".equals(ACTION)) {
				message = (new JSONObject(giacChartOfAcctsService.getChildChartOfAccts(request, USER.getUserId()))).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkUserFunction".equals(ACTION)) {
				message = giacChartOfAcctsService.checkGiacs311UserFunction(request, USER.getUserId());
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
