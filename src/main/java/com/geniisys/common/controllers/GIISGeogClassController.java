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
import com.geniisys.common.entity.GIISGeogClass;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISGeogClassService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISGeogClassController", urlPatterns={"/GIISGeogClassController"})
public class GIISGeogClassController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5294649608120690217L;
	
	private static Logger log = Logger.getLogger(GIISGeogClass.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISGeogClassService giisGeogClassService = (GIISGeogClassService) APPLICATION_CONTEXT.getBean("giisGeogClassService");
			PAGE = "/pages/genericMessage.jsp";
			if("showGeographyClass".equals(ACTION)){
				JSONObject jsonGeogClass = giisGeogClassService.showGeographyClass(request);			
				if("1".equals(request.getParameter("refresh"))){					
					message = jsonGeogClass.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{					
					request.setAttribute("jsonGeogClass", jsonGeogClass);							
					PAGE = "/pages/underwriting/fileMaintenance/marineCargo/geographyClass/geographyClass.jsp";				
				}			
			}else if("validateGeogCdInput".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisGeogClassService.validateGeogCdInput(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();				
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGeogDescInput".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisGeogClassService.validateGeogDescInput(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();				
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateBeforeDelete".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisGeogClassService.validateBeforeDelete(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();				
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGeogClass".equals(ACTION)){
				log.info("Saving Geography Classification Maintenance...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisGeogClassService.saveGeogClass(request.getParameter("parameters"), USER);
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
