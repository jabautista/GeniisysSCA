package com.geniisys.giac.controllers;

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
import com.geniisys.giac.service.GIACOucsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACOucsController", urlPatterns={"/GIACOucsController"})
public class GIACOucsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACOucsService giacOucsService = (GIACOucsService) APPLICATION_CONTEXT.getBean("giacOucsService");
		
		try {
			if("showGiacs305".equals(ACTION)){
				JSONObject json = giacOucsService.showGiacs305DepartmentList(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					PAGE = "/pages/accounting/maintenance/department/department.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("showAllGiacs305".equals(ACTION)){
				JSONObject json = giacOucsService.showAllGiacs305(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteOuc".equals(ACTION)){
				giacOucsService.valDeleteOuc(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddOuc".equals(ACTION)){
				giacOucsService.valAddOuc(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiacs305".equals(ACTION)) {
				giacOucsService.saveGiacs305(request, USER.getUserId());
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
