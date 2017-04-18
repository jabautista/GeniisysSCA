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
import com.geniisys.giis.service.GIISControlTypeService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISControlTypeController", urlPatterns={"/GIISControlTypeController"})
public class GIISControlTypeController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISControlTypeService giisControlTypeService = (GIISControlTypeService) APPLICATION_CONTEXT.getBean("giisControlTypeService");
		
		try {
			if("showGiiss108".equals(ACTION)){
				JSONObject json = giisControlTypeService.showGIISS108(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					JSONObject allRecList = giisControlTypeService.getAllRecList(request, USER.getUserId());
					request.setAttribute("controlTypeJSON", json);
					request.setAttribute("allRecList", allRecList);
					PAGE = "/pages/underwriting/fileMaintenance/general/assured/controlType/controlType.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("valAddRec".equals(ACTION)){
				giisControlTypeService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGIISS108".equals(ACTION)) {
				giisControlTypeService.saveGIISS108(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDelRec".equals(ACTION)){
				giisControlTypeService.valDelRec(request);
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
