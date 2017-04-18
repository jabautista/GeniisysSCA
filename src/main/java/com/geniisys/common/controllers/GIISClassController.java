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
import com.geniisys.common.service.GIISClassService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISClassController", urlPatterns={"/GIISClassController"})
public class GIISClassController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9202829731433074558L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISClassService giisClassService = (GIISClassService) APPLICATION_CONTEXT.getBean("giisClassService");
		
		try {
			if("showGiiss063".equals(ACTION)){
				JSONObject json = giisClassService.showGiiss063(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonClassList", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/peril/perilClass/perilClass.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				giisClassService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisClassService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valAddRec2".equals(ACTION)) {
				giisClassService.valAddRec2(request);
				System.out.println(request.getParameter("classDesc"));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiiss063".equals(ACTION)) {
				giisClassService.saveGiiss063(request, USER.getUserId());
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
