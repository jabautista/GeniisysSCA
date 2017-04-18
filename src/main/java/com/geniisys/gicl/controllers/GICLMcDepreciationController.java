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
import com.geniisys.gicl.service.GICLMcDepreciationService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GICLMcDepreciationController", urlPatterns="/GICLMcDepreciationController")
public class GICLMcDepreciationController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5206049556007352022L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLMcDepreciationService giclMcDepreciationService = (GICLMcDepreciationService) APPLICATION_CONTEXT.getBean("giclMcDepreciationService");
		try {
			if("showGicls059".equals(ACTION)){
				JSONObject json = giclMcDepreciationService.showGicls059(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGICLMcDepreciation", json);
					PAGE = "/pages/claims/tableMaintenance/motorCarDepreciationRate/motorCarDepreciationRate.jsp";
				}				
			} else if ("saveGicls059".equals(ACTION)) {
				giclMcDepreciationService.saveGicls059(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giclMcDepreciationService.valAddRec(request);
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
