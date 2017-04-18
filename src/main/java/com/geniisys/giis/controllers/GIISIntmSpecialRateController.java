package com.geniisys.giis.controllers;

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
import com.geniisys.giis.service.GIISIntmSpecialRateService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISIntmSpecialRateController", urlPatterns={"/GIISIntmSpecialRateController"})
public class GIISIntmSpecialRateController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISIntmSpecialRateService giisIntmSpecialRateService = (GIISIntmSpecialRateService) APPLICATION_CONTEXT.getBean("giisIntmSpecialRateService");
		
		try {
			if("showGIISS082".equals(ACTION)){
				if(request.getParameter("refresh") == null) {
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryCommRate/intmCommRate.jsp";
				}else{
					JSONObject json = giisIntmSpecialRateService.showGIISS082(request);
					json.append("perilList", giisIntmSpecialRateService.getPerilList(request));
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showHistory".equals(ACTION)){
				JSONObject json = giisIntmSpecialRateService.showHistory(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("historyJSON", json);
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryCommRate/overlay/intmCommRateHistory.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("populatePerils".equals(ACTION)){
				giisIntmSpecialRateService.populatePerils(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showCopyOverlay".equals(ACTION)){
				PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryCommRate/overlay/copyIntmCommRate.jsp";
			}else if("copyIntmRate".equals(ACTION)){
				giisIntmSpecialRateService.copyIntmRate(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGIISS082".equals(ACTION)){
				giisIntmSpecialRateService.saveGIISS082(request, USER.getUserId());
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
