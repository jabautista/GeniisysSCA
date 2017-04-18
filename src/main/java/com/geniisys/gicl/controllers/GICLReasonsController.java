package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLReasonsService;
import com.geniisys.giuw.controllers.GIUWPolDistController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLReasonsController", urlPatterns={"/GICLReasonsController"})
public class GICLReasonsController extends BaseController{
	/**
	 * 
	 */
	private Logger log = Logger.getLogger(GIUWPolDistController.class);
	private static final long serialVersionUID = -5149745550734999239L;
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLReasonsService giclReasonsService = (GICLReasonsService) APPLICATION_CONTEXT.getBean("giclReasonsService"); //08.23.2013 fons
			PAGE = "/pages/genericMessage.jsp";
			if("showClmStatReasonsMaintenance".equals(ACTION)){
				JSONObject jsonClmStatReasons = giclReasonsService.showClmStatReasonsMaintenance(request);						
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmStatReasons.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmStatReasons", jsonClmStatReasons);				
					PAGE = "/pages/claims/tableMaintenance/claimStatusReasons/claimStatusReasons.jsp";				
				}			
			}else if("validateReasonsInput".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclReasonsService.validateReasonsInput(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();				
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveClmStatReasonsMaintenance".equals(ACTION)){
				log.info("Saving Claim Status Maintenance...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclReasonsService.saveClmStatReasonsMaintenance(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";		
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}			
	}
}
