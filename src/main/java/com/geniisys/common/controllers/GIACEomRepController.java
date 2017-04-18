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
import com.geniisys.common.service.GIACEomRepService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACEomRepController", urlPatterns={"/GIACEomRepController"})
public class GIACEomRepController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACEomRepService giacEomRepService = (GIACEomRepService) APPLICATION_CONTEXT.getBean("giacEomRepService");
		
		try {
			if("showGiacs350".equals(ACTION)){
				JSONObject json = giacEomRepService.showGiacs350(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonEomRepList", json);
					PAGE = "/pages/accounting/maintenance/monthEndRep/monthEndRep.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valAddRec".equals(ACTION)){
				giacEomRepService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valDeleteRec".equals(ACTION)){
				giacEomRepService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiacs350".equals(ACTION)) {
				giacEomRepService.saveGiacs350(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGiacs351".equals(ACTION)){
				JSONObject json = giacEomRepService.showGiacs351(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonEomRepDtlList", json);
					request.setAttribute("callFrom", request.getParameter("callFrom"));
					request.setAttribute("repCd", request.getParameter("repCd"));
					PAGE = "/pages/accounting/maintenance/monthEndRep/monthEndRepDtl.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("validateGLAcctNo".equals(ACTION)){
				giacEomRepService.validateGLAcctNo(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valAddDtlRec".equals(ACTION)){
				giacEomRepService.valAddDtlRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs351".equals(ACTION)) {
				giacEomRepService.saveGiacs351(request, USER.getUserId());
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
