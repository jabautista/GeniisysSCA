/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.common.controllers
	File Name: GIISPayeesController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 17, 2012
	Description: 
*/


package com.geniisys.common.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISPayeesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIISPayeesController", urlPatterns={"/GIISPayeesController"})
public class GIISPayeesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -379028730774830270L;
	private static Logger log = Logger.getLogger(GIISPayeesController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GIISPayeesController.class.getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISPayeesService giisPayeesService = (GIISPayeesService) APPLICATION_CONTEXT.getBean("giisPayeesService");
		PAGE = "/pages/genericMessage.jsp";
		try{
			if ("getPayeeFullName".equals(ACTION)) {
				message = giisPayeesService.getPayeeFullName(FormInputUtil.getFormInputs(request));
			}
			
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
