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
import com.geniisys.common.service.GIISIntmdryTypeRtService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;


@WebServlet (name="GIISIntmdryTypeRtController", urlPatterns={"/GIISIntmdryTypeRtController"})
public class GIISIntmdryTypeRtController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISIntmdryTypeRtService giisIntmdryTypeRtService = (GIISIntmdryTypeRtService) APPLICATION_CONTEXT.getBean("giisIntmdryTypeRtService");
		
		try {
			if("showGiiss201".equals(ACTION)){
				if(request.getParameter("refresh") == null) {
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryTypeCommRate/intermediaryTypeCommRate.jsp";
				} else {
					JSONObject json = giisIntmdryTypeRtService.showGiiss201(request, USER.getUserId());
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("valDeleteRec".equals(ACTION)){
				giisIntmdryTypeRtService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGiiss201".equals(ACTION)) {
				giisIntmdryTypeRtService.saveGiiss201(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showHistoryOverlay".equals(ACTION)){
				JSONObject json = giisIntmdryTypeRtService.showGiiss201History(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonCommRate", json);
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryTypeCommRate/popups/intmTypeCommRateHistory.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
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
