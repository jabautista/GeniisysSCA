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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISMotorTypeService;
import com.geniisys.common.service.GIISVessClassService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISMotorTypeController", urlPatterns={"/GIISMotorTypeController"})
public class GIISMotorTypeController extends BaseController {	
		/**
		 * 
		 */
		private static final long serialVersionUID = 5294649608120690217L;
		
		private static Logger log = Logger.getLogger(GIISMotorTypeController.class);
		@Override
		public void doProcessing(HttpServletRequest request,
				HttpServletResponse response, GIISUser USER, String ACTION,
				HttpSession SESSION) throws ServletException, IOException {
			try {
				ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
				GIISMotorTypeService giisMotorTypeService = (GIISMotorTypeService) APPLICATION_CONTEXT.getBean("giisMotorTypeService"); 
				PAGE = "/pages/genericMessage.jsp";
				if("showSubline".equals(ACTION)){
					JSONObject jsonSubline = giisMotorTypeService.showSubline(request, USER);			
					if("1".equals(request.getParameter("refresh"))){					
						message = jsonSubline.toString();
						PAGE = "/pages/genericMessage.jsp";
					}else{		
						JSONObject jsonMotorType = giisMotorTypeService.showMotorType(request);						
						request.setAttribute("jsonMotorType", jsonMotorType);
						request.setAttribute("jsonSubline", jsonSubline);					
						PAGE = "/pages/underwriting/fileMaintenance/motorCar/motorType/motorType.jsp";				
					}			
				}else if("showMotorType".equals(ACTION)){
					JSONObject jsonMotorType = giisMotorTypeService.showMotorType(request);						
					message = jsonMotorType.toString();
					PAGE = "/pages/genericMessage.jsp";								
				}else if("validateGIISS055MotorType".equals(ACTION)){				
					Map<String, Object> params = new HashMap<String, Object>();			
					params = giisMotorTypeService.validateGIISS055MotorType(request);	
					JSONObject result = new JSONObject(params);
					message = result.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("chkDeleteGIISS055MotorType".equals(ACTION)){				
					Map<String, Object> params = new HashMap<String, Object>();			
					params = giisMotorTypeService.chkDeleteGIISS055MotorType(request);	
					JSONObject result = new JSONObject(params);
					message = result.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("saveGiiss055".equals(ACTION)){
					log.info("Saving Motor Type Maintenance...");
					Map<String, Object> params = new HashMap<String, Object>();
					params = giisMotorTypeService.saveGiiss055(request.getParameter("parameters"), USER);
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
