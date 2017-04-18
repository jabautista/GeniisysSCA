package com.geniisys.gicl.controllers;

import java.io.IOException;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISRecoveryTypeService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLClaimsRecoveryRegisterController", urlPatterns="/GICLClaimsRecoveryRegisterController")
public class GICLClaimsRecoveryRegisterController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static Logger log = Logger.getLogger(GICLClaimsRecoveryRegisterController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		log.info("");
		
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISLineFacadeService giisLineFacadeService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
			GIISISSourceFacadeService giisIssourceFacadeService = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
			GIISRecoveryTypeService giisRecoveryTypeService = (GIISRecoveryTypeService) APPLICATION_CONTEXT.getBean("giisRecoveryTypeService");
			GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
			
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			if("showClaimsRecoveryRegisterPage".equals(ACTION)){
				PAGE = "/pages/claims/reports/claimsRecoveryRegister/claimsRecoveryRegister.jsp";
				
			}else if("showPrintWindow".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);	
				JSONArray result = new JSONArray(giisReportsService.getGicls201Reports());
				System.out.println(result.toString());
				
				request.setAttribute("printers", printers);
				request.setAttribute("reportsList", result);
				
				PAGE = "/pages/claims/reports/claimsRecoveryRegister/printRecoveryRegister.jsp";
				
			}else if("getLineNameGicls201".equals(ACTION)){
				message = giisLineFacadeService.getLineNameGicls201(request, USER.getUserId());
				System.out.println("getLineNameGicls201: "+message);
				
			}else if("getIssNameGicls201".equals(ACTION)){
				message = giisIssourceFacadeService.getIssNameGicls201(request, USER.getUserId());
				System.out.println("getIssNameGicls201: "+message);
				
			}else if("getRecTypeDescGicls201".equals(ACTION)){
				message = giisRecoveryTypeService.getRecTypeDescGicls201(request);
				System.out.println("getRecTypeDesc: "+message);
			}
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			log.error(message);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
