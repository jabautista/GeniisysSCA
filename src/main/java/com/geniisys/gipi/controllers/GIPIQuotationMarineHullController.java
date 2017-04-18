/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemMHService;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIPIQuotationMarineHullController.
 */
public class GIPIQuotationMarineHullController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -1619422095584522160L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationMarineHullController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			/* Define Services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
			GIPIQuoteItemMHService mhService = (GIPIQuoteItemMHService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMHService"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			
			if ("showMarineHullAdditionalInformation".equals(ACTION)) {
				request.setAttribute("aiItemNo", request.getParameter("itemNo"));
				request.setAttribute("marineHulls", lovHelper.getList(LOVHelper.ALL_MARINE_HULL_LISTING));
				request.setAttribute("quoteItemMh", mhService.getGIPIQuoteItemMHDetails(quoteId, Integer.parseInt(request.getParameter("itemNo").equals("") ? "0" : request.getParameter("itemNo"))));
				PAGE = "/pages/marketing/quotation/subPages/quotationInformation/marineHullAdditionalInformation.jsp";
			} else if ("getMarineHulls".equals(ACTION)) {
				//request.setAttribute("marineHulls", StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.ALL_MARINE_HULL_LISTING)));
				request.setAttribute("marineHulls", lovHelper.getList(LOVHelper.ALL_MARINE_HULL_LISTING));
				PAGE = "/pages/marketing/quotation/dynamicDropdown/marineHulls.jsp";
			}
		} catch (SQLException e) {
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