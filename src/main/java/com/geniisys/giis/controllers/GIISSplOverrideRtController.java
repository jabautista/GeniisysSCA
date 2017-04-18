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
import com.geniisys.giis.service.GIISSplOverrideRtService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISSplOverrideRtController", urlPatterns={"/GIISSplOverrideRtController"})
public class GIISSplOverrideRtController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISSplOverrideRtService giisSplOverrideRtService = (GIISSplOverrideRtService) APPLICATION_CONTEXT.getBean("giisSplOverrideRtService");
		
		try {
			
			if("showGiiss202".equals(ACTION)) {
				PAGE="/pages/underwriting/fileMaintenance/intermediary/specialOverridingCommRate/specialOverridingCommRateMaintenance.jsp";
			} else if("showGiiss202Copy".equals(ACTION)){
				PAGE="/pages/underwriting/fileMaintenance/intermediary/specialOverridingCommRate/copy.jsp";
			} else if("getGiiss202RecList".equals(ACTION)) {
				JSONObject json = giisSplOverrideRtService.getGiiss202RecList(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGiiss202SelectedPerils".equals(ACTION)) {
				message = giisSplOverrideRtService.getGiiss202SelectedPerils(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiiss202".equals(ACTION)) {
				giisSplOverrideRtService.saveGiiss202(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("populateGiiss202".equals(ACTION)) {
				giisSplOverrideRtService.populateGiiss202(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("copyGiiss202".equals(ACTION)) {
				giisSplOverrideRtService.copyGiiss202(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGiiss202History".equals(ACTION)) {
				JSONObject json = giisSplOverrideRtService.getGiiss202History(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonHistory", json);
					PAGE="/pages/underwriting/fileMaintenance/intermediary/specialOverridingCommRate/history.jsp";
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
