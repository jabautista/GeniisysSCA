package com.geniisys.framework.util;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.geniisys.common.entity.GIISUser;

public class JavascriptErrorLogger extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6642554037589922634L; 
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		message = ExceptionHandler.handleJavascriptException(request.getParameter("functionName"), request.getParameter("description"), USER);
		request.setAttribute("message", message);
		PAGE = "/pages/genericMessage.jsp";
		this.doDispatch(request, response, PAGE);
	}

}
