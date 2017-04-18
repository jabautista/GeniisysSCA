package com.geniisys.giis.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giis.service.GIISIndustryService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISIndustryController", urlPatterns={"/GIISIndustryController"})
public class GIISIndustryController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISIndustryService giisIndustryService = (GIISIndustryService) APPLICATION_CONTEXT.getBean("giisIndustryService");
		
		try {
			
			if("showGiiss014".equals(ACTION)) {
				PAGE = "/pages/underwriting/fileMaintenance/general/assured/assuredType/assuredType.jsp";
			} else if ("getGIISS014IndustryList".equals(ACTION)) {
				JSONObject json = giisIndustryService.getGIISS014IndustryList(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteRec".equals(ACTION)){
				giisIndustryService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisIndustryService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss014".equals(ACTION)) {
				giisIndustryService.saveGiiss014(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valUpdateRec".equals(ACTION)) {
				giisIndustryService.valUpdateRec(request);
				message = "SUCCESS";
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
