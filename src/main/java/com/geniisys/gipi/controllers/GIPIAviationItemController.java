package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;

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
import com.geniisys.gipi.entity.GIPIAviationItem;
import com.geniisys.gipi.service.GIPIAviationItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIAviationItemController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIAviationItemController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		log.info("doProcessing");
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIAviationItemService gipiAviationItemService = (GIPIAviationItemService) APPLICATION_CONTEXT.getBean("gipiAviationItemService");
			
			if("getAviationItemInfo".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
				GIPIAviationItem aviationItemInfo = gipiAviationItemService.getAviationItemInfo(params);
				if(aviationItemInfo != null){
					//request.setAttribute("aviationItemInfo", new JSONObject(aviationItemInfo)); // replaced by: Nica 04.25.2013
					request.setAttribute("aviationItemInfo", new JSONObject(StringFormatter.escapeHTMLInObject(aviationItemInfo)));
				}else{
					aviationItemInfo = new GIPIAviationItem();
					request.setAttribute("aviationItemInfo", new JSONObject());
				}
				request.setAttribute("avItem", new JSONObject());
				PAGE="/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/aviationItemAddtlInfoOverlay.jsp";
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
