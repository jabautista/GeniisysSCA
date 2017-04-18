package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.service.GIPIOrigCommInvPerilService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIPIOrigCommInvPerilController", urlPatterns="/GIPIOrigCommInvPerilController")
public class GIPIOrigCommInvPerilController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIOrigCommInvPerilController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIOrigCommInvPerilService gipiOrigCommInvPeril = (GIPIOrigCommInvPerilService) APPLICATION_CONTEXT.getBean("gipiOrigCommInvPerilService");
			
			if("getCommInvPerils".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemGrp", Integer.parseInt(request.getParameter("itemGrp")));
				params.put("intrmdryIntmNo", Integer.parseInt(request.getParameter("intrmdryIntmNo")));
				params = gipiOrigCommInvPeril.getCommInvPerils(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					
					//request.setAttribute("invCommList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params))); // replaced by: Nica 05.23.2013 
					request.setAttribute("commInvPerilList", new JSONObject((HashMap<String, Object>)StringFormatter.escapeHTMLInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyLeadCommInvPerilsTable.jsp";
						
				}
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
