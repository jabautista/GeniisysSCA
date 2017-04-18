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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;


@WebServlet (name="GICLClaimReportsController", urlPatterns={"/GICLClaimReportsController"})
public class GICLClaimReportsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3684679846574777425L;
	
	private static Logger log = Logger.getLogger(GICLClaimReportsController.class);
	
	private PrintServiceLookup printServiceLookup;
	
	@SuppressWarnings("static-access")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		log.info("Initializing: "+ this.getClass().getSimpleName());
		
		try{
			if ("showOutstandingLOA".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/claims/reports/outstandingLOA/outstandingLOA.jsp";
			}else if ("showReportedClaims".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/claims/reports/reportedClaims/reportedClaims.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
