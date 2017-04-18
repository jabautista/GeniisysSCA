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
import com.geniisys.giis.service.GIISSlidCommService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISSlidCommController", urlPatterns={"/GIISSlidCommController"})
public class GIISSlidCommController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISSlidCommService giisSlidCommService = (GIISSlidCommService) APPLICATION_CONTEXT.getBean("giisSlidCommService");
		
		try {
			if("showGIISS220".equals(ACTION)){
				PAGE = "/pages/underwriting/fileMaintenance/intermediary/slidingCommRate/slidingCommRate.jsp";
			}else if("getPerils".equals(ACTION)){
				JSONObject json = giisSlidCommService.getPerils(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getSlidingComm".equals(ACTION)){
				JSONObject json = giisSlidCommService.getSlidingComm(request);
				json.append("rateList", giisSlidCommService.getRateList(request));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showHistory".equals(ACTION)){
				JSONObject json = giisSlidCommService.getHistory(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("perilCd", request.getParameter("perilCd"));
					request.setAttribute("perilName", request.getParameter("perilName"));
					request.setAttribute("historyJSON", json.toString());
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/slidingCommRate/overlay/slidingCommHistoryOverlay.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("checkRate".equals(ACTION)){
				giisSlidCommService.checkRate(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGIISS220".equals(ACTION)){
				giisSlidCommService.saveGIISS220(request, USER.getUserId());
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
