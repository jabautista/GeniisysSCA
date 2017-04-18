package com.geniisys.gism.controllers;

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
import com.geniisys.gism.service.GISMRecipientGroupService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GISMRecipientGroupController", urlPatterns={"/GISMRecipientGroupController"})
public class GISMRecipientGroupController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GISMRecipientGroupService gismRecipientGroupService = (GISMRecipientGroupService) APPLICATION_CONTEXT.getBean("gismRecipientGroupService");
		
		try {
			if("showGisms003".equals(ACTION)){
				JSONObject json = gismRecipientGroupService.showGisms003(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonRecipientGroupList", json);
					PAGE = "/pages/sms/tableMaintenance/smsUserGroup/smsUserGroup.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				gismRecipientGroupService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				gismRecipientGroupService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGisms003".equals(ACTION)) {
				gismRecipientGroupService.saveGisms003(request, USER.getUserId());
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
