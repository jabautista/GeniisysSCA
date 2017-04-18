/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: GICLEvalCslController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 2, 2012
	Description: 
*/


package com.geniisys.gicl.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLEvalCslService;
import com.seer.framework.util.ApplicationContextReader;
@WebServlet(name="GICLEvalCslController", urlPatterns={"/GICLEvalCslController"})
public class GICLEvalCslController extends BaseController{
	private static final long serialVersionUID = 6515163305257997272L;
	private static Logger log = Logger.getLogger(GICLEvalCslController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("INITIALIZING "+GICLEvalCslController.class.getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLEvalCslService giclEvalCslService = (GICLEvalCslService) APPLICATION_CONTEXT.getBean("giclEvalCslService");
		PAGE = "/pages/genericMessage.jsp";
		
		try{
			if ("getMcEvalCslTGList".equals(ACTION)) {
				giclEvalCslService.getMcEvalCslTGList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/mcEvaluationCslTGListing.jsp";
				}
			}else if("getMcEvalCslDtlTGList".equals(ACTION)){
				giclEvalCslService.getMcEvalCslDtlTGList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/mcEvaluationCslDtlTGListing.jsp";
				}
			}else if ("generateCsl".equals(ACTION)) {
				giclEvalCslService.generateCsl(request, USER);
				message="SUCCESS";
			}else if("generateCslFromLossExp".equals(ACTION)){
				message = giclEvalCslService.generateCslFromLossExp(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
