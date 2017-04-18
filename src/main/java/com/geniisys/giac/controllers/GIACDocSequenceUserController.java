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
import com.geniisys.giac.service.GIACDocSequenceUserService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIACDocSequenceUserController", urlPatterns={"/GIACDocSequenceUserController"})
public class GIACDocSequenceUserController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACDocSequenceUserService giacDocSequenceUserService = (GIACDocSequenceUserService) APPLICATION_CONTEXT.getBean("giacDocSequenceUserService");
		
		try {
			if("showGiacs316".equals(ACTION)){
				JSONObject json = giacDocSequenceUserService.showGiacs316(request, USER.getUserId());
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					PAGE = "/pages/accounting/maintenance/docSequencePerUser/docSequencePerUser.jsp";
				}				
			} else if ("valDeleteRec".equals(ACTION)){
				giacDocSequenceUserService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giacDocSequenceUserService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs316".equals(ACTION)) {
				giacDocSequenceUserService.saveGiacs316(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateMinSeqNo".equals(ACTION)){
				giacDocSequenceUserService.valMinSeqNo(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateMaxSeqNo".equals(ACTION)){
				giacDocSequenceUserService.valMaxSeqNo(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateActiveTag".equals(ACTION)){
				giacDocSequenceUserService.valActiveTag(request);
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
