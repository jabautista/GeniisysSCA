/** 
 *  Created by   : Gzelle
 *  Date Created : 10-27-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.controllers;

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
import com.geniisys.giac.service.GIACGlAccountTypesService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACGlAccountTypesController", urlPatterns={"/GIACGlAccountTypesController"})
public class GIACGlAccountTypesController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2234016833393501273L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACGlAccountTypesService giacGlAccountTypesService = (GIACGlAccountTypesService) APPLICATION_CONTEXT.getBean("giacGlAccountTypesService");
		
		try {
			if("showGiacs340".equals(ACTION)){
				JSONObject json = giacGlAccountTypesService.showGiacs340(request);
				if(request.getParameter("refresh") == null) {
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					String[] params = {"YES NO"};
					List<LOV> activeTagLOV = lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, params);
					request.setAttribute("activeTagLOV", activeTagLOV);
					request.setAttribute("jsonGlAccountTypes", json);			
					PAGE = "/pages/accounting/maintenance/glAccountTypes/glAccountTypes.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDelGlAcctType".equals(ACTION)){
				giacGlAccountTypesService.valDelGlAcctType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddGlAcctType".equals(ACTION)){
				giacGlAccountTypesService.valAddGlAcctType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";		
			} else if ("valUpdGlAcctType".equals(ACTION)){
				giacGlAccountTypesService.valUpdGlAcctType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";					
			} else if ("saveGiacs340".equals(ACTION)) {
				giacGlAccountTypesService.saveGiacs340(request, USER.getUserId());
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
