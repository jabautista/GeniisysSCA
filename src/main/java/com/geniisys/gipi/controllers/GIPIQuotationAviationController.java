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
import com.geniisys.gipi.entity.GIPIQuoteItemAV;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemAVService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuotationAviationController.
 */
public class GIPIQuotationAviationController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -7018890709986476347L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationAviationController.class);

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
			GIPIQuoteItemAVService avService = (GIPIQuoteItemAVService) APPLICATION_CONTEXT.getBean("gipiQuoteItemAVService"); // +env
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			
			if ("showAviationAdditionalInformation".equals(ACTION)) {
				GIPIQuoteItemAV quoteItemAv = avService.getGIPIQuoteItemAVDetails(quoteId, Integer.parseInt(request.getParameter("itemNo")));
				
				if(quoteItemAv!=null){
					String purpose = quoteItemAv.getPurpose();
					System.out.println("purpose = " + purpose);
					String formatedPurpose = StringFormatter.replaceQuotes(purpose);
					System.out.println("formatted = " + formatedPurpose);
					quoteItemAv.setPurpose(StringFormatter.replaceQuotes(quoteItemAv.getPurpose()));//**
					quoteItemAv.setQualification(StringFormatter.replaceQuotes(quoteItemAv.getQualification()));
					quoteItemAv.setDeductText(StringFormatter.replaceQuotes(quoteItemAv.getDeductText()));
					quoteItemAv.setGeogLimit(StringFormatter.replaceQuotes(quoteItemAv.getGeogLimit()));				
					System.out.println("passed");
				}
				request.setAttribute("vessel", quoteItemAv);
				request.setAttribute("aiItemNo", request.getParameter("itemNo"));
				request.setAttribute("aircrafts", lovHelper.getList(LOVHelper.AIRCRAFT_LISTING));
				PAGE = "/pages/marketing/quotation/subPages/quotationInformation/aviationAdditionalInformation.jsp";
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