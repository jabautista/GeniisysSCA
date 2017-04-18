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
import com.geniisys.giis.service.GIISBancAreaService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISBancAreaController", urlPatterns={"/GIISBancAreaController"})
public class GIISBancAreaController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISBancAreaService giisBancAreaService = (GIISBancAreaService) APPLICATION_CONTEXT.getBean("giisBancAreaService");
		
		try {
			
			if("showGiiss215".equals(ACTION)) {
				JSONObject json = giisBancAreaService.showGiiss215(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonBancArea", json);
					PAGE= "/pages/underwriting/fileMaintenance/general/bancassurance/areaCode/areaCode.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("giiss215ValAddRec".equals(ACTION)) {
				giisBancAreaService.giiss215ValAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGiiss215".equals(ACTION)) {
				giisBancAreaService.saveGiiss215(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGiiss215History".equals(ACTION)){
				JSONObject json = giisBancAreaService.showGiiss215Hist(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonBancAreaHist", json);
					PAGE= "/pages/underwriting/fileMaintenance/general/bancassurance/areaCode/history.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
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
