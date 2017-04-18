package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.gipi.entity.GIPICoInsurer;
import com.geniisys.gipi.entity.GIPIMainCoIns;
import com.geniisys.gipi.service.GIPICoInsurerService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPICoInsurerController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPICoInsurerController.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPICoInsurerService coInsurerService = (GIPICoInsurerService) APPLICATION_CONTEXT.getBean("gipiCoInsurerService");
		
		try {
			log.info("action: "+ACTION);
			if("showCoInsurerDetails".equals(ACTION)) {
				Integer parId = "".equals(request.getParameter("parId")) ? 0 : Integer.parseInt(request.getParameter("parId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("userId", USER.getUserId());
				
				GIPIMainCoIns mainCoIns = coInsurerService.getCoInsurerAmts(parId);
				if("E".equals(request.getParameter("parType")) && mainCoIns == null) {
					coInsurerService.processDefaultEndtCoIns(params);
					mainCoIns = coInsurerService.getCoInsurerAmts(parId);
				}
				List<GIPICoInsurer> coInsurers = coInsurerService.getCoInsurerDetails(parId);
				StringFormatter.replaceQuotesInList(coInsurers);
				request.setAttribute("coInsurers", new JSONArray(coInsurers));
				
				params = coInsurerService.getCoInsurerDefaultParams(params);
				params.put("premAmt", (mainCoIns==null ? JSONObject.NULL : mainCoIns.getPremAmt()));
				params.put("tsiAmt",  (mainCoIns==null ? JSONObject.NULL : mainCoIns.getTsiAmt()));
				request.setAttribute("objDefaults", new JSONObject(StringFormatter.replaceQuotesInMap(params)));
				
				PAGE = "/pages/underwriting/coInsurance/enterCoInsurer.jsp";
			} else if("loadDefaultCoInsurers".equals(ACTION)) {
				int policyId = ("".equals(request.getParameter("policyId"))) ? 0 : Integer.parseInt(request.getParameter("policyId"));
				List<GIPICoInsurer> defaultCoInsurers = coInsurerService.getDefaultCoInsurers(policyId);
				request.setAttribute("object", new JSONArray((List<GIPICoInsurer>) StringFormatter.replaceQuotesInList(defaultCoInsurers)));
				PAGE = "/pages/genericObject.jsp";
			} else if("saveCoInsurers".equals(ACTION)) {
				JSONObject obj = new JSONObject(coInsurerService.saveEnteredCoInsurers(request.getParameter("parameters"), USER.getUserId()));
				System.out.println("Test object after save - "+obj);
				message = obj.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getCoInsurers".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params = coInsurerService.getCoInsurers(params);
			
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					
					request.setAttribute("policyCoInsurers", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyCoInsurersTable.jsp";
						
				}
				
			} else if("limitEntry".equals(ACTION)) {
				System.out.println("limitEntry");
				message = coInsurerService.checkCoInsurerAccess(Integer.parseInt(request.getParameter("parId")));
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = "Unhandled exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";			
		} finally {
			request.setAttribute("message", message);			
			this.doDispatch(request, response, PAGE);
		}
	}

}
