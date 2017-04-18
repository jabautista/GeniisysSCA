/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.controllers;

import java.io.IOException;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.ContextParameters;
import com.geniisys.framework.util.Mailer;
import com.geniisys.framework.util.PasswordEncoder;
import com.seer.framework.util.ApplicationContextReader;

/**
 * The Class MailController.
 * @author whofeih
 * This is class is not being used anymore but don't delete for reference purposes. Thanks!
 */
public class MailController extends HttpServlet {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 3502075326534679319L;
	
	/** The log. */
	Logger log = Logger.getLogger(MailController.class);

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws
		IOException, ServletException {
		
		String page = "/pages/genericMessage.jsp";
		String action = request.getParameter("action");
		String message = "ERROR - An internal error occured.";
		
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		Mailer mailer = (Mailer) appContext.getBean("mailer");
		GIISUserFacadeService giisUserService = (GIISUserFacadeService) appContext.getBean("giisUserFacadeService");
		
		if ("forgotPassword".equals(action) && (ContextParameters.ENABLE_EMAIL_NOTIFICATION == null || ContextParameters.ENABLE_EMAIL_NOTIFICATION.equals("Y"))) {
			String[] emailAddress = request.getParameterValues("emailAddress");
			String userId = request.getParameter("username");
			String password = "";
			
			log.info("Forgot Password feature is used by " + userId + " with email " + emailAddress[0]);
			try {
				mailer.setEmailSubjectText("Forgot Password Request");
				password = giisUserService.getUserPassword(userId, emailAddress[0]).getPassword();
				mailer.setEmailMsgText("Your password is: <b>" + PasswordEncoder.doDecrypt(password) + "</b>");
				mailer.sendMail(emailAddress);
				message = "SUCCESS - Your password has been sent!";
			} catch (MessagingException e) {
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				message = "Password not sent. Contact administrator.";
				e.printStackTrace();				
			} catch (NullPointerException e) {
				page = "/pages/genericMessage.jsp";
				message = "User record not found. Try again.";
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				e.printStackTrace();
			} catch (Exception e) {
				page = "/pages/genericMessage.jsp";
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				e.printStackTrace();
			}
		}
		this.dispatch(request, response, page, message);
	}
	
	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws
		IOException, ServletException {
		this.doGet(request, response);
	}
	
	/**
	 * Dispatch.
	 * 
	 * @param request the request
	 * @param response the response
	 * @param page the page
	 * @param message the message
	 * @throws IOException Signals that an I/O exception has occurred.
	 * @throws ServletException the servlet exception
	 */
	private void dispatch(HttpServletRequest request, HttpServletResponse response, String page, String message) throws
		IOException, ServletException {
		
		request.setAttribute("message", message);
		getServletContext().getRequestDispatcher(page).forward(request, response);
		
	}
	
}
