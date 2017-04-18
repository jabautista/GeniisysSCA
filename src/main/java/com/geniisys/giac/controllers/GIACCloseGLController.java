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
import com.geniisys.giac.service.GIACCloseGLService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIACCloseGLController", urlPatterns={"/GIACCloseGLController"})
public class GIACCloseGLController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6488775237514271040L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACCloseGLService giacCloseGLService = (GIACCloseGLService) APPLICATION_CONTEXT.getBean("giacCloseGLService");
			if ("showCloseGL".equals(ACTION)) {
				giacCloseGLService.showCloseGL(request,USER.getUserId());
				PAGE = "/pages/accounting/endOfMonth/closeGL/closeGL.jsp";
			}else if ("closeGenLedger".equals(ACTION)) {
				JSONObject objCloseGenLedger = new JSONObject(giacCloseGLService.closeGenLedger(request,USER.getUserId()));
				message = objCloseGenLedger.toString();
				PAGE =  "/pages/genericMessage.jsp";
			}else if ("closeGenLedgerConfirmation".equals(ACTION)) {
				JSONObject objCloseGenLedger = new JSONObject(giacCloseGLService.closeGenLedgerConfirmation(request,USER.getUserId()));
				message = objCloseGenLedger.toString();
				PAGE =  "/pages/genericMessage.jsp";
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
