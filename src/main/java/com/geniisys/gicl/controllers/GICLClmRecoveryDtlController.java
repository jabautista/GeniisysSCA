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
import com.geniisys.gicl.service.GICLClmRecoveryDtlService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GICLClmRecoveryDtlController", urlPatterns="/GICLClmRecoveryDtlController")
public class GICLClmRecoveryDtlController extends BaseController{

	private Logger log = Logger.getLogger(GICLClmRecoveryDtlController.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLClmRecoveryDtlService giclClmRecoveryDtlService = (GICLClmRecoveryDtlService) APPLICATION_CONTEXT.getBean("giclClmRecoveryDtlService");
			PAGE = "/pages/genericMessage.jsp";
			
			if("showRecoveryDtl".equals(ACTION)){
				log.info("Getting recovery details...");
				giclClmRecoveryDtlService.getGiclClmRecoveryDtlGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/lossRecovery/recoveryInformation/subPages/recoveryDetails.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
		}catch(JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
		//}catch(ParseException e) {
			//message = ExceptionHandler.handleException(e, USER);
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
