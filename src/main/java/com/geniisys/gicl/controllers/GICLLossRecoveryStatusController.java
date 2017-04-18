package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLLossRecoveryStatusService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLLossRecoveryStatusController", urlPatterns={"/GICLLossRecoveryStatusController"})
public class GICLLossRecoveryStatusController extends BaseController{
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLLossRecoveryStatusService giclLossRecoveryStatusService = (GICLLossRecoveryStatusService) APPLICATION_CONTEXT.getBean("giclLossRecoveryStatusService");
			
			if("showLossRecoveryStatus".equals(ACTION)){
				JSONObject json = giclLossRecoveryStatusService.showLossRecoveryStatus(request, USER);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/recoveryStatus/recoveryStatus.jsp";
				}
 			} else if("showGICLS269RecoveryDetails".equals(ACTION)){
 				JSONObject json = giclLossRecoveryStatusService.showGICLS269RecoveryDetails(request, USER); 			
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/recoveryStatus/recoveryDetails.jsp";				
				}
 			} else if("showGICLS269RecoveryHistory".equals(ACTION)){
 				JSONObject json = giclLossRecoveryStatusService.showGICLS269RecoveryHistory(request, USER);
 				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/recoveryStatus/recoveryHistory.jsp";				
				}
 			}
			
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
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
