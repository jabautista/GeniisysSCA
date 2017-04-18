package com.geniisys.common.controllers;

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
import com.geniisys.common.service.GIISCaLocationService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISCaLocationController", urlPatterns={"/GIISCaLocationController"})
public class GIISCaLocationController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISCaLocationService giisCaLocationService = (GIISCaLocationService) APPLICATION_CONTEXT.getBean("giisCaLocationService");
		
		try {
			if("showGiiss217".equals(ACTION)){
				JSONObject json = giisCaLocationService.showGiiss217(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonCaLocationList", json);
					PAGE = "/pages/underwriting/fileMaintenance/miscAndCasualty/casualtyLocation/casualtyLocation.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("saveGiiss217".equals(ACTION)) {
				giisCaLocationService.saveGiiss217(request, USER.getUserId());				
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
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
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
