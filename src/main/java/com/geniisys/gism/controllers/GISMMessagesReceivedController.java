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
import com.geniisys.gism.service.GISMMessagesReceivedService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GISMMessagesReceivedController", urlPatterns={"/GISMMessagesReceivedController"})
public class GISMMessagesReceivedController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GISMMessagesReceivedService gismMessagesReceivedService = (GISMMessagesReceivedService) APPLICATION_CONTEXT.getBean("gismMessagesReceivedService");
		
		try {
			if("showMessagesReceived".equals(ACTION)){
				JSONObject json = gismMessagesReceivedService.getMessagesReceived(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("messagesReceivedJSON", json);
					PAGE = "/pages/sms/inquiry/messageReceived/messagesReceived.jsp";
				}
			}else if("showMessageDetail".equals(ACTION)){
				request.setAttribute("detail", gismMessagesReceivedService.getMessageDetail(request));
				PAGE = "/pages/sms/inquiry/messageReceived/popups/messageDetails.jsp";
			}else if("showReplyOverlay".equals(ACTION)){
				PAGE = "/pages/sms/inquiry/messageReceived/popups/replyOverlay.jsp";
			}else if("replyToMessage".equals(ACTION)){
				gismMessagesReceivedService.replyToMessage(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showSMSErrorLog".equals(ACTION)){
				JSONObject jsonTG = gismMessagesReceivedService.getSMSErrorLog(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonTG.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonTG", jsonTG);
					PAGE = "/pages/sms/inquiry/smsErrorLog/smsErrorLog.jsp";
				}				
			}else if ("gisms008Assign".equals(ACTION)){
				gismMessagesReceivedService.gisms008Assign(request, USER.getUserId());
				message = "SUCCESS";
			}else if ("gisms008Purge".equals(ACTION)){
				gismMessagesReceivedService.gisms008Purge(request, USER.getUserId());
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
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
