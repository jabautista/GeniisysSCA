package com.geniisys.gixx.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gixx.entity.GIXXMainCoIns;
import com.geniisys.gixx.service.GIXXMainCoInsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIXXMainCoInsController", urlPatterns="/GIXXMainCoInsController")
public class GIXXMainCoInsController  extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXMainCoInsController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIXXMainCoInsService gixxMainCoInsService = (GIXXMainCoInsService) APPLICATION_CONTEXT.getBean("gixxMainCoInsService");
			
			if("getGIXXMainCoInsInfo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				GIXXMainCoIns mainCoIns = gixxMainCoInsService.getGIXXMainCoInsInfo(params);
				if(mainCoIns != null) {
					request.setAttribute("policyMainCoIns", new JSONObject(mainCoIns));
				}
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyCoInsurers.jsp";
			}
		}  catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
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
