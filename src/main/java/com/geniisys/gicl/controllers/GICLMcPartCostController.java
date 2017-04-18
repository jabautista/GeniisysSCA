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
import com.geniisys.gicl.service.GICLMcPartCostService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLMcPartCostController", urlPatterns={"/GICLMcPartCostController"})
public class GICLMcPartCostController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLMcPartCostService giclMcPartCostService = (GICLMcPartCostService) APPLICATION_CONTEXT.getBean("mcPartCostService");
		
		try {
			if("showGicls058".equals(ACTION)){
				JSONObject json = giclMcPartCostService.showGicls058(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonMcPartCostList", json);
					PAGE = "/pages/claims/tableMaintenance/motorCarReplacementPart/motorCarReplacementPart.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				giclMcPartCostService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giclMcPartCostService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGicls058".equals(ACTION)) {
				giclMcPartCostService.saveGicls058(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showMotorCarPartCostHistory".equals(ACTION)) {
				JSONObject json = giclMcPartCostService.showGicls058History(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonMcPartCostListHistory", json);
					PAGE = "/pages/claims/tableMaintenance/motorCarReplacementPart/subPages/replacementPartHistory.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("valModelYear".equals(ACTION)) {
				message = giclMcPartCostService.valModelYear(request);
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
