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
import com.geniisys.common.entity.GIISLineSublineCoverages;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISCargoTypeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISCargoTypeController", urlPatterns={"/GIISCargoTypeController"})
public class GIISCargoTypeController extends BaseController {
	/**
	 * 
	 */
	private static final long serialVersionUID = 5294649608120690217L;
	
	private static Logger log = Logger.getLogger(GIISLineSublineCoverages.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISCargoTypeService giisCargoTypeService = (GIISCargoTypeService) APPLICATION_CONTEXT.getBean("giisCargoTypeService"); 
			PAGE = "/pages/genericMessage.jsp";
			if("showCargoClass".equals(ACTION)){
				JSONObject jsonCargoClass = giisCargoTypeService.showCargoClass(request);			
				if("1".equals(request.getParameter("refresh"))){					
					message = jsonCargoClass.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					JSONObject jsonCargoType = giisCargoTypeService.showCargoType(request);						
					request.setAttribute("jsonCargoClass", jsonCargoClass);					
					request.setAttribute("jsonCargoType", jsonCargoType);
					PAGE = "/pages/underwriting/fileMaintenance/marineCargo/cargoType/cargoType.jsp";				
				}			
			}else if("showCargoType".equals(ACTION)){
				JSONObject jsonCargoType = giisCargoTypeService.showCargoType(request);						
				message = jsonCargoType.toString();
				PAGE = "/pages/genericMessage.jsp";
							
			}else if("saveCargoType".equals(ACTION)){
				log.info("Saving Cargo Type Maintenance...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisCargoTypeService.saveCargoType(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";		
			}else if("validateCargoType".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisCargoTypeService.validateCargoType(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();				
				PAGE = "/pages/genericMessage.jsp";
			}else if("chkDeleteGIISS008CargoType".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();			
				params = giisCargoTypeService.chkDeleteGIISS008CargoType(request);	
				JSONObject result = new JSONObject(params);
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
