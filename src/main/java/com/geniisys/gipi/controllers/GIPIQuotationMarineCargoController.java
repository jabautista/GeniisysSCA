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
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemMNService;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIPIQuotationMarineCargoController.
 */
public class GIPIQuotationMarineCargoController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -1619422095584522160L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationMarineCargoController.class);
	
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
			GIPIQuoteItemMNService mnService = (GIPIQuoteItemMNService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMNService"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			System.out.println(ACTION+" action");
			if ("showMarineCargoAdditionalInformation".equals(ACTION)) {
				request.setAttribute("aiItemNo", request.getParameter("itemNo"));
				String[] quoteIdParam = {String.valueOf(gipiQuote.getQuoteId())};
				
				//List<LOV> geoList = lovHelper.getList(LOVHelper.GEOG_LISTING, quoteIdParam);
				
				request.setAttribute("geogs", lovHelper.getList(LOVHelper.GEOG_LISTING, quoteIdParam));
				request.setAttribute("quoteVessels", lovHelper.getList(LOVHelper.QUOTE_VESSEL_LISTING, quoteIdParam));
				request.setAttribute("cargoClasses", lovHelper.getList(LOVHelper.CARGO_CLASS_LISTING));
				String[] vCargoClass = {request.getParameter("cargoClassCd")};
				request.setAttribute("cargoTypes", lovHelper.getList(LOVHelper.CARGO_TYPE_LISTING, vCargoClass));
				String[] printTagParams = {"GIPI_WCARGO.PRINT_TAG"};
				request.setAttribute("printTags", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, printTagParams));
				
				request.setAttribute("quoteItemMn", mnService.getGIPIQuoteItemMNDetails(quoteId, Integer.parseInt(request.getParameter("itemNo").equals("") ? "0" : request.getParameter("itemNo"))));
				
				request.setAttribute("inceptDate", request.getParameter("inceptDate"));
				request.setAttribute("expiryDate", request.getParameter("expiryDate"));
				PAGE = "/pages/marketing/quotation/pop-ups/marineCargoAdditionalInformation.jsp";
				
			} else if ("showMarineCargoAdditionalInformationJSON".equals(ACTION)){
				
				PAGE = "/pages/marketing/quotation/subPages/quotationInformation/marineCargoAdditionalInformation.jsp";
			}else if("getQuoteMNGeographyDescListing".equals(ACTION)){
				String[] quoteIdParam = {String.valueOf(quoteId)};
				request.setAttribute("object", new JSONArray(lovHelper.getList(LOVHelper.GEOG_LISTING, quoteIdParam)));
				PAGE = "/pages/genericObject.jsp";
			}else if("getQuoteMNCarrierListing".equals(ACTION)){
				String[] quoteIdParam = {String.valueOf(quoteId)};
				request.setAttribute("object", new JSONArray(lovHelper.getList(LOVHelper.QUOTE_VESSEL_LISTING, quoteIdParam)));
				PAGE = "/pages/genericObject.jsp";
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
