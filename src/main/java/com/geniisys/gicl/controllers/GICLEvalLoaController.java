/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.controllers
	File Name: GICLEvalLoaController.java
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
import com.geniisys.gicl.service.GICLEvalLoaService;
import com.seer.framework.util.ApplicationContextReader;
@WebServlet(name="GICLEvalLoaController", urlPatterns={"/GICLEvalLoaController"})
public class GICLEvalLoaController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -5869881571478017649L;
	private static Logger log = Logger.getLogger(GICLEvalLoaController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
			log.info("INITIALIZING "+GICLEvalLoaController.class.getSimpleName());
			ApplicationContext APPLICATION_CONTEXT= ApplicationContextReader.getServletContext(getServletContext());
			GICLEvalLoaService giclEvalLoaService = (GICLEvalLoaService) APPLICATION_CONTEXT.getBean("giclEvalLoaService");
		try{
			PAGE = "/pages/genericMessage.jsp";
			
			if ("getMcEvalLoaTGLst".equals(ACTION)) {
				giclEvalLoaService.getMcEvalLoaTGLst(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/mcEvaluationLoaTGListing.jsp";
				}
			}else if ("getMcEvalLoaDtlTGList".equals(ACTION)) {
				giclEvalLoaService.getMcEvalLoaDtlTGList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/mcEvaluationReport/overlay/mcEvaluationLoaDtlTGListing.jsp";
				}
			}else if ("generateLoa".equals(ACTION)) {
				giclEvalLoaService.generateLoa(request, USER);
				message ="SUCCESS";
			}else if("generateLoaFromLossExp".equals(ACTION)){
				message = giclEvalLoaService.generateLoaFromLossExp(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
