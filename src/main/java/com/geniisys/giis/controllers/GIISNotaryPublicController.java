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
import com.geniisys.giis.service.GIISNotaryPublicService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISNotaryPublicController", urlPatterns={"/GIISNotaryPublicController"})
public class GIISNotaryPublicController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8915226737727054251L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISNotaryPublicService giisNotaryPublicService = (GIISNotaryPublicService) APPLICATION_CONTEXT.getBean("giisNotaryPublicService");
		
		try {
			
			if("showGiiss016".equals(ACTION)) {
				JSONObject json = giisNotaryPublicService.getGIISS016NotaryPublicList(request);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonNotaryPublicList", json);
					PAGE = "/pages/underwriting/fileMaintenance/suretyBonds/notaryPublic/notaryPublicMaintenance.jsp";
				}
			} else if ("saveGiiss016".equals(ACTION)) {
				giisNotaryPublicService.saveGiiss016(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("giiss016ValDelRec".equals(ACTION)) {
				giisNotaryPublicService.giiss016ValDelRec(request);
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
