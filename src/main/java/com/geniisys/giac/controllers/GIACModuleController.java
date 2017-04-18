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
import com.geniisys.giac.service.GIACModulesService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIACModuleController", urlPatterns={"/GIACModuleController"})
public class GIACModuleController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACModulesService giacModulesService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
		
		try {
			if("showGiacs317".equals(ACTION)){
				JSONObject json = giacModulesService.showGiacs317(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonModule", json);
					PAGE = "/pages/accounting/maintenance/accountingSetup/module/module.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				message = giacModulesService.valDeleteRec(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giacModulesService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs317".equals(ACTION)) {
				giacModulesService.saveGiacs317(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGiacs317ScreenRepTag".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacModulesService.validateGiacs317ScreenRepTag(request))));
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
