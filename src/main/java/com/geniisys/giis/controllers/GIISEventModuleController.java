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
import com.geniisys.giis.service.GIISEventModuleService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISEventModuleController", urlPatterns={"/GIISEventModuleController"})
public class GIISEventModuleController extends BaseController{

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
		GIISEventModuleService giisEventModuleService = (GIISEventModuleService) APPLICATION_CONTEXT.getBean("giisEventModuleService");
		
		try {
			
			if("showGiiss168".equals(ACTION)){				
				PAGE = "/pages/workflow/workflow/maintenance/userEventMaintenance/userEventMaintenance.jsp";
			} else if ("getGiiss168EventModules".equals(ACTION)) {
				JSONObject json = giisEventModuleService.getGiiss168EventModules(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGiiss168SelectedModules".equals(ACTION)) {
				message = giisEventModuleService.getGiiss168SelectedModules(request);
				PAGE = "/pages/genericMessage.jsp"; 
			} else if ("saveGiiss168".equals(ACTION)) {
				giisEventModuleService.saveGiiss168(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGiiss168UserList".equals(ACTION)) {
				JSONObject jsonPassingUserList = giisEventModuleService.getGiiss168PassingUser(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPassingUserList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonPassingUserList", jsonPassingUserList);
					PAGE = "/pages/workflow/workflow/maintenance/userEventMaintenance/userList.jsp";					
				}
			} /*else if("getGiiss168PassingUser".equals(ACTION)){
				JSONObject jsonPassingUserList = giisEventModuleService.getGiiss168PassingUser(request);
				message = jsonPassingUserList.toString();
				PAGE = "/pages/genericMessage.jsp";
			}*/ else if ("getGiiss168ReceivingUser".equals(ACTION)){
				JSONObject jsonReceivingUserList = giisEventModuleService.getGiiss168ReceivingUser(request);
				message = jsonReceivingUserList.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGiiss168SelectedPassingUsers".equals(ACTION)) {
				message = giisEventModuleService.getGiiss168SelectedPassingUsers(request);
				PAGE = "/pages/genericMessage.jsp"; 
			} else if("getGiiss168SelectedReceivingUsers".equals(ACTION)) {
				message = giisEventModuleService.getGiiss168SelectedReceivingUsers(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGiiss168UserList".equals(ACTION)) {
				giisEventModuleService.saveGiiss168UserList(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("valDelGiiss168PassingUsers".equals(ACTION)){
				giisEventModuleService.valDelGiiss168PassingUsers(request);
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
