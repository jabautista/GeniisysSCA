package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.service.COCAuthenticationService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="COCAuthenticationController", urlPatterns={"/COCAuthenticationController"})
public class COCAuthenticationController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2949944304127863879L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		String page = "/pages/genericMessage.jsp";
		
		try {
			if("registerCOCs".equals(ACTION)){
				COCAuthenticationService cocAuthenticationService = (COCAuthenticationService) APPLICATION_CONTEXT.getBean("cocAuthenticationService");
				Boolean result = cocAuthenticationService.registerCOCs(request, USER, (String) APPLICATION_CONTEXT.getBean("cocafAddress"));
				
				message = result.toString();
			}			
		} catch (BeansException e) {
			message = ExceptionHandler.handleException(e); 
			page = "/pages/genericMessage.jsp";
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e);
			}
			page = "/pages/genericMessage.jsp";
		} catch (InvocationTargetException e) {
			message = "There was a problem in accessing the service, authentication cannot continue."; 
			page = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e); 
			page = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.getServletContext().getRequestDispatcher(page).forward(request, response);	
		}
	}

}
