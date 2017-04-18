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
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import atg.taglib.json.util.JSONArray;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemAC;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemACFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuotationAccidentController.
 */
public class GIPIQuotationAccidentController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 338547207751676465L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationAccidentController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
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
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			
			if ("showAccidentAdditionalInformation".equalsIgnoreCase(ACTION)) {
				GIPIQuoteItemACFacadeService gipiQuoteItemACService = (GIPIQuoteItemACFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemACFacadeService"); //  + env
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				int aiItemNo = Integer.parseInt(request.getParameter("itemNo"));
				GIPIQuoteItemAC gipiQuoteItemAC = gipiQuoteItemACService.getGIPIQuoteItemAc(quoteId, aiItemNo);
				
				System.out.println("processing item no: " + aiItemNo);
				
				if(gipiQuoteItemAC != null){
					log.info("Getting accident additional information for " + quoteId);
					gipiQuoteItemAC.setHeight(StringFormatter.replaceQuotes(gipiQuoteItemAC.getHeight()));
					gipiQuoteItemAC.setWeight(StringFormatter.replaceQuotes(gipiQuoteItemAC.getWeight()));
					gipiQuoteItemAC.setDestination(StringFormatter.replaceQuotes(gipiQuoteItemAC.getDestination()));
					gipiQuoteItemAC.setSalaryGrade(StringFormatter.replaceQuotes(gipiQuoteItemAC.getSalaryGrade()));
					request.setAttribute("gipiQuoteItemAC", gipiQuoteItemAC);
				}
				request.setAttribute("positionList", helper.getList(LOVHelper.POSITION_LISTING));
				String[] domainSex = {"SEX"};
				request.setAttribute("sexList", helper.getList(LOVHelper.CG_REF_CODE_LISTING, domainSex));
				String[] domainCS = {"CIVIL STATUS"};
				request.setAttribute("civilStatusList", helper.getList(LOVHelper.CG_REF_CODE_LISTING, domainCS));
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("quoteId", quoteId);
				request.setAttribute("aiItemNo", aiItemNo);
				
				PAGE = "/pages/marketing/quotation/pop-ups/accidentAdditionalInformation.jsp";
				
				if(gipiQuoteItemAC ==null){//**
					message = "notfound";
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showAccidentAdditionalInformationJSON".equals(ACTION)){
				GIPIQuoteItemACFacadeService gipiQuoteItemACService = (GIPIQuoteItemACFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemACFacadeService"); //  + env
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				int aiItemNo = Integer.parseInt(request.getParameter("itemNo"));
				GIPIQuoteItemAC gipiQuoteItemAC = gipiQuoteItemACService.getGIPIQuoteItemAc(quoteId, aiItemNo);
				
				if(gipiQuoteItemAC != null){
					log.info("Getting accident additional information for " + quoteId);
					gipiQuoteItemAC = (GIPIQuoteItemAC)StringFormatter.replaceQuotesInObject(gipiQuoteItemAC);
					request.setAttribute("gipiQuoteItemAC", gipiQuoteItemAC);
				}
				
				request.setAttribute("positionLovJSON", new JSONArray((List<LOV>) StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.POSITION_LISTING))));
				String[] domainSex = {"SEX"};
				request.setAttribute("sexLovJSON", new JSONArray((List<LOV>) StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.CG_REF_CODE_LISTING, domainSex))));
				
				String[] domainCS = {"CIVIL STATUS"};
				request.setAttribute("civilStatusLovJSON", new JSONArray((List<LOV>) StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.CG_REF_CODE_LISTING, domainCS))));
				
				PAGE = "/pages/marketing/quotation/subPages/quotationInformation/accidentAdditionalInformation.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}