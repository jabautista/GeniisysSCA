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
import com.geniisys.common.service.GIISPolicyTypeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISPolicyTypeController", urlPatterns={"/GIISPolicyTypeController"})
public class GIISPolicyTypeController extends BaseController{

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
		GIISPolicyTypeService giisPolicyTypeService = (GIISPolicyTypeService) APPLICATION_CONTEXT.getBean("giisPolicyTypeService");
		
		try {
			if("showGiiss091".equals(ACTION)){
				JSONObject json = giisPolicyTypeService.showGiiss091(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					JSONObject allLineCdTypeCd = giisPolicyTypeService.getAllLineCdTypeCd(request);
					JSONObject allTypeDesc = giisPolicyTypeService.getAllTypeDesc(request);
					request.setAttribute("jsonPolicyTypeList", json);
					request.setAttribute("allLineCdTypeCd", allLineCdTypeCd);
					request.setAttribute("allTypeDesc", allTypeDesc);
					PAGE = "/pages/underwriting/fileMaintenance/policyType/policyType.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				giisPolicyTypeService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisPolicyTypeService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss091".equals(ACTION)) {
				giisPolicyTypeService.saveGiiss091(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valTypeDesc".equals(ACTION)){
				giisPolicyTypeService.valTypeDesc(request);
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
