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
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteMortgagee;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuotationMortgageeController.
 */
public class GIPIQuotationMortgageeController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -3933092111998536283L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationMortgageeController.class);

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
			
			/* Services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIPIQuoteMortgageeFacadeService mortgPackageFacadeService = (GIPIQuoteMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteMortgageeFacadeService");
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			if("getItemQuoteMortgageeJSON".equals(ACTION)){
				log.info("1----Retrieving Mortgagee Package Information...JSON");
				String[] args = {gipiQuote.getIssCd()};
				System.out.println("isscd = <" + gipiQuote.getIssCd() + ">");
				
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // + env
				List<GIPIQuoteMortgagee> mortgagees = mortgPackageFacadeService.getGIPIQuoteMortgagee(gipiQuote.getQuoteId());
				System.out.println("Mortgageeees: " + mortgagees.size());
				List<LOV> mortgageeLOV = helper.getList(LOVHelper.MORTGAGEE_LISTING, args);

				System.out.println("mortgageeLOV: <<" + mortgageeLOV.size() + ">>");	
				request.setAttribute("mortgageeLovJSON", new JSONArray((List<GIPIQuoteMortgagee>)StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.MORTGAGEE_LISTING, args))));
				request.setAttribute("gipiQuoteMortgageeList", new JSONArray((List<GIPIQuoteMortgagee>)StringFormatter.replaceQuotesInList(mortgagees)));
				PAGE="/pages/marketing/quotation/subPages/mortgageeInformation.jsp";
			}else if("getQuoteMortgagees".equals(ACTION)){
				log.info("2----Retrieving Mortgagee Package Information...JSON");
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // + env
				String[] args = {gipiQuote.getIssCd()};
				List<LOV> mortgageeLov = helper.getList(LOVHelper.MORTGAGEE_LISTING, args);
				mortgageeLov = (List<LOV>)StringFormatter.replaceQuotesInList(mortgageeLov); //??
				request.setAttribute("mortgageeLovJSON", new JSONArray(mortgageeLov));
				
				List<GIPIQuoteMortgagee> mortgageeList = mortgPackageFacadeService.getGIPIQuoteMortgagee(gipiQuote.getQuoteId());
				mortgageeList = (List<GIPIQuoteMortgagee>) StringFormatter.replaceQuotesInList(mortgageeList);
				request.setAttribute("mortgageeListJSON", new JSONArray(mortgageeList));
				PAGE="/pages/marketing/quotation/subPages/mortgageeInformation.jsp";
			//quote level mortagee
			}else if("getQuoteMortgagee".equals(ACTION)){
				int id = Integer.parseInt(request.getParameter("quoteId"));
				String[] args = {serv.getQuotationDetailsByQuoteId(id).getIssCd()};
				System.out.println(serv.getQuotationDetailsByQuoteId(id).getIssCd());
				System.out.println("quoteid = "+id);
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // + env
				List<LOV> mortgageeList = helper.getList(LOVHelper.MORTGAGEE_LISTING, args);
				request.setAttribute("mortgageeListing", mortgageeList);
				
				List<GIPIQuoteMortgagee> mortgagees = mortgPackageFacadeService.getGIPIQuoteLevelMortgagee(gipiQuote.getQuoteId());
				request.setAttribute("mortgItemNo", Integer.parseInt((request.getParameter("itemNo") == null || request.getParameter("itemNo").equals("")) ? "0" : request.getParameter("itemNo")));
				request.setAttribute("mortgagees", mortgagees);
				request.setAttribute("quoteId", gipiQuote.getQuoteId());
				PAGE="/pages/marketing/quotation/subPages/mortgageeInformation2.jsp";
			}else if ("getPackQuotationMortagee".equals(ACTION)) {
				Integer packQuoteId = Integer.parseInt(request.getParameter("packQuoteId"));
				String[] args = {request.getParameter("issCd")};
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // + env
				List<LOV> mortgageeList = helper.getList(LOVHelper.MORTGAGEE_LISTING, args);
				
				List<GIPIQuoteMortgagee> quotationMortgagee = mortgPackageFacadeService.getPackQuotationsMortgagee(packQuoteId);
				StringFormatter.replaceQuotesInList(quotationMortgagee);
				//StringFormatter.replaceQuotesInList(mortgageeList);
				StringFormatter.escapeHTMLInList(mortgageeList);
				
				request.setAttribute("jsonGipiQuoteMortgagee", new JSONArray(quotationMortgagee));
				request.setAttribute("jsonMortageeListing", new JSONArray(mortgageeList));
				request.setAttribute("mortgageeListing", mortgageeList);
				PAGE = "/pages/marketing/quotation-pack/subPages/PackQuotationMortgageeInformation.jsp";
			}else if ("savePackQuotationMortgagee".equals(ACTION)) {
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packParId", request.getParameter("packQuoteId"));
				params.put("appUser", USER.getUserId());
				params.put("parameter", request.getParameter("parameter"));
				params.put("issCd", request.getParameter("issCd"));
				mortgPackageFacadeService.savePackQuotationMortgagee(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getQuoteMortgageeForPackQuotationInfo".equals(ACTION)){
				Integer packQuoteId = Integer.parseInt(request.getParameter("packQuoteId"));
				String[] args = {request.getParameter("issCd")};
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // + env
				
				List<LOV> mortgageeLOV = helper.getList(LOVHelper.MORTGAGEE_LISTING, args);
				List<GIPIQuoteMortgagee> packQuotationMortgagee = mortgPackageFacadeService.getPackQuotationsMortgagee(packQuoteId);
				
				StringFormatter.escapeHTMLInList(packQuotationMortgagee);
				
				request.setAttribute("mortgageeLOV", mortgageeLOV);
				request.setAttribute("objPackQuoteMortgageeList", new JSONArray(packQuotationMortgagee));
				PAGE = "/pages/marketing/quotation-pack/quotationInformation-pack/subPages/quotationMortgageeInformation.jsp";
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