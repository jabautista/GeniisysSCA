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
import com.geniisys.giis.service.GIISBondClassService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISBondClassController", urlPatterns={"/GIISBondClassController"})
public class GIISBondClassController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISBondClassService giisBondClassService = (GIISBondClassService) APPLICATION_CONTEXT.getBean("giisBondClassService");
		
		try {
			
			if("showGiiss043".equals(ACTION)){				
				JSONObject json = giisBondClassService.getGiiss043BondClass(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonBondClass", json);
					PAGE = "/pages/underwriting/fileMaintenance/suretyBonds/defaultRate/defaultRate.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("saveGiiss043".equals(ACTION)) {
				giisBondClassService.saveGiiss043(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giiss043ValAddBondClass".equals(ACTION)){
				giisBondClassService.giiss043ValAddBondClass(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("giiss043ValDelBondClass".equals(ACTION)){
				giisBondClassService.giiss043ValDelBondClass(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGiiss043BondClassSubline".equals(ACTION)) {
				JSONObject json = giisBondClassService.getGiiss043BondClassSubline(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giiss043ValAddBondClassSubline".equals(ACTION)){
				giisBondClassService.giiss043ValAddBondClassSubline(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giiss043ValDelBondClassSubline".equals(ACTION)){
				giisBondClassService.giiss043ValDelBondClassSubline(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGiiss043BondClassRt".equals(ACTION)) {
				JSONObject json = giisBondClassService.getGiiss043BondClassRt(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("giiss043ValAddBondClassRt".equals(ACTION)) {
				giisBondClassService.giiss043ValAddBondClassRt(request);
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
