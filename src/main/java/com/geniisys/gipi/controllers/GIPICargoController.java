package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
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
import com.geniisys.gipi.entity.GIPICargo;
import com.geniisys.gipi.service.GIPICargoService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPICargoController extends BaseController{
	
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIVehicleController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPICargoService gipiCargoService = (GIPICargoService) APPLICATION_CONTEXT.getBean("gipiCargoService");
			
			if("getCargoInfo".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				gipiCargoService.getCargoInfo(params,request); //edited by MarkS 5.11.2016 SR-22217
				request.setAttribute("mnItem", new JSONObject());//move codes to gipicargoserviceimpl
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/cargoItemAddtlInfoOverlay.jsp";
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
