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
import com.geniisys.common.service.GIISPerilGroupService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISPerilGroupController", urlPatterns={"/GIISPerilGroupController"})
public class GIISPerilGroupController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7718737969269048760L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISPerilGroupService giisPerilGroupService = (GIISPerilGroupService) APPLICATION_CONTEXT.getBean("giisPerilGroupService");
		try {
			if("showGIISS213".equals(ACTION)){
				JSONObject json = giisPerilGroupService.showGiiss213(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonPerilGroupList", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/peril/perilGroup/perilGroup.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				giisPerilGroupService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisPerilGroupService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss213".equals(ACTION)) {
				giisPerilGroupService.saveGiiss213(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}  else if ("getAttachedPerils".equals(ACTION)) {
				JSONObject json = giisPerilGroupService.showGiiss213PerilList(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonAttachedPerilGroupList", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/peril/perilGroup/subPages/attachedPeril.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("saveGiiss213Dtl".equals(ACTION)) {
				giisPerilGroupService.saveGiiss213Dtl(request, USER.getUserId());
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