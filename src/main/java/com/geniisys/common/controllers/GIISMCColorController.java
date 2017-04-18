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
import com.geniisys.common.service.GIISMCColorService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISMCColorController", urlPatterns={"/GIISMCColorController"})
public class GIISMCColorController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISMCColorService giisMcColorService = (GIISMCColorService) APPLICATION_CONTEXT.getBean("giisMCColorService");
		
		try {
			if("showGiiss114BasicColor".equals(ACTION)){
				JSONObject jsonBasicColor = giisMcColorService.showGiiss114BasicColor(request, USER.getUserId());			
				if(request.getParameter("refresh") == null) {
					JSONObject jsonColor = giisMcColorService.showGiiss114(request, USER.getUserId());
					request.setAttribute("jsonBasicColorList", jsonBasicColor);
					request.setAttribute("jsonColorList", jsonColor);
					PAGE = "/pages/underwriting/fileMaintenance/motorCar/carColor/carColor.jsp";
				} else {					
					message = jsonBasicColor.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("showGiiss114".equals(ACTION)){
				JSONObject jsonColor = giisMcColorService.showGiiss114(request,USER.getUserId());
				message = jsonColor.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRecBasic".equals(ACTION)){
				giisMcColorService.valDeleteRecBasic(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRec".equals(ACTION)){
				giisMcColorService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRecBasic".equals(ACTION)){
				giisMcColorService.valAddRecBasic(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valAddRec".equals(ACTION)){
				giisMcColorService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss114".equals(ACTION)) {
				giisMcColorService.saveGiiss114(request, USER.getUserId());
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
