package com.geniisys.giis.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giis.service.GIISBinderStatusService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISBinderStatusController", urlPatterns={"/GIISBinderStatusController"})
public class GIISBinderStatusController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISBinderStatusService giisBinderStatusService = (GIISBinderStatusService) APPLICATION_CONTEXT.getBean("giisBinderStatusService");
				
		try {
			if("showGiiss209".equals(ACTION)){
				JSONObject json = giisBinderStatusService.showGiiss209(request);
				if(request.getParameter("refresh") == null) {
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					String[] params = {"GIIS_BINDER_STATUS.BNDR_TAG"};
					List<LOV> bndrTagLOV = lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, params);
					request.setAttribute("bndrTagLOV", bndrTagLOV);
					request.setAttribute("jsonBinderStatusList", json);					
					PAGE = "/pages/underwriting/fileMaintenance/reinsurance/binderStatus/binderStatus.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} 
			} else if ("saveGiiss209".equals(ACTION)) {
				giisBinderStatusService.saveGiiss209(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddBinderStatus".equals(ACTION)){
				giisBinderStatusService.valAddBinderStatus(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valDeleteRec".equals(ACTION)){
				giisBinderStatusService.valDeleteRec(request);
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
