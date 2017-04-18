package com.geniisys.giac.controllers;

import java.io.IOException;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;

@WebServlet (name="GIACBookedUnbookedCollections", urlPatterns="/GIACBookedUnbookedCollections")
public class GIACBookedUnbookedCollections extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 288651291942984652L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			if("showBookedUnbookedCollections".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/reports/bookedUnbookedCollections/bookedUnbookedCollections.jsp";
			}
		} catch (Exception e) {
			ExceptionHandler.logException(e, USER.getUserId());
			message = "";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
}
