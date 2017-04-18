package com.geniisys.gicl.controllers;

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
import com.geniisys.gicl.service.GICLRepairTypeService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLRepairTypeController", urlPatterns={"/GICLRepairTypeController"})
public class GICLRepairTypeController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLRepairTypeService giclRepairTypeService = (GICLRepairTypeService) APPLICATION_CONTEXT.getBean("repairTypeService");
		
		try {
			if("showGicls172".equals(ACTION)){
				JSONObject json = giclRepairTypeService.showGicls172(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonRepairTypeList", json);
					PAGE = "/pages/claims/tableMaintenance/motorCarRepairType/motorCarRepairType.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valAddRec".equals(ACTION)){
				giclRepairTypeService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGicls172".equals(ACTION)) {
				giclRepairTypeService.saveGicls172(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("valDeleteRec".equals(ACTION)){
				giclRepairTypeService.valDelRec(request);
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
