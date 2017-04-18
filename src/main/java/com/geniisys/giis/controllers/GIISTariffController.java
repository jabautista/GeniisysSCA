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
import com.geniisys.giis.service.GIISTariffService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISTariffController", urlPatterns={"/GIISTariffController"})
public class GIISTariffController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISTariffService giisTariffService = (GIISTariffService) APPLICATION_CONTEXT.getBean("giisTariffService");
		
		try {
			if("showGIISS005".equals(ACTION)){
				JSONObject json = giisTariffService.showGIISS005(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("tariffJSON", json);
					PAGE = "/pages/underwriting/fileMaintenance/fire/tariff/tariffMaintenance.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("valAddRec".equals(ACTION)){
				giisTariffService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDeleteRec".equals(ACTION)){
				giisTariffService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGIISS005".equals(ACTION)) {
				giisTariffService.saveGIISS005(request, USER.getUserId());
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
