package com.geniisys.giis.controllers;

import java.io.IOException;
import java.sql.SQLException;

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
import com.geniisys.giis.service.GIISMCSublineTypeService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISMCSublineTypeController", urlPatterns={"/GIISMCSublineTypeController"})
public class GIISMCSublineTypeController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISMCSublineTypeService giisMCSublineTypeService = (GIISMCSublineTypeService) APPLICATION_CONTEXT.getBean("giisMCSublineTypeService");
		
		try {
			
			if("showGiiss056".equals(ACTION)){
				JSONObject json = giisMCSublineTypeService.showGiiss056(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGiisMcSublineType", json);
					PAGE = "/pages/underwriting/fileMaintenance/motorCar/sublineType/sublineTypeMaintenance.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("giiss056ValSublineTypeCd".equals(ACTION)) {
				giisMCSublineTypeService.giiss056ValAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGiiss056".equals(ACTION)) {
				giisMCSublineTypeService.saveGiiss056(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("giiss056ValDelRec".equals(ACTION)){
				giisMCSublineTypeService.giiss056ValDelRec(request);
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
