package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
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
import com.geniisys.gipi.service.GIPIMortgageeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIMortgageeController extends BaseController{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7793312666411219212L;
	private static Logger log = Logger.getLogger(GIPIMortgageeController.class);
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIMortgageeService gipiMortgageeService = (GIPIMortgageeService) APPLICATION_CONTEXT.getBean("gipiMortgageeService");
			
			if("getMortgageeList".equals(ACTION)){
				log.info("Getting policies by Assured");				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", request.getParameter("policyId"));
				params = gipiMortgageeService.getMortgageeList(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("mortgageeList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyMortgageeListOverlay.jsp";
				}
				
			}if("getPolicyMortgageeList".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", request.getParameter("policyId"));
				params.put("itemNo", 0);
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params = gipiMortgageeService.getItemMortgagees(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("policyId", request.getParameter("policyId"));
					request.setAttribute("mortgageeList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyMortgageeListOverlay.jsp";
				}
				
			}else if("getItemMortgagees".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				//params = gipiMortgageeService.getMortgageeList(params); replaced by: Nica 05.11.2013
				params = gipiMortgageeService.getItemMortgagees(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("itemMortgagees", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/itemMortgageesTable.jsp";
				}
			}else if("getMortgageesTableGrid".equals(ACTION)){
				JSONObject json = gipiMortgageeService.getMortgageesTableGrid(request);				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					message = json.toString();					
				PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("mortgageeList", json);
					request.setAttribute("policyId", request.getParameter("policyId"));
				}
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyMortgageeListOverlay.jsp";
			}else if("getPerItemAmount".equals(ACTION)){ //kenneth SR 5483 05.26.2016
				BigDecimal mortAmount = gipiMortgageeService.getPerItemAmount(request);
				message = (mortAmount == null) ? "0" : mortAmount.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPerItemMortgName".equals(ACTION)){ //MarkS SR 5483,2743,3708 09.09.2016
				String mortName = gipiMortgageeService.getPerItemMortgName(request);
				System.out.println("mornt "+ mortName);
				message = (mortName == null) ? "0" : mortName.toString();
				PAGE = "/pages/genericMessage.jsp";
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