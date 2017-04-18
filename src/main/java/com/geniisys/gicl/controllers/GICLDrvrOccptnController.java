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
import com.geniisys.gicl.service.GICLDrvrOccptnService;
import com.geniisys.giuw.controllers.GIUWPolDistController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLDrvrOccptnController", urlPatterns={"/GICLDrvrOccptnController"})
public class GICLDrvrOccptnController extends BaseController{
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
			GICLDrvrOccptnService giclDrvrOccptnService = (GICLDrvrOccptnService) APPLICATION_CONTEXT.getBean("giclDrvrOccptnService"); //08.29.2013 fons
			PAGE = "/pages/genericMessage.jsp";
			if("showDrvrOccptnMaintenance".equals(ACTION)){
				JSONObject jsonDrvrOccptn = giclDrvrOccptnService.showDrvrOccptnMaintenance(request);						
				if("1".equals(request.getParameter("refresh"))){
					message = jsonDrvrOccptn.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonDrvrOccptn", jsonDrvrOccptn);				
					PAGE = "/pages/claims/tableMaintenance/driverOccupation/driverOccupation.jsp";				
				}			
			}else if("validateDrvrOccptnInput".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclDrvrOccptnService.validateDrvrOccptnInput(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();				
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveDrvrOccptnMaintenance".equals(ACTION)){
				log.info("Saving Driver Occupation Maintenance...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclDrvrOccptnService.saveDrvrOccptnMaintenance(request.getParameter("parameters"), USER);
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
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}			
	}
}
