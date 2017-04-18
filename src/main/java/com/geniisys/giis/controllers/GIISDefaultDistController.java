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
import com.geniisys.giis.service.GIISDefaultDistService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISDefaultDistController", urlPatterns={"/GIISDefaultDistController"})
public class GIISDefaultDistController extends BaseController{

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISDefaultDistService giisDefaultDistService = (GIISDefaultDistService) APPLICATION_CONTEXT.getBean("giisDefaultDistService");
		
		try {
			if("showGiiss165".equals(ACTION)){
				JSONObject json = giisDefaultDistService.getDefaultDistList(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("distJSON", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/defaultPerilDist/defaultPerilDist.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showRangeOverlay".equals(ACTION)){
				JSONObject json = giisDefaultDistService.getDefaultDistDtlList(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("rangeJSON", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/defaultPerilDist/defaultPerilRange.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getPerilList".equals(ACTION)){
				JSONObject json = giisDefaultDistService.getPerilList(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDefaultDistPerilList".equals(ACTION)){
				JSONObject json = giisDefaultDistService.getDefaultDistPerilList(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("valAddRec".equals(ACTION)){
				giisDefaultDistService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDeleteRec".equals(ACTION)){
				giisDefaultDistService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGiiss165".equals(ACTION)){
				giisDefaultDistService.saveGiiss165(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkDistRecords".equals(ACTION)){
				giisDefaultDistService.checkDistRecords(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDistPerilVariables".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giisDefaultDistService.getDistPerilVariables(request)));
				PAGE = "/pages/genericObject.jsp";
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
