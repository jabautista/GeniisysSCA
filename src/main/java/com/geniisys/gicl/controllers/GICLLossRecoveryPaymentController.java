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
import com.geniisys.gicl.service.GICLLossRecoveryPaymentService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLLossRecoveryPaymentController", urlPatterns={"/GICLLossRecoveryPaymentController"})
public class GICLLossRecoveryPaymentController extends BaseController{
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLLossRecoveryPaymentService giclLossRecoveryPaymentService = (GICLLossRecoveryPaymentService) APPLICATION_CONTEXT.getBean("giclLossRecoveryPaymentService");
			
			if("showLossRecoveryPayment".equals(ACTION)){
				JSONObject json = giclLossRecoveryPaymentService.showLossRecoveryPayment(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/lossRecoveryPayment/lossRecoveryPayment.jsp";				
				}
 			} else if("showGICLS270PaymentDetails".equals(ACTION)){
 				JSONObject json = giclLossRecoveryPaymentService.showGICLS270PaymentDetails(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/lossRecoveryPayment/paymentDetails.jsp";				
				}
 			} else if("showGICLS270DistributionDs".equals(ACTION)){
 				JSONObject json = giclLossRecoveryPaymentService.showGICLS270DistributionDs(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/lossRecoveryPayment/distributionDetails.jsp";				
				}
 			} else if("showGICLS270DistributionRids".equals(ACTION)){
 				JSONObject json = giclLossRecoveryPaymentService.showGICLS270DistributionRids(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/lossRecoveryPayment/distributionDetails.jsp";				
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
