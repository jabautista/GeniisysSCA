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
import com.geniisys.common.service.GIISIntmTypeComrtService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISIntmTypeComrtController", urlPatterns={"/GIISIntmTypeComrtController"})
public class GIISIntmTypeComrtController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISIntmTypeComrtService giisIntmTypeComrtService = (GIISIntmTypeComrtService) APPLICATION_CONTEXT.getBean("giisIntmTypeComrtService");
		
		try {
			if("showGiiss084".equals(ACTION)){
				JSONObject json = giisIntmTypeComrtService.showGiiss084(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonCoIntmTypeComrtList", json);
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/coIntmTypeComrt/coIntmTypeComrt.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("saveGiiss084".equals(ACTION)) {
				giisIntmTypeComrtService.saveGiiss084(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showCommRateHistoryOverlay".equals(ACTION)) {
				JSONObject json = giisIntmTypeComrtService.showGiiss084History(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonCommRateHistList", json);
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/coIntmTypeComrt/commRateHistory.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				request.setAttribute("issCd", request.getParameter("issCd"));
				request.setAttribute("issName", request.getParameter("issName"));
				request.setAttribute("coIntmType", request.getParameter("coIntmType"));
				request.setAttribute("coIntmName", request.getParameter("coIntmName"));
				request.setAttribute("lineCd", request.getParameter("lineCd"));
				request.setAttribute("lineName", request.getParameter("lineName"));
				request.setAttribute("sublineCd", request.getParameter("sublineCd"));
				request.setAttribute("sublineName", request.getParameter("sublineName"));
			}else if("valAddRec".equals(ACTION)){
				giisIntmTypeComrtService.valAddRec(request);
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
