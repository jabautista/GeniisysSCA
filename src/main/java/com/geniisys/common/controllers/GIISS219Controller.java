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
import com.geniisys.common.service.GIISS219Service;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

/**
 * @author steven
 *
 */
@WebServlet(name="GIISS219Controller", urlPatterns="/GIISS219Controller")
public class GIISS219Controller extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3723259836888055830L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISS219Service giiss219Service = (GIISS219Service) APPLICATION_CONTEXT.getBean("giiss219Service");
		try{
			if("showGiiss219".equals(ACTION)){
				JSONObject json = giiss219Service.showGiiss219(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIISS219", json);
					PAGE = "/pages/underwriting/fileMaintenance/multiLinePackage/packageProductMaintenance/packageProductMaintenance.jsp";
				}				
			} else if ("valDeleteRec".equals(ACTION)){
				giiss219Service.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giiss219Service.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss219".equals(ACTION)) {
				giiss219Service.saveGiiss219(request, USER.getUserId());
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
