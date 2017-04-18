package com.geniisys.giis.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.service.GIISWarrClaService;
import com.seer.framework.util.ApplicationContextReader;

public class GIISWarrClaController extends BaseController {

	private static final long serialVersionUID = 7203511324505153903L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISWarrClaService giisWarrClaService = (GIISWarrClaService) APPLICATION_CONTEXT.getBean("giisWarrClaService");
		try {
			if ("getGIISLine".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				String modId = "GIISS034";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> warrClaMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(warrClaMaintenance);		
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("warrClaMaintenance", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/text/warrantyAndClause.jsp";	
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getGIISWarrCla".equals(ACTION)) {
				JSONObject json = giisWarrClaService.getGIISWarrCla(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateAddWarrCla".equals(ACTION)) {
				message = giisWarrClaService.validateAddWarrCla(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateDeleteWarrCla".equals(ACTION)) {
				message = giisWarrClaService.validateDeleteWarrCla(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveWarrCla".equals(ACTION)) {
				message = giisWarrClaService.saveWarrCla(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} 
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
