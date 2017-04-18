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
import com.geniisys.gicl.service.GICLLossExpSettlementService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLLossExpSettlementController", urlPatterns={"/GICLLossExpSettlementController"})
public class GICLLossExpSettlementController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLLossExpSettlementService giclLossExpSettlementService = (GICLLossExpSettlementService) APPLICATION_CONTEXT.getBean("giclLossExpSettlementService");
		
		
		try {
			if("showGICLS060".equals(ACTION)){
				JSONObject json = giclLossExpSettlementService.showGicls060(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonLossExpSettlementStatus", json);
					PAGE = "/pages/claims/tableMaintenance/lossExpSettlementStatus/lossExpSettlementStatus.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				message = giclLossExpSettlementService.valDeleteRec(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giclLossExpSettlementService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGicls060".equals(ACTION)) {
				giclLossExpSettlementService.saveGicls060(request, USER.getUserId());
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
