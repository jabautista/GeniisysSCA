package com.geniisys.giri.pack.controller;

import java.io.IOException;
import java.sql.SQLException;

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
import com.geniisys.giri.pack.service.GIRIPackBinderHdrService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIRIPackBinderHdrController", urlPatterns="/GIRIPackBinderHdrController")
public class GIRIPackBinderHdrController extends BaseController{

	private static Logger log = Logger.getLogger(GIRIPackBinderHdrController.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIRIPackBinderHdrService giriPackBinderHdrService = (GIRIPackBinderHdrService) APPLICATION_CONTEXT.getBean("giriPackBinderHdrService");
			
			if ("showPrintPackageBinder".equals(ACTION)){
				log.info("Getting print package binder page...");
				giriPackBinderHdrService.getGiriPackbinderHdrGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/underwriting/reInsurance/packageBinders/printPackageBinders.jsp";
			}else if("savePackageBinderHdr".equals(ACTION)){
				log.info("Saving package binder header details...");
				message = giriPackBinderHdrService.savePackageBinderHdr(request, USER);
			}
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
