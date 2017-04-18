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
import com.geniisys.gipi.entity.GIPIQuoteDeductibles;
import com.geniisys.gipi.entity.GIPIQuoteItemMC;
import com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemMCService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuotationMotorCarController.
 */
public class GIPIQuotationMotorCarController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -7018431725194847304L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationInformationController.class);
	
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
			
			/* Definition services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIPIQuoteItemMCService gipiQuoteItemMCService = (GIPIQuoteItemMCService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMCService"); // +env
			GIPIQuoteDeductiblesFacadeService deductibleService = (GIPIQuoteDeductiblesFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteDeductiblesFacadeService"); // + env
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
				
			if ("showMotorcarAdditionalInformationPage".equals(ACTION)) {
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				System.out.println("First line ,item no = "+itemNo);
				GIPIQuoteItemMC quoteItemMC = null;
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("sublineCd", gipiQuote.getSublineCd());
				quoteItemMC = gipiQuoteItemMCService.getGIPIQuoteItemMC(quoteId, itemNo);

				System.out.println(gipiQuote.getQuotationYy());
				if (quoteItemMC != null)	{
					params.put("basicColor", quoteItemMC.getBasicColor());
					params.put("carCompany", quoteItemMC.getCarCompanyCd());
					params.put("make", quoteItemMC.getMake());
				}
				
				//for default tow value
				String subline = "%"+gipiQuote.getSublineCd()+"%"; // added % for like condition sql
				System.out.println("subline cd: " + gipiQuote.getSublineCd());
				int tow = gipiQuoteItemMCService.getDefaultTow(subline);
				request.setAttribute("defaultTow", tow);
				// end 
				//for default coc YY
				String defaultCocYY = Integer.toString(gipiQuote.getQuotationYy());
			
				request.setAttribute("defaultCocYY", defaultCocYY.substring(2));
				GIPIQuoteDeductibles gipiQuoteDeduct = deductibleService.getDeductibleSum(quoteId);
				request.setAttribute("gipiQuoteDeduct", gipiQuoteDeduct);
				request.setAttribute("basicColors", lovHelper.getList(LOVHelper.MC_BASIC_COLOR_LISTING));
				
				//String[] basicColorParams = {params.get("basicColor") == null ? "" : params.get("basicColor").toString()};
				request.setAttribute("colors", lovHelper.getList(LOVHelper.MC_ALL_COLOR));
				
				String[] motorTypeParams = {params.get("sublineCd") == null ? "" : params.get("sublineCd").toString()};
				request.setAttribute("motorTypes", lovHelper.getList(LOVHelper.MOTOR_TYPE_LISTING, motorTypeParams));
				request.setAttribute("aiItemNo", itemNo);
				request.setAttribute("sublineTypes", lovHelper.getList(LOVHelper.SUBLINE_TYPE_LISTING, motorTypeParams));
				request.setAttribute("typeOfBodies", lovHelper.getList(LOVHelper.TYPE_OF_BODY_LISTING));
				request.setAttribute("carCompanies", lovHelper.getList(LOVHelper.CAR_COMPANY_LISTING));
				// for new make, engine series lov
				//String itemNo = request.getParameter("aiItemNo");
				String[] sublineCd = {gipiQuote.getSublineCd()};
				request.setAttribute("aiItemNo", itemNo);
				request.setAttribute("makes", lovHelper.getList(LOVHelper.MAkE_LISTING_BY_SUBLINE, sublineCd));
				request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ALL_ENGINE_SERIES));
				//end new LOV list
				
				// Makes listing into JSON object
				List<LOV> makes = lovHelper.getList(LOVHelper.MAkE_LISTING_BY_SUBLINE, sublineCd);
				StringFormatter.replaceQuotesInList(makes);
				request.setAttribute("objMakeListing", new JSONArray(makes));
				
				//Engine listing into JSON object
				List<LOV> engineSeries = lovHelper.getList(LOVHelper.ALL_ENGINE_SERIES);
				StringFormatter.replaceQuotesInList(engineSeries);
				request.setAttribute("objEngineSeriesListing", new JSONArray(engineSeries));
				
				// added by nica 10.07.2010 for sorting of LOV
				//Colors Listing into JSON object
				List<LOV> colors = lovHelper.getList(LOVHelper.MC_ALL_COLOR);
				StringFormatter.replaceQuotesInList(colors);
				request.setAttribute("objColors", new JSONArray(colors));
				
				//for all serial no, motor no, plate no, coc serial no
				request.setAttribute("allSerialNo", gipiQuoteItemMCService.getAllSerialMc());
				request.setAttribute("allMotorNo", gipiQuoteItemMCService.getAllMotorMc());
				request.setAttribute("allPlateNo", gipiQuoteItemMCService.getAllPlateMc());
				request.setAttribute("allCocNo", gipiQuoteItemMCService.getAllCocMc());
				
				/*String[] carCompany = {params.get("carCompany") == null ? "" : params.get("carCompany").toString()};
				if (!"".equals(carCompany[0])) {
					request.setAttribute("makes", lovHelper.getList(LOVHelper.MAKE_LISTING, carCompany));
					List<LOV> makes = lovHelper.getList(LOVHelper.MAKE_LISTING, carCompany);
					StringFormatter.replaceQuotesInList(makes);
					request.setAttribute("objMakeListing", new JSONArray(makes));
				}
				
				{	String carcompanycd = null;
					if(quoteItemMC!=null){
						carcompanycd = carcompanycd == null ? "" :quoteItemMC.getCarCompanyCd().toString();
					}else{
						carcompanycd = "";
					}
					String[] paramsES = {params.get("makeCd") == null ? "" : params.get("makeCd").toString(), carcompanycd};
					if (!"".equals(paramsES[0])) {
						request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ENGINE_SERIES_LISTING, paramsES));
						List<LOV> engineSeries = lovHelper.getList(LOVHelper.ENGINE_SERIES_LISTING, paramsES);
						StringFormatter.replaceQuotesInList(engineSeries);
						request.setAttribute("objEngineSeriesListing", new JSONArray(engineSeries));
					}
				}*/
				
//				request.setAttribute("maiItemNo", itemNo);
				request.setAttribute("quoteItemMC", quoteItemMC);
				PAGE = "/pages/marketing/quotation/pop-ups/motorcarAdditionalInformation.jsp";
			}else if ("filterEngineSeries".equals(ACTION))	{
				String[] make = {request.getParameter("makeCd"), request.getParameter("carCompanyCd")};

				String itemNo = request.getParameter("aiItemNo");
				request.setAttribute("aiItemNo", itemNo);
				request.setAttribute("engineSeries", lovHelper.getList(LOVHelper.ENGINE_SERIES_LISTING, make));
				PAGE = "/pages/marketing/quotation/dynamicDropdown/engineSeries.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
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
