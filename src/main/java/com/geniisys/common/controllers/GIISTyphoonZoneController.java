package com.geniisys.common.controllers;

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
import com.geniisys.common.entity.GIISTyphoonZone;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISTyphoonZoneService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISTyphoonZoneController", urlPatterns={"/GIISTyphoonZoneController"})
public class GIISTyphoonZoneController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5294649608120690217L;
	
	private static Logger log = Logger.getLogger(GIISTyphoonZone.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISTyphoonZoneService giisTyphoonZoneService = (GIISTyphoonZoneService) APPLICATION_CONTEXT.getBean("giisTyphoonZoneService"); //09.02.2013 fons
			PAGE = "/pages/genericMessage.jsp";
			if("showTyphoonZoneMaintenance".equals(ACTION)){
				JSONObject jsonTyphoonZone = giisTyphoonZoneService.showTyphoonZoneMaintenance(request);						
				if("1".equals(request.getParameter("refresh"))){
					message = jsonTyphoonZone.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonTyphoonZone", jsonTyphoonZone);				
					PAGE = "/pages/underwriting/fileMaintenance/fire/typhoonZone/typhoonZone.jsp";				
				}			
			}else if("validateTyphoonZoneInput".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisTyphoonZoneService.validateTyphoonZoneInput(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();				
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateDeleteTyphoonZone".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisTyphoonZoneService.validateDeleteTyphoonZone(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();				
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveTyphoonZoneMaintenance".equals(ACTION)){
				log.info("Saving Driver Occupation Maintenance...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisTyphoonZoneService.saveTyphoonZoneMaintenance(request.getParameter("parameters"), USER);
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
		}  finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}			
	}
}
