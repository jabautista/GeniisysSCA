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
import com.geniisys.gism.service.GISMMessagesSentService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GISMMessagesSentController", urlPatterns={"/GISMMessagesSentController"})
public class GISMMessagesSentController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GISMMessagesSentService gismMessagesSentService = (GISMMessagesSentService) APPLICATION_CONTEXT.getBean("gismMessagesSentService");
		
		try {
			if("showMessagesSent".equals(ACTION)){
				JSONObject json = gismMessagesSentService.getMessagesSent(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("messagesSentJSON", json);
					PAGE = "/pages/sms/inquiry/messageSent/messagesSent.jsp";
				}
			}else if("showMessageDetails".equals(ACTION)){
				JSONObject json = gismMessagesSentService.getMessageDetails(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("messageDetailsJSON", json);
					PAGE = "/pages/sms/inquiry/messageSent/popups/messageDetails.jsp";
				}
			}else if("resendMessage".equals(ACTION)){
				gismMessagesSentService.resendMessage(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showCreateSendMessages".equals(ACTION)){
				JSONObject json = gismMessagesSentService.getCreatedMessages(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("messageJSON", json);
					PAGE = "/pages/sms/sendMessage/createMessage.jsp";
				}
			}else if("cancelMessage".equals(ACTION)){
				gismMessagesSentService.cancelMessage(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCreatedMessageDetails".equals(ACTION)){
				JSONObject json = gismMessagesSentService.getCreatedMessagesDtl(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showRecipientOverlay".equals(ACTION)){
				JSONObject json = gismMessagesSentService.getRecipientList(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("recipientJSON", json);
					PAGE = "/pages/sms/sendMessage/popups/recipientListing.jsp";
				}
			}else if("saveMessages".equals(ACTION)){
				gismMessagesSentService.saveMessages(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateCellphoneNo".equals(ACTION)){
				message = gismMessagesSentService.validateCellphoneNo(request);
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
