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
import com.geniisys.giac.service.GIACDocSequenceService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACDocSequenceController", urlPatterns={"/GIACDocSequenceController"})
public class GIACDocSequenceController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACDocSequenceService giacDocSequenceService = (GIACDocSequenceService) APPLICATION_CONTEXT.getBean("giacDocSequenceService");
		
		try {
			if("showGiacs322".equals(ACTION)){
				JSONObject json = giacDocSequenceService.showGiacs322(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonDocSequence", json);
					request.setAttribute("fundCd", request.getParameter("fundCd"));
					request.setAttribute("fundDesc", request.getParameter("fundDesc"));
					request.setAttribute("branchCd", request.getParameter("branchCd"));
					request.setAttribute("branchName", request.getParameter("branchName"));
					PAGE = "/pages/accounting/maintenance/docSequencePerBranch/docSequencePerBranch.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				message = giacDocSequenceService.valDeleteRec(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				message = giacDocSequenceService.valAddRec(request);
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs322".equals(ACTION)) {
				giacDocSequenceService.saveGiacs322(request, USER.getUserId());
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
