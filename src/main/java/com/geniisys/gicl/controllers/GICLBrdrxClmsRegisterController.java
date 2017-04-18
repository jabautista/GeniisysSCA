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
import com.geniisys.gicl.service.GICLBrdrxClmsRegisterService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLBrdrxClmsRegisterController", urlPatterns={"/GICLBrdrxClmsRegisterController"})
public class GICLBrdrxClmsRegisterController extends BaseController{
	
	private static final long serialVersionUID = 1L;

	private static Logger log = Logger.getLogger(GICLBrdrxClmsRegisterController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLBrdrxClmsRegisterService giclBrdrxClmsRegisterService = (GICLBrdrxClmsRegisterService) APPLICATION_CONTEXT.getBean("giclBrdrxClmsRegisterService"); 
		try{
			if("showBordereauxClaimsRegister".equals(ACTION)){
				PAGE = "/pages/claims/reports/bordereauxClaimsRegister/bordereauxClaimsRegister.jsp";
			}else if("whenNewFormInstanceGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.whenNewFormInstanceGicls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("whenNewBlockE010Gicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.whenNewBlockE010Gicls202(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPolicyNumberGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.getPolicyNumberGicls202(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.extractGicls202(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateLineCd2Gicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validateLineCd2GIcls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateSublineCd2Gicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validateSublineCd2Gicls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateIssCd2Gicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validateIssCd2Gicls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateLineCdGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validateLineCdGIcls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateSublineCdGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validateSublineCdGicls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateIssCdGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validateIssCdGicls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateLossCatCdGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validateLossCatCdGicls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePerilCdGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validatePerilCdGicls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateIntmNoGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validateIntmNoGicls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateControlTypeCdGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.validateControlTypeCdGicls202(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("printGicls202".equals(ACTION)){
				message = giclBrdrxClmsRegisterService.printGicls202(request, USER.getUserId());
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
