package com.geniisys.common.controllers;

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
import com.geniisys.common.service.GIISPayeeClassService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISPayeeClassController", urlPatterns={"/GIISPayeeClassController"})
public class GIISPayeeClassController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISPayeeClassService giisPayeeClassService = (GIISPayeeClassService) APPLICATION_CONTEXT.getBean("giisPayeeClassService");
		
		try {
			if("showGicls140".equals(ACTION)){
				JSONObject json = giisPayeeClassService.showGicls140(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					String[] params = {"GIAC_SL_TYPES.SL_TAG"};
					List<LOV> slTagLOV = lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, params);
					request.setAttribute("payeeClassTag", slTagLOV);
					request.setAttribute("jsonPayeeClassList", json);
					PAGE = "/pages/claims/tableMaintenance/payeeClass/payeeClass.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				giisPayeeClassService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisPayeeClassService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGicls140".equals(ACTION)) {
				giisPayeeClassService.saveGicls140(request, USER.getUserId());
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
