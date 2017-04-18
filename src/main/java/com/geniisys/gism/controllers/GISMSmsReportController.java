package com.geniisys.gism.controllers;

import java.io.IOException;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.gism.service.GISMSmsReportService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GISMSmsReportController", urlPatterns={"/GISMSmsReportController"})
public class GISMSmsReportController extends BaseController{

	private static final long serialVersionUID = 1164314559935969126L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GISMSmsReportService gismSmsReportService = (GISMSmsReportService) APPLICATION_CONTEXT.getBean("gismSmsReportService");
		
		try{
			if("showSmsReportPrinting".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/sms/smsReportPrinting/smsReportPrinting.jsp";
			} else if("populateSmsReportPrint".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(gismSmsReportService.populateSmsReportPrint(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateGisms012User".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(gismSmsReportService.validateGisms012User(request))));
				PAGE = "/pages/genericObject.jsp";
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
