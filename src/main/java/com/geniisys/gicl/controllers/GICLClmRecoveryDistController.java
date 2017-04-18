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
import com.geniisys.gicl.service.GICLClmRecoveryDistService;
import com.geniisys.gicl.service.GICLClmRecoveryService;
import com.geniisys.gicl.service.GICLRecoveryRidsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLClmRecoveryDistController", urlPatterns="/GICLClmRecoveryDistController")
public class GICLClmRecoveryDistController extends BaseController{

	private static final long serialVersionUID = 1L;
	Logger log = Logger.getLogger(GICLClmRecoveryDistController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLClmRecoveryService giclClmRecoveryService = (GICLClmRecoveryService) APPLICATION_CONTEXT.getBean("giclClmRecoveryService");
			GICLClmRecoveryDistService giclClmRecoveryDistService = (GICLClmRecoveryDistService) APPLICATION_CONTEXT.getBean("giclClmRecoveryDistService");
			GICLRecoveryRidsService giclRecoveryRidsService = (GICLRecoveryRidsService) APPLICATION_CONTEXT.getBean("giclRecoveryRidsService");
			
			PAGE = "/pages/genericMessage.jsp";
			
			if("showClmRecoveryDistribution".equals(ACTION)){
				giclClmRecoveryService.getClmRecoveryDistInfoGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/lossRecovery/recoveryDistribution/recoveryDistInfoMain.jsp";
			}else if ("getClmRecoveryDistGrid".equals(ACTION)){		
				message = giclClmRecoveryDistService.getClmRecoveryDistGrid(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getClmRecoveryRIDistGrid".equals(ACTION)){	
				message = giclRecoveryRidsService.getClmRecoveryRIDistGrid(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("distributeRecovery".equals(ACTION)){
				log.info("Distribute Recovery");
				System.out.println("Distribute recovery...");
				giclClmRecoveryDistService.distributeRecovery(request, USER);
			}else if("negateDistRecovery".equals(ACTION)){
				log.info("Negate Distribution Recovery");
				System.out.println("Negate Distribution Recovery...");
				giclClmRecoveryDistService.negateDistRecovery(request, USER);
			}else if("saveDistRecovery".equals(ACTION)){
				message = giclClmRecoveryDistService.saveRecoveryDist(request, USER);
			}
		} catch(SQLException e){
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
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}	
}
