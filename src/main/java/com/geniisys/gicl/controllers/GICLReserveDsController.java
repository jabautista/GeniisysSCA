package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLReserveDsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GICLReserveDsController", urlPatterns="/GICLReserveDsController")
public class GICLReserveDsController extends BaseController{

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLReserveDsController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLReserveDsService giclReserveDsService = (GICLReserveDsService) APPLICATION_CONTEXT.getBean("giclReserveDsService");
		
		message = "SUCCESS";
		PAGE = "/pages/genericMessage.jsp";
		
		try{
			if ("showDistDetailsPLA".equals(ACTION)){
				log.info("Getting Distribution Details...");
				giclReserveDsService.getGiclReserveDsGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/reserveSetup/preliminaryLossAdvice/subPages/plaDistDetails.jsp";
			}else if ("validateXolDeduc".equals(ACTION)) {
				log.info("validateXolDeduc...");
				message = giclReserveDsService.validateXolDeduc(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("continueXolDeduc".equals(ACTION)) {
				log.info("continueXolDeduc...");
				message = giclReserveDsService.continueXolDeduc(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkXOLAmtLimits".equals(ACTION)) {
				log.info("checkXOLAmtLimits...");
				message = giclReserveDsService.checkXOLAmtLimits(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("updateShrLossResGICLS024".equals(ACTION)){
				log.info("Updating Share Loss Reserve Amount...");
				giclReserveDsService.updateShrLossResGICLS024(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("updateShrPctGICLS024".equals(ACTION)){
				log.info("Updating Share Pct...");
				giclReserveDsService.updateShrPctGICLS024(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("updateShrExpResGICLS024".equals(ACTION)){
				log.info("Updating Share Pct...");
				giclReserveDsService.updateShrExpResGICLS024(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//}catch(ParseException e) {
		//	message = ExceptionHandler.handleException(e, USER);
		//	PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
