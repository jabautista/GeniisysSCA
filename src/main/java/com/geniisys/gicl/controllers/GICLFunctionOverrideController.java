package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLFunctionOverrideService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLFunctionOverrideController", urlPatterns="/GICLFunctionOverrideController")
public class GICLFunctionOverrideController extends BaseController{

	
	private static final long serialVersionUID = -1450719875392819573L;
	
	private static Logger log = Logger.getLogger(GICLFunctionOverrideController.class);

	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		log.info("");
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLFunctionOverrideService giclFunctionOverrideService = (GICLFunctionOverrideService) APPLICATION_CONTEXT.getBean("giclFunctionOverrideService");
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			     
			if ("getGICLS183FunctionListing".equals(ACTION)){
				String modId = "GICLS183";
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("ACTION", ACTION);
				params.put("appUser", USER.getUserId());
				params.put("filter", request.getParameter("objFilter"));
				
				Map<String, Object> functionOverride = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(functionOverride);
				
				if ("1".equals(request.getParameter("refresh")) && request.getParameter("refresh") != null) {
					request.setAttribute("functionOverrideGrid", json);
					PAGE = "/pages/claims/functionOverride/functionOverrideMain.jsp";
					System.out.println(json.toString());
				}else {
					PAGE = "/pages/genericMessage.jsp";
					message = json.toString();
				}				
			}else if ("getGICLS183FunctionOverrideRecordsListing".equals(ACTION)){
				JSONObject json = giclFunctionOverrideService.getGICLFunctionOverrideRecords(request, USER, ACTION);
				
				if ("1".equals(request.getParameter("refresh")) && request.getParameter("refresh") != null){
					request.setAttribute("functionOverrideGrid", json);
					PAGE = "/pages/claims/functionOverride/subPages/functionOverrideRecordsListing.jsp";
					System.out.println(json.toString());
				}else {
					PAGE = "/pages/genericMessage.jsp";
					message = json.toString();
				}
				
			}else if ("updateGICLFunctionOverride".equals(ACTION)){
				giclFunctionOverrideService.updateFunctionOverride(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			log.error(e);
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
