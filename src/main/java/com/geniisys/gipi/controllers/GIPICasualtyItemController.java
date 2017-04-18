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
import com.geniisys.gipi.entity.GIPICasualtyItem;
import com.geniisys.gipi.service.GIPICasualtyItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPICasualtyItemController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPICasualtyItemController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPICasualtyItemService gipiCasualtyItemService = (GIPICasualtyItemService) APPLICATION_CONTEXT.getBean("gipiCasualtyItemService");
			
			if("getCasualtyItemInfo".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
				GIPICasualtyItem gipiCasualtyItemInfo = gipiCasualtyItemService.getCasualtyItemInfo(params);
				
				if(gipiCasualtyItemInfo != null){
					request.setAttribute("gipiCasualtyItemInfo", new JSONObject(StringFormatter.escapeHTMLInObject(gipiCasualtyItemInfo)));
				}else{
					gipiCasualtyItemInfo = new GIPICasualtyItem();
					request.setAttribute("gipiCasualtyItemInfo", new JSONObject(gipiCasualtyItemInfo));
				}
				request.setAttribute("caItem", new JSONObject());
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/casualtyItemAddtlInfoOverlay.jsp";
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
