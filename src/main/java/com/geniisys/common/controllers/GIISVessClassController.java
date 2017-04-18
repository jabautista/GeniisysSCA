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
import com.geniisys.common.service.GIISVessClassService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISVessClassController", urlPatterns={"/GIISVessClassController"})
public class GIISVessClassController extends BaseController {	
		/**
		 * 
		 */
		private static final long serialVersionUID = 5294649608120690217L;
		
		private static Logger log = Logger.getLogger(GIISVessClassController.class);
		@Override
		public void doProcessing(HttpServletRequest request,
				HttpServletResponse response, GIISUser USER, String ACTION,
				HttpSession SESSION) throws ServletException, IOException {
			try {
				ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
				GIISVessClassService giisVessClassService = (GIISVessClassService) APPLICATION_CONTEXT.getBean("giisVessClassService"); 
				PAGE = "/pages/genericMessage.jsp";
				if("showVesselClassification".equals(ACTION)){
					JSONObject jsonVessClass = giisVessClassService.showVesselClassification(request);			
					if("1".equals(request.getParameter("refresh"))){					
						message = jsonVessClass.toString();
						PAGE = "/pages/genericMessage.jsp";
					}else{				
						request.setAttribute("jsonVessClass", jsonVessClass);					
						PAGE = "/pages/underwriting/fileMaintenance/marineHull/vesselClassification/vesselClassification.jsp";				
					}			
				}else if("validateGIISS047VesselClass".equals(ACTION)){				
					Map<String, Object> params = new HashMap<String, Object>();			
					params = giisVessClassService.validateGIISS047VesselClass(request);	
					JSONObject result = new JSONObject(params);
					message = result.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("saveVessClass".equals(ACTION)){
					log.info("Saving Vessel Classification Maintenance...");
					Map<String, Object> params = new HashMap<String, Object>();
					params = giisVessClassService.saveVessClass(request.getParameter("parameters"), USER);
					Map<String, Object> paramsOut = new HashMap<String, Object>();
					paramsOut.put("message", params.get("message"));
					JSONObject result = new JSONObject(paramsOut);
					message = result.toString();
					PAGE = "/pages/genericMessage.jsp";		
				}else if("valDeleteRec".equals(ACTION)){
					giisVessClassService.valDelRec(request);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}
			} catch (SQLException e) {
				if(e.getErrorCode() > 20000){ 
					message = ExceptionHandler.extractSqlExceptionMessage(e);
					ExceptionHandler.logException(e);
				} else {
					message = ExceptionHandler.handleException(e, USER);
				}
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
