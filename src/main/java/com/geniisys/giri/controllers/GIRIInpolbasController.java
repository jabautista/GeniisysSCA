package com.geniisys.giri.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

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
import com.geniisys.giri.service.GIRIInpolbasService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIRIInpolbasController", urlPatterns={"/GIRIInpolbasController"})
public class GIRIInpolbasController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIRIInpolbasService giriInpolbasService = (GIRIInpolbasService) APPLICATION_CONTEXT.getBean("giriInpolbasService");
			
			if("viewInwardRiPaymentStatus".equals(ACTION)){
				JSONObject json = giriInpolbasService.getInwardRiPaymentStatus(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/riInquiries/inwardRiPaymentStatus/viewInwardRiPaymentStatus.jsp";					
				}
			}else if("showInwRiDetailsOverlay".equals(ACTION)){ // jomsdiago 09.10.2013
				JSONObject json = giriInpolbasService.showInwRiDetailsOverlay(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/riInquiries/inwardRiPaymentStatus/viewInwardRiPaymentDtls.jsp";				
				}
			}else if("showOutwardRiPaymentStatus".equals(ACTION)){ //pol cruz
				JSONObject jsonGIRIS012MainTG = giriInpolbasService.showGIRIS012MainTableGrid(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonGIRIS012MainTG.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonGIRIS012MainTG", jsonGIRIS012MainTG);
					PAGE = "/pages/underwriting/riInquiries/outwardRiPaymentStatus/viewOutwardRiPaymentStatus.jsp";					
				 }
			}else if("showGIRIS012Details".equals(ACTION)){
				JSONObject jsonGIRIS012Details = giriInpolbasService.showGIRIS012Details(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonGIRIS012Details.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonGIRIS012Details", jsonGIRIS012Details);
					PAGE = "/pages/underwriting/riInquiries/outwardRiPaymentStatus/viewOutwardRiPaymentStatusDetails.jsp";					
				 }
			}else if ("showBinderList".equals(ACTION)){
				JSONObject jsonGIUTS030BinderList = giriInpolbasService.getGIUTS030BinderList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonGIUTS030BinderList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonGIUTS030BinderList", jsonGIUTS030BinderList);
					PAGE = "/pages/underwriting/riInquiries/binderList/binderList.jsp";					
				}
			}else if ("showInitialAcceptance".equals(ACTION)){
				PAGE = "/pages/underwriting/riInquiries/initialAcceptance/initialAcceptance.jsp";
			}else if ("populateGiris027".equals(ACTION)){
				JSONObject jsonGIRIS027 = giriInpolbasService.populateGiris027(request, USER);
				message = jsonGIRIS027.toString();
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
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
