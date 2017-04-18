package com.geniisys.gism.controllers;

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
import com.geniisys.gism.service.GISMMessageTemplateService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GISMMessageTemplateController", urlPatterns={"/GISMMessageTemplateController"})
public class GISMMessageTemplateController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GISMMessageTemplateService gismMesssageTemplateService = (GISMMessageTemplateService) APPLICATION_CONTEXT.getBean("gismMesssageTemplateService");
		
		try {
			if("showGisms002".equals(ACTION)){
				JSONObject json = gismMesssageTemplateService.showGisms002(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonMessageTemplateList", json);
					PAGE = "/pages/sms/tableMaintenance/messageTemplate/messageTemplate.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				gismMesssageTemplateService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				gismMesssageTemplateService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGisms002".equals(ACTION)) {
				gismMesssageTemplateService.saveGisms002(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showReserveWord".equals(ACTION)) {
				JSONObject json = gismMesssageTemplateService.showGisms002ReserveWord(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonReserveWord", json);
					PAGE = "/pages/sms/tableMaintenance/messageTemplate/subPages/reserveWord.jsp";
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
