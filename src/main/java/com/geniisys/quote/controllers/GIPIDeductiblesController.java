package com.geniisys.quote.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.quote.service.GIPIDeductiblesService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIDeductiblesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIPIDeductiblesController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIDeductiblesService gipiDeductiblesService = (GIPIDeductiblesService)APPLICATION_CONTEXT.getBean("gipiDeductiblesService2");		
		
		try{
			//urlPattern for this controller is /GIPIQuoteDeductiblesController
			log.info("Initializing :"+this.getClass().getSimpleName());
			if("getDeductibleInfoTG".equals(ACTION)){		
				message = gipiDeductiblesService.getDeductibleInfoGrid(request);
				PAGE = "/pages/genericMessage.jsp";				
			}else if("saveDeductibleInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				message = gipiDeductiblesService.saveDeductibleInfo(request.getParameter("parameters"), params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkDeductibleText".equals(ACTION)){
				message = gipiDeductiblesService.checkDeductibleText();
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}	
	}
}
