package com.geniisys.common.controllers;
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
import com.geniisys.common.service.GIACEomCheckingScriptsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACEomCheckingScriptsController", urlPatterns={"/GIACEomCheckingScriptsController"})
public class GIACEomCheckingScriptsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACEomCheckingScriptsService giacEomCheckingScriptsService = (GIACEomCheckingScriptsService) APPLICATION_CONTEXT.getBean("giacEomCheckingScriptsService");
		
		try {
			if("showGiacs352".equals(ACTION)){
				JSONObject json = giacEomCheckingScriptsService.showGiacs352(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonMonthEndCheckingScriptsList", json);
					PAGE = "/pages/accounting/maintenance/monthEndCheckingScripts/monthEndCheckingScripts.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("saveGiacs352".equals(ACTION)) {
				giacEomCheckingScriptsService.saveGiacs352(request, USER.getUserId());
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
