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
import com.geniisys.common.service.GIISAdjusterService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIISAdjusterController", urlPatterns={"/GIISAdjusterController"})
public class GIISAdjusterController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISAdjusterService giisAdjusterService = (GIISAdjusterService) APPLICATION_CONTEXT.getBean("giisAdjusterService");
		
		try {
			if("showGicls210".equals(ACTION)){
				JSONObject json = giisAdjusterService.showGicls210(request, USER.getUserId());
				if(request.getParameter("refresh") != null) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					//request.setAttribute("jsonFloodZoneList", json);
					PAGE = "/pages/claims/tableMaintenance/privateAdjuster/privateAdjuster.jsp";
				}				
			} else if ("valDeleteRec".equals(ACTION)){
				giisAdjusterService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisAdjusterService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGicls210".equals(ACTION)) {
				giisAdjusterService.saveGicls210(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("getLastPrivAdjNo".equals(ACTION)){
				message = giisAdjusterService.getLastPrivAdjNo(Integer.parseInt(request.getParameter("adjCompanyCd"))).toString();
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
