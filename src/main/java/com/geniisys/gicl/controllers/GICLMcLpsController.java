package com.geniisys.gicl.controllers;

import java.io.IOException;

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
import com.geniisys.gicl.service.GICLMcLpsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLMcLpsController", urlPatterns={"/GICLMcLpsController"})
public class GICLMcLpsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLMcLpsService giclMcLpsService = (GICLMcLpsService) APPLICATION_CONTEXT.getBean("giclMcLpsService");
		
		try {
			
			if("showGicls171".equals(ACTION)) {
				JSONObject json = giclMcLpsService.showGicls171(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonLossExp", json);
					PAGE = "/pages/claims/tableMaintenance/motorCarLaborPointSystem/motorCarLaborPointSystem.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("saveGicls171".equals(ACTION)) {
				message = "SUCCESS";
				giclMcLpsService.saveGicls171(request, USER.getUserId());
			} else if("showGicls171LpsHistory".equals(ACTION)){
				JSONObject json = giclMcLpsService.getGicls171LpsHistory(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonLpsHistory", json);
					PAGE = "/pages/claims/tableMaintenance/motorCarLaborPointSystem/LpsHistory.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
			
		} /*catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}*/ catch (NullPointerException e) {
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
