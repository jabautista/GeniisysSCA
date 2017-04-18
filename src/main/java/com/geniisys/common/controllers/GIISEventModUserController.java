package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISEventModUserService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISEventModUserController", urlPatterns={"/GIISEventModUserController"})
public class GIISEventModUserController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2545838607618004883L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			if("validatePassingUser".equals(ACTION)){
				ApplicationContext appContext = (ApplicationContext) ApplicationContextReader.getServletContext(getServletContext());
				GIISEventModUserService giisEventModUserService = (GIISEventModUserService) appContext.getBean("giisEventModUserService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("passingUserId", USER.getUserId());
				params.put("eventCd", request.getParameter("eventCd"));
				params.put("eventType", request.getParameter("eventType"));
				System.out.println(params);
				message = giisEventModUserService.validatePassingUser(params);
				PAGE = "/pages/genericMessage.jsp";				
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}

}
