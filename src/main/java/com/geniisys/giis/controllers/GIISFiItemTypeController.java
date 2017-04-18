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
import com.geniisys.giis.service.GIISFiItemTypeService;
import com.geniisys.giis.service.GIISIndustryService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISFiItemTypeController", urlPatterns={"/GIISFiItemTypeController"})
public class GIISFiItemTypeController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISFiItemTypeService giisFiItemTypeService = (GIISFiItemTypeService) APPLICATION_CONTEXT.getBean("giisFiItemTypeService");
		
		try {
			
			if("showGiiss012".equals(ACTION)){
				
				JSONObject json = giisFiItemTypeService.getGiiss012FiItemType(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonFrItemType", json);
					PAGE = "/pages/underwriting/fileMaintenance/fire/fireItemType/fireItemTypeMaintenance.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("giiss012ValAddRec".equals(ACTION)) {
				giisFiItemTypeService.giiss012ValAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("giiss012ValDelRec".equals(ACTION)) {
				giisFiItemTypeService.giiss012ValDelRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiiss012".equals(ACTION)) {
				giisFiItemTypeService.saveGiiss012(request, USER.getUserId());//USER.getUsername()); changed by robert to userid 12.09.14
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
