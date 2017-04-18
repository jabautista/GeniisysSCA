package com.geniisys.giis.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.service.GIISMcFairMarketValueService;
import com.seer.framework.util.ApplicationContextReader;

import common.Logger;

@WebServlet(name="GIISMcFairMarketValueController", urlPatterns={"/GIISMcFairMarketValueController"})
public class GIISMcFairMarketValueController extends BaseController {

	private static final long serialVersionUID = -4444130444204953615L;
	private static Logger log = Logger.getLogger(GIISMcFairMarketValueController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
			log.info("do processing");
		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISMcFairMarketValueService giisMcFairMarketValueService = (GIISMcFairMarketValueService) APPLICATION_CONTEXT.getBean("giisMcFairMarketValueService");
			if("showSourceMcFairMarketValueMaintenance".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String modId = "GIISS223";
				params.put("ACTION", "getGIISS223SourceList");				
				params.put("pageSize", 6);
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> motorCarListing = TableGridUtil.getTableGrid(request,params);
				JSONObject json = new JSONObject(motorCarListing);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("motorCarListing", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/mcFairMarketValue/mcFairMarketValueMain.jsp";			
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showMcFairMarketValueMaintenance".equals(ACTION)){				
				JSONObject json = giisMcFairMarketValueService.showMcFairMarketValueMaintenance(request);								
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveFmv".equals(ACTION)) {
				message = giisMcFairMarketValueService.saveFmv(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
