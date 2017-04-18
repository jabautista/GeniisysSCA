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
import com.geniisys.common.service.GIISNationalityService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISNationalityController", urlPatterns={"/GIISNationalityController"})
public class GIISNationalityController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISNationalityService giisNationalityService = (GIISNationalityService) APPLICATION_CONTEXT.getBean("giisNationalityService");
		
		try {
			if("showGicls184".equals(ACTION)){
				JSONObject json = giisNationalityService.showGicls184(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonNationalityList", json);
					PAGE = "/pages/claims/tableMaintenance/nationality/nationality.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				giisNationalityService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisNationalityService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGicls184".equals(ACTION)) {
				giisNationalityService.saveGicls184(request, USER.getUserId());
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
