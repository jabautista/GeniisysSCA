package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLBiggestClaimService;
import com.seer.framework.util.ApplicationContextReader;


@WebServlet (name="GICLBiggestClaimsController", urlPatterns={"/GICLBiggestClaimsController"})
public class GICLBiggestClaimsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GICLBiggestClaimsController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLBiggestClaimService giclBiggestClaimService = (GICLBiggestClaimService) APPLICATION_CONTEXT.getBean("giclBiggestClaimService"); 
		
		try{
			if("showBiggestClaims".equals(ACTION)){
				PAGE = "/pages/claims/reports/biggestClaims/biggestClaims.jsp";
			} else if("whenNewFormInstanceGICLS220".equals(ACTION)){
				message = giclBiggestClaimService.whenNewFormInstanceGICLS220(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("extractGICLS220".equals(ACTION)){
				message = giclBiggestClaimService.extractGICLS220(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("extractParametersExistGicls220".equals(ACTION)){
				message = giclBiggestClaimService.extractParametersExistGicls220(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e){
			System.out.println(e.getErrorCode());
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
