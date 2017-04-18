package com.geniisys.gipi.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIMainCoIns;
import com.geniisys.gipi.service.GIPIMainCoInsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIMainCoInsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIMainCoInsController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIMainCoInsService gipiMainCoInsService = (GIPIMainCoInsService) APPLICATION_CONTEXT.getBean("gipiMainCoInsService");
			
			if("getPolicyMainCoInsurer".equals(ACTION)){
				
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				System.out.println(policyId +"hahahahahahahaha");
				GIPIMainCoIns policyMainCoIns = gipiMainCoInsService.getPolicyMainCoIns(policyId);

				if(policyMainCoIns != null){
					request.setAttribute("policyMainCoIns", new JSONObject(StringFormatter.escapeHTMLInObject(policyMainCoIns)));
				}else{
					request.setAttribute("policyMainCoIns", new JSONObject());
				}
				
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyCoInsurers.jsp";
				
			}
		}catch (NullPointerException e) {
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
