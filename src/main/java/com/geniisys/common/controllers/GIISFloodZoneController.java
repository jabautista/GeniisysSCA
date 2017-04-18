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
import com.geniisys.common.service.GIISFloodZoneService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIISFloodZoneController", urlPatterns={"/GIISFloodZoneController"})
public class GIISFloodZoneController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISFloodZoneService giisFloodZoneService = (GIISFloodZoneService) APPLICATION_CONTEXT.getBean("giisFloodZoneService");
		
		try {
			if("showGiiss053".equals(ACTION)){
				JSONObject json = giisFloodZoneService.showGiiss053(request, USER.getUserId());
				if(request.getParameter("refresh") != null) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonFloodZoneList", json);
					PAGE = "/pages/underwriting/fileMaintenance/fire/floodZone/floodZone.jsp";
				}				
			} else if ("valDeleteRec".equals(ACTION)){
				giisFloodZoneService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisFloodZoneService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss053".equals(ACTION)) {
				giisFloodZoneService.saveGiiss053(request, USER.getUserId());
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
