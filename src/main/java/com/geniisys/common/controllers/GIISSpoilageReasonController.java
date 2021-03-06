/**
 * 
 */
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
import com.geniisys.common.service.GIISSpoilageReasonService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

/**
 * @author steven
 *
 */
@WebServlet(name = "GIISSpoilageReasonController", urlPatterns= "/GIISSpoilageReasonController")
public class GIISSpoilageReasonController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7146344248757436962L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISSpoilageReasonService giisSpoilageReasonService = (GIISSpoilageReasonService) APPLICATION_CONTEXT.getBean("giisSpoilageReasonService");
		try {
			if("showGiiss212".equals(ACTION)){
				JSONObject json = giisSpoilageReasonService.showGiiss212(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIISSpoilageReason", json);
					PAGE = "/pages/underwriting/fileMaintenance/reasons/reasonForSpoilage/reasonForSpoilage.jsp";
				}				
			} else if ("valDeleteRec".equals(ACTION)){
				giisSpoilageReasonService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisSpoilageReasonService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss212".equals(ACTION)) {
				giisSpoilageReasonService.saveGiiss212(request, USER.getUserId());
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
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
