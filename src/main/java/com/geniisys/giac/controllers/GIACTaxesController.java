package com.geniisys.giac.controllers;

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
import com.geniisys.giac.service.GIACTaxesService;
import com.seer.framework.util.ApplicationContextReader;


@WebServlet (name="GIACTaxesController", urlPatterns={"/GIACTaxesController"})
public class GIACTaxesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACTaxesService giacTaxesService = (GIACTaxesService) APPLICATION_CONTEXT.getBean("giacTaxesService");
		
		try {
			if("showGIACS320".equals(ACTION)){
				JSONObject json = giacTaxesService.showGIACS320(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("taxJSON", json);
					PAGE = "/pages/accounting/maintenance/tax/taxMaintenance.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("valDeleteRec".equals(ACTION)){
				giacTaxesService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valAddRec".equals(ACTION)){
				giacTaxesService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGIACS320".equals(ACTION)) {
				giacTaxesService.saveGIACS320(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkAccountCode".equals(ACTION)){
				message = giacTaxesService.checkAccountCode(request).toString();
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
