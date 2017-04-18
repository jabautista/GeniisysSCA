package com.geniisys.gicl.controllers;

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
import com.geniisys.gicl.service.GICLRepSignatoryService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLRepSignatoryController", urlPatterns={"/GICLRepSignatoryController"})
public class GICLRepSignatoryController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLRepSignatoryService giclRepSignatoryService = (GICLRepSignatoryService) APPLICATION_CONTEXT.getBean("giclRepSignatoryService");
		
		try {
			if("showGicls181".equals(ACTION)){
				JSONObject jsonRep = giclRepSignatoryService.showRepSignatory(request, USER.getUserId());
				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonRepSignatoryList", jsonRep);
					PAGE = "/pages/claims/tableMaintenance/repSignatory/repSignatory.jsp";
				} else {
					message = jsonRep.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showRepSignatory".equals(ACTION)) {
				JSONObject json = giclRepSignatoryService.showRepSignatory(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGicls181".equals(ACTION)) {
				giclRepSignatoryService.saveGicls181(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valAddRec".equals(ACTION)){
				giclRepSignatoryService.valAddRec(request);
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
