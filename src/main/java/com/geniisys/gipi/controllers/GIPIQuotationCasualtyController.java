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
import java.util.HashMap;
import java.util.Map;

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
import com.geniisys.gipi.entity.GIPIQuoteItemCA;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemCAService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuotationCasualtyController.
 */
public class GIPIQuotationCasualtyController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -5399936668694599911L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationCasualtyController.class);

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
			GIPIQuoteItemCAService caService = (GIPIQuoteItemCAService) APPLICATION_CONTEXT.getBean("gipiQuoteItemCAService"); // +env
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			
			if ("showCasualtyAdditionalInformation".equals(ACTION)) {
				/*
				request.setAttribute("aiItemNo", request.getParameter("itemNo"));
				request.setAttribute("positions", lovHelper.getList(LOVHelper.POSITION_LISTING));
				String[] hParams = {gipiQuote.getLineCd(), gipiQuote.getSublineCd()};
				
				request.setAttribute("hazards", lovHelper.getList(LOVHelper.SECTION_OR_HAZARD_LISTING, hParams));
				GIPIQuoteItemCA casualtyAi = (GIPIQuoteItemCA) StringFormatter.replaceQuotesInObject(caService.getGIPIQuoteItemCADetails(quoteId, Integer.parseInt(request.getParameter("itemNo").equals("") ? "0" : request.getParameter("itemNo"))));
				
				if(casualtyAi!=null)
					request.setAttribute("casualty", casualtyAi);
				PAGE = "/pages/marketing/quotation/pop-ups/casualtyAdditionalInformation.jsp";
				*/
				
				request.setAttribute("positionLov", lovHelper.getList(LOVHelper.POSITION_LISTING));
				//String[] hParams = {gipiQuote.getLineCd(), gipiQuote.getSublineCd()};
				request.setAttribute("hazardLov", lovHelper.getList(LOVHelper.SECTION_OR_HAZARD_LISTING));
				GIPIQuoteItemCA casualtyAi = (GIPIQuoteItemCA) StringFormatter.replaceQuotesInObject(caService.getGIPIQuoteItemCADetails(quoteId, Integer.parseInt(request.getParameter("itemNo").equals("") ? "0" : request.getParameter("itemNo"))));
				
				if(casualtyAi!=null)
					request.setAttribute("casualty", casualtyAi);
				PAGE = "/pages/marketing/quotation/subPages/quotationInformation/casualtyAdditionalInformation.jsp";
				
			}else if("getCasualtyAI".equals(ACTION)){
				Map<String, Object> attributeMap = new HashMap<String, Object>();
				
				
				request.setAttribute("object", attributeMap);
				PAGE = "/pages/marketing/quotation/subPages/quotationInformation/casualtyAdditionalInformation.jsp";
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