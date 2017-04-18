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
import com.geniisys.giis.service.GIISMcMakeService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISMcMakeController", urlPatterns={"/GIISMcMakeController"})
public class GIISMcMakeController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISMcMakeService giisMcMakeService = (GIISMcMakeService) APPLICATION_CONTEXT.getBean("giisMcMakeService");
		
		try {
			if("showGIISS103".equals(ACTION)){
				JSONObject json = giisMcMakeService.showGIISS103(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("makeJSON", json);
					PAGE = "/pages/underwriting/fileMaintenance/motorCar/carMake/carMake.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("valAddRec".equals(ACTION)){
				giisMcMakeService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDeleteRec".equals(ACTION)){
				giisMcMakeService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGIISS103".equals(ACTION)){
				giisMcMakeService.saveGIISS103(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showEngineOverlay".equals(ACTION)){
				JSONObject json = giisMcMakeService.showEngineSeries(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("makeCd", request.getParameter("makeCd"));
					request.setAttribute("make", request.getParameter("make"));
					request.setAttribute("carCompanyCd", request.getParameter("carCompanyCd"));
					request.setAttribute("carCompany", request.getParameter("carCompany"));
					request.setAttribute("engineJSON", json);
					PAGE = "/pages/underwriting/fileMaintenance/motorCar/carMake/overlay/engineSeries.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("valAddEngine".equals(ACTION)){
				giisMcMakeService.valAddEngine(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDeleteEngine".equals(ACTION)){
				giisMcMakeService.valDeleteEngine(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveEngine".equals(ACTION)){
				giisMcMakeService.saveGIISS103Engine(request, USER.getUserId());
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
