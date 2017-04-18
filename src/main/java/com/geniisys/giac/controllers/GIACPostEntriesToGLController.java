package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACPostEntriesToGLService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACPostEntriesToGLController", urlPatterns="/GIACPostEntriesToGLController")
public class GIACPostEntriesToGLController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACPostEntriesToGLService giacPostEntriesToGLService = (GIACPostEntriesToGLService) APPLICATION_CONTEXT.getBean("giacPostEntriesToGLService");

		PAGE = "/pages/genericMessage.jsp";
		
		try{
			if ("showPostEntriesToGL".equals(ACTION)){
				PAGE = "/pages/accounting/endOfMonth/postEntriesToGL/postEntriesToGL.jsp";		
			}else if("getGLNo".equals(ACTION)){
				message = giacPostEntriesToGLService.getGLNo().toString();
				System.out.println("GL No: "+message);
			}else if("getFinanceEnd".equals(ACTION)){
				message = giacPostEntriesToGLService.getFinanceEnd().toString();
				System.out.println("Finance End: "+message);
			}else if("getFiscalEnd".equals(ACTION)){
				message = giacPostEntriesToGLService.getFiscalEnd().toString();
				System.out.println("Fiscal End: "+message);
			}else if("validateTranYear".equals(ACTION)){
				Integer tranYear = giacPostEntriesToGLService.validateTranYear(request);
				System.out.println("tranYear: "+tranYear);
				message = tranYear == null? "" : tranYear.toString();
			}else if("validateTranMonth".equals(ACTION)){
				message = giacPostEntriesToGLService.validateTranMonth(request);
			}else if("checkIsPrevMonthClosed".equals(ACTION)){
				giacPostEntriesToGLService.checkIsPrevMonthClosed(request);
				message = "SUCCESS";
			}else if ("postToGL".equals(ACTION)){
				message = giacPostEntriesToGLService.postToGL(request);
				System.out.println("postToGL: "+message);
			}
		}catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} /*catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} */catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}

}
