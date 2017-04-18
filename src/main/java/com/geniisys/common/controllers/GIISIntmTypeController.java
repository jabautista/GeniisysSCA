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
import com.geniisys.common.entity.GIISIntmType;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISIntmTypeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISIntmTypeController", urlPatterns={"/GIISIntmTypeController"})
public class GIISIntmTypeController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5294649608120690217L;
	
	private static Logger log = Logger.getLogger(GIISIntmType.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISIntmTypeService giisIntmTypeService = (GIISIntmTypeService) APPLICATION_CONTEXT.getBean("giisIntmTypeService");
			PAGE = "/pages/genericMessage.jsp";
			if("showIntmType".equals(ACTION)){
				JSONObject jsonIntmType = giisIntmTypeService.showIntmType(request);						
				if("1".equals(request.getParameter("refresh"))){
					message = jsonIntmType.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonIntmType", jsonIntmType);				
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryType/intermediaryType.jsp";				
				}			
			}else if ("valAddRec".equals(ACTION)){
				giisIntmTypeService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			}else if ("valDeleteRec".equals(ACTION)){
				giisIntmTypeService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveIntmType".equals(ACTION)){
				log.info("Saving Intermediary Type Maintenance...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisIntmTypeService.saveIntmType(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";		
			}else if("valUpdateIntmType".equals(ACTION)){ //Added by Jerome 08.11.2016 SR 5583
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("intmType", request.getParameter("intmType"));
				message = giisIntmTypeService.valUpdateIntmType(params);
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
