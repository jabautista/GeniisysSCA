package com.geniisys.gipi.controllers;

import java.io.IOException;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.gipi.service.GIPIRiskLossProfileService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIPIRiskLossProfileController", urlPatterns={"/GIPIRiskLossProfileController"})
public class GIPIRiskLossProfileController extends BaseController{

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		try {
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			GIPIRiskLossProfileService gipiRiskLossProfileService = (GIPIRiskLossProfileService) APPLICATION_CONTEXT.getBean("gipiRiskLossProfileService");
			
			if("showGIPIS902".equals(ACTION)){
				JSONObject json = gipiRiskLossProfileService.getGipiRiskLossProfile(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){					
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{					
					PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);					
					request.setAttribute("printers", printers);
					
					request.setAttribute("jsonGipiRiskLossProfile", json);
					PAGE = "/pages/underwriting/reportsPrinting/riskAndLossProfile/riskAndLossProfile.jsp";					
				}				
			} else if ("getGipiRiskLossProfileRange".equals(ACTION)) {
				JSONObject json = gipiRiskLossProfileService.getGipiRiskLossProfileRange(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGIPIS902".equals(ACTION)){
				gipiRiskLossProfileService.saveGIPIS902(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("extractGIPIS902".equals(ACTION)) {
				gipiRiskLossProfileService.extractGIPIS902(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch(Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
