package com.geniisys.giuts.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.giuts.service.ExtractExpiringCovernoteService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="ExtractExpiringCovernoteController", urlPatterns="/ExtractExpiringCovernoteController")
public class ExtractExpiringCovernoteController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(ExtractExpiringCovernoteController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			ExtractExpiringCovernoteService extractExpiringCovernoteService = (ExtractExpiringCovernoteService) APPLICATION_CONTEXT.getBean("extractExpiringCovernoteService");
			
			if("showExtractExpiringCovernote".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/underwriting/reportsPrinting/extractExpiringCovernote/extractExpiringCovernote.jsp";
			} else if("whenNewFormInstanceGIUTS031".equals(ACTION)){
				message = extractExpiringCovernoteService.whenNewFormInstanceGIUTS031(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("extractGIUTS031".equals(ACTION)){
				message = extractExpiringCovernoteService.extractGIUTS031(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateExtractParameters".equals(ACTION)){
				message = extractExpiringCovernoteService.validateExtractParameters(request, USER.getUserId());
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
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
