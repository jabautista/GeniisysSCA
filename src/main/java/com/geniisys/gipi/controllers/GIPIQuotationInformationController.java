/**
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISPeril;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteDeductibles;
import com.geniisys.gipi.entity.GIPIQuoteInvoice;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;
import com.geniisys.gipi.service.GIPIQuotationFacadeService;
import com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemACFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemAVService;
import com.geniisys.gipi.service.GIPIQuoteItemCAService;
import com.geniisys.gipi.service.GIPIQuoteItemENService;
import com.geniisys.gipi.service.GIPIQuoteItemFIFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemMCService;
import com.geniisys.gipi.service.GIPIQuoteItemMHService;
import com.geniisys.gipi.service.GIPIQuoteItemMNService;
import com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService;
import com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService;
import com.geniisys.gipi.service.impl.GIPIQuoteInformationService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIQuotationInformationController.
 */
public class GIPIQuotationInformationController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 912471530540016811L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationInformationController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, 
			GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException { //, String env

		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/

			/* Definition of services needed */
			GIPIQuoteInformationService quoteInfoService = new GIPIQuoteInformationService(APPLICATION_CONTEXT); //(GIPIQuoteInformationService) APPLICATION_CONTEXT.getBean("gipiQuoteInformationService"); // +env
			GIPIQuoteItemFacadeService gipiQuoteItemFacadeService = (GIPIQuoteItemFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemFacadeService"); // +env
			GIPIQuoteItemPerilFacadeService gipiQuoteItemPerilFacadeService = (GIPIQuoteItemPerilFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemPerilFacadeService"); // +env
			
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIPIQuoteDeductiblesFacadeService quoteDed = (GIPIQuoteDeductiblesFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteDeductiblesFacadeService");
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			
			//Map<String, Object> attachedWC = new HashMap<String, Object>();
			if (quoteId != 0){
				System.out.println("quoteId: " + quoteId);
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);				
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote); // ORIGINAL
				//request.setAttribute("gipiQuoteObj", new JSONObject((GIPIQuote)StringFormatter.escapeHTMLInObject(gipiQuote))); //NEW //added by steven 11/6/2012 from: replaceQuotesInObject  to: escapeHTMLInObject
				request.setAttribute("gipiQuoteObj", new JSONObject((GIPIQuote)StringFormatter.escapeHTMLInObject2(gipiQuote))); // bonok :: 01.11.2013
			}

			if("showQuoteInformationPage".equals(ACTION)){ //editing
				String lineCd = request.getParameter("lineCd");
				log.info("Showing quotation information page for Quote ID: " + quoteId);
				
				//gipiQuote.setUserId(USER.getUserId());05.07.2012 robert
				// replacement for block one
				request.setAttribute("gipiQuoteObj", new JSONObject((GIPIQuote)StringFormatter.escapeHTMLInObject(gipiQuote))); //added by steven 11/6/2012 from: replaceQuotesInObject  to: escapeHTMLInObject
				
				// replacement for block two
				List<GIPIQuoteItem> quoteItems = gipiQuoteItemFacadeService.getQuoteItemList(quoteId, lineCd);
				
				try{
					request.setAttribute("gipiQuoteItemListJSON", new JSONArray((List<Object>)StringFormatter.escapeHTMLInList2(quoteItems))); //added by steven 11/6/2012 from: replaceQuotesInList  to: escapeHTMLInList2
					System.out.println(new JSONArray((List<Object>)StringFormatter.replaceQuotesInList(quoteItems)));
					System.out.println("");
				}catch(NullPointerException e){
					request.setAttribute("gipiQuoteItemListJSON", new ArrayList<Object>());
				}
				//For LOV listing per line
				loadListingToRequest(request, lovHelper);
				
				List<Integer> itemNos = new ArrayList<Integer>();
				for (GIPIQuoteItem quoteItem: (List<GIPIQuoteItem>) quoteItems){
					itemNos.add(quoteItem.getItemNo());
				}
				
//				GIACParameterFacadeService giacParameterFacadeService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
//				request.setAttribute("defaultCurrency", giacParameterFacadeService.getParamValueV("DEFAULT_CURRENCY").getParamValueV());
				
				List<GIPIQuoteItemPerilSummary> list = gipiQuoteItemPerilFacadeService.getQuoteItemPerilSummaryList(quoteId);
				System.out.println("QUOTEID = " + quoteId);
				List<GIPIQuoteItem> itemListWithPerils = quoteInfoService.buildItemPerilList(list, itemNos);
				request.setAttribute("itemListWithPerils", itemListWithPerils);
				
				request.setAttribute("itemNos", itemNos); // is this still necessary?
				List<GIPIQuoteDeductibles> deductList = quoteDed.getItemDeductibles(quoteId);
				request.setAttribute("itemDeductibles", deductList);
				
//				request.setAttribute("gipiQuoteItemListWithPerilJSON", new JSONArray(itemListWithPerils));
				
				request.setAttribute("gipiQuoteItemPerilList", new JSONArray((List<GIPIQuoteItemPerilSummary>)StringFormatter.replaceQuotesInList(list)));
				request.setAttribute("perilDeductiblesLovJSON", new JSONArray(deductList));
				
				String[] params = {gipiQuote.getLineCd(), gipiQuote.getSublineCd()};
				request.setAttribute("currencyLovJSON", new JSONArray(lovHelper.getList(LOVHelper.CURRENCY_CODES)));
				request.setAttribute("coverageLovJSON", new JSONArray(lovHelper.getList(LOVHelper.COVERAGE_CODES,params)));
				
				request.setAttribute("defaultCurrencyCd", (lovHelper.getList(LOVHelper.DEFAULT_CURRENCY)).get(0).getCode());
				request.setAttribute("fromCreateQuote", request.getParameter("fromCreateQuote") == null ? "N" : "Y");
				
				String[] params2 = {gipiQuote.getLineCd(), gipiQuote.getSublineCd(), Integer.toString(quoteId)};
				List<LOV> lovlist = lovHelper.getList(LOVHelper.QUOTE_PERIL_LISTING, params2);
				List<GIPIQuoteItemPerilSummary> perilList = this.passLOVToItemPerilSummary(lovlist);
				perilList = (List<GIPIQuoteItemPerilSummary>) StringFormatter.replaceQuotesInList(perilList);
				request.setAttribute("perilLovJSON", new JSONArray(perilList));
				request.setAttribute("lineCd", lineCd);
				// LOV's
				if (lineCd != null) {
					if ("AV".equals(lineCd)) {
						request.setAttribute("aircrafts", lovHelper.getList(LOVHelper.AIRCRAFT_LISTING));
					}
				}
				
				this.setListingAttributeToRequest(lineCd, request, gipiQuote, APPLICATION_CONTEXT);
				PAGE = "/pages/marketing/quotation/quotationInformationMain.jsp";
			}else if ("saveQuotationInformation".equals(ACTION)){
				log.info("entered saveQuotationInformation");
				Map<String, Object> params = new HashMap<String, Object>();
				GIPIQuoteInvoiceFacadeService invoiceFacadeService = (GIPIQuoteInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteInvoiceFacadeService");
				GIPIQuotationFacadeService gipiQuotationFacadeService = (GIPIQuotationFacadeService) APPLICATION_CONTEXT.getBean("gipiQuotationFacadeService");
				
				
				System.out.println("setPerilRows: " + request.getParameter("setPerilRows"));
				System.out.println("delPerilRows: " + request.getParameter("delPerilRows"));
				
				System.out.println("setInvoiceRows: " + request.getParameter("setInvoiceRows"));
				System.out.println("delInvoiceRows: " + request.getParameter("delInvoiceRows"));
				
				String[] itemNos  	= 	 request.getParameterValues("itemNos");
				String[] itemTitles = 	 request.getParameterValues("itemTitles");
				String[] itemDescs 	= 	 request.getParameterValues("itemDescs");
				String[] itemDescs2 = 	 request.getParameterValues("itemDescs2");
				String[] currencys 	= 	 request.getParameterValues("currencys");
				String[] currencyRates = request.getParameterValues("currencyRates");
				String[] coverages 	= 	 request.getParameterValues("coverages");
				String[] deleteTags = 	 request.getParameterValues("deleteTag");
				params.put("currencyLOV",	lovHelper.getList(LOVHelper.CURRENCY_CODES));
				params.put("itemNos",		itemNos);
				params.put("deleteTags",	deleteTags);
				params.put("itemTitles",	itemTitles);
				params.put("itemDescs",		itemDescs);
				params.put("itemDescs2",	itemDescs2);
				params.put("currencys",		currencys);
				params.put("currencyRates",	currencyRates);
				params.put("coverages",		coverages);
				params.put("USER",			USER);

				Map<String, Object> par = new HashMap<String, Object>();
				par.put("USER", USER);
				
				List<GIPIQuoteItemPerilSummary> setPerilRows = gipiQuoteItemPerilFacadeService.prepareItemPerilSummaryJSON(new JSONArray(request.getParameter("setPerilRows")==null? "[]" : request.getParameter("setPerilRows")), USER);
				List<GIPIQuoteItemPerilSummary> delPerilRows = gipiQuoteItemPerilFacadeService.prepareItemPerilSummaryJSON(new JSONArray(request.getParameter("delPerilRows")==null? "[]" : request.getParameter("delPerilRows")), USER);
				
				System.out.println("SET perilrows length: " + setPerilRows.size());
				System.out.println("DEL perilrows length: " + delPerilRows.size());
				
				List<GIPIQuoteInvoice> setInvoiceRows = invoiceFacadeService.prepareQuoteInvoiceJSON(new JSONArray(request.getParameter("setInvoiceRows")==null? "[]" : request.getParameter("setInvoiceRows")), USER);
				List<GIPIQuoteInvoice> delInvoiceRows = invoiceFacadeService.prepareQuoteInvoiceJSON(new JSONArray(request.getParameter("delInvoiceRows")==null? "[]" : request.getParameter("delInvoiceRows")), USER);

				params.put("setInvoiceRows", setInvoiceRows);
				params.put("delInvoiceRows", delInvoiceRows);
				
				params.put("setPerilRows", setPerilRows);
				params.put("delPerilRows", delPerilRows);
				
				Map<String, Object> rmDeductibles = new HashMap<String, Object>();
				Map<String, Object> itemPerils = new HashMap<String, Object>();
				
				if(itemNos != null){
					for (int i=0; i<itemNos.length; i++){
						Map<String, Object> perilMap = new HashMap<String, Object>();
						perilMap.put("perilCodes", request.getParameterValues("perilNames" + itemNos[i]));
						perilMap.put("perilRates", request.getParameterValues("perilRates" + itemNos[i]));
						perilMap.put("tsiAmounts", request.getParameterValues("tsiAmounts" + itemNos[i]));
						perilMap.put("premiumAmounts", request.getParameterValues("premiumAmounts" + itemNos[i]));
						perilMap.put("remarks", request.getParameterValues("remarks" + itemNos[i]));
						perilMap.put("perilTypes", request.getParameterValues("perilTypes" + itemNos[i])); 
						perilMap.put("basicPerils", request.getParameterValues("basicPerils" + itemNos[i]));
						perilMap.put("attachedWC", request.getParameterValues("attachWC"+ itemNos[i]));
						
						itemPerils.put(itemNos[i], perilMap);
						
						Map<String, Object> dedMap = new HashMap<String, Object>();
						dedMap.put("dPerilCds", request.getParameterValues("rmDedPerils" + itemNos[i]));
						dedMap.put("dItemNos", request.getParameterValues("rmDedItemNos" + itemNos[i]));
						rmDeductibles.put(itemNos[i], dedMap);
						/*	String[] x =  request.getParameterValues("rmDedItemNos"+itemNos[i]);
							if(x != null) {
								for(int j=0; j<x.length; j++) {
									System.out.println("Item nos (size: " + x.length + ") of deductible to be removed: " + x[i]);
								}
							}
						*/
					}
				}
				
				GIPIQuote updatedGIPIQuote = gipiQuotationFacadeService.prepareGIPIQuoteJSONObject(new JSONObject(request.getParameter("gipiQuote")), USER);
				params.put("updatedGIPIQuote", updatedGIPIQuote);
				
				params.put("itemPerils", itemPerils);
				params.put("quoteId", quoteId);
				params.put("lineCd", gipiQuote.getLineCd());
				params.put("issCd", gipiQuote.getIssCd());
				params.put("gipiQuote",	gipiQuote);
				params.put("rmDeductibles",	rmDeductibles);
				params.put("request", request);
				
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				String prorateFlag = request.getParameter("prorateFlag");
				Date inceptionDate = df.parse(request.getParameter("inceptionDate"));
				Date expirationDate	= df.parse(request.getParameter("expirationDate"));
				
				params.put("prorateFlag", prorateFlag);
				params.put("inceptionDate", inceptionDate);
				params.put("expirationDate", expirationDate);
				
				// send whole request parameter
				quoteInfoService.saveQuotationInformation(params);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveQuotationInformationJSON".equals(ACTION)){ // NEW
				Map<String,Object> params = new HashMap<String, Object>();
				String lineCd = request.getParameter("lineCd");
				params.put("lineCd", lineCd);
								
				GIPIQuoteMortgageeFacadeService gipiQuoteMortgageeFacadeService = (GIPIQuoteMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteMortgageeFacadeService");
				GIPIQuoteInvoiceFacadeService gipiQuoteInvoiceFacadeService = (GIPIQuoteInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteInvoiceFacadeService");
				GIPIQuoteDeductiblesFacadeService gipiQuoteDeductiblesFacadeService = (GIPIQuoteDeductiblesFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteDeductiblesFacadeService");
				
				JSONObject objParam = new JSONObject(request.getParameter("parameters"));
				
				params.put("gipiQuote", gipiQuote);
				params.put("setItemRows", gipiQuoteItemFacadeService.prepareGipiQuoteItemJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), USER));
				params.put("delItemRows", gipiQuoteItemFacadeService.prepareGipiQuoteItemJSON(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")), USER));
				params.put("setPerilRows", gipiQuoteItemPerilFacadeService.prepareItemPerilSummaryJSON(new JSONArray(objParam.isNull("setPerilRows") ? null : objParam.getString("setPerilRows")), USER));
				params.put("delPerilRows", gipiQuoteItemPerilFacadeService.prepareItemPerilSummaryJSON(new JSONArray(objParam.isNull("delPerilRows") ? null : objParam.getString("delPerilRows")), USER));
				params.put("setMortgageeRows", gipiQuoteMortgageeFacadeService.prepareMortgageeInformationJSON(new JSONArray(objParam.isNull("setMortgageeRows") ? null : objParam.getString("setMortgageeRows")), USER));
				params.put("delMortgageeRows", gipiQuoteMortgageeFacadeService.prepareMortgageeInformationJSON(new JSONArray(objParam.isNull("delMortgageeRows") ? null : objParam.getString("delMortgageeRows")), USER));
				params.put("setDeductibleRows", gipiQuoteDeductiblesFacadeService.prepareGIPIQuoteDeductiblesSummaryJSON(new JSONArray(objParam.isNull("setDeductibleRows") ? null : objParam.getString("setDeductibleRows")), USER));
				params.put("delDeductibleRows", gipiQuoteDeductiblesFacadeService.prepareGIPIQuoteDeductiblesSummaryJSON(new JSONArray(objParam.isNull("delDeductibleRows") ? null : objParam.getString("delDeductibleRows")), USER));
				params.put("setInvoiceRows", gipiQuoteInvoiceFacadeService.prepareQuoteInvoiceJSON(new JSONArray(objParam.isNull("setInvoiceRows") ? null : objParam.getString("setInvoiceRows")), USER));
				params.put("delInvoiceRows", gipiQuoteInvoiceFacadeService.prepareQuoteInvoiceJSON(new JSONArray(objParam.isNull("delInvoiceRows") ? null : objParam.getString("delInvoiceRows")), USER));				
				params.put("setAIRows", prepareAdditionalInformationJSON(lineCd, request, APPLICATION_CONTEXT));				
				params.put("delAIRows", prepareAdditionalInformationJSONForDelete(lineCd, request, APPLICATION_CONTEXT));
				
				quoteInfoService.saveQuotationInformationJSON(params);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getItemPerils".equals(ACTION)){ // IF CLAUSE TO BE DELETED
				System.out.println("GIPIQuoteInformationController - getItemPerils has been called");
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				List<GIPIQuoteItemPerilSummary> itemPerils = quoteInfoService.getItemPerils(quoteId, itemNo);
				request.setAttribute("itemNo", itemNo);
				request.setAttribute("itemPerils", itemPerils);
				PAGE = "/pages/marketing/quotation/subPages/quoteItemPerilListingTable.jsp";
			}
		}catch(SQLException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	private void loadListingToRequest(HttpServletRequest request, LOVHelper lovHelper) {
		String linecd = request.getParameter("lineCd");
		if ("AC".equals(linecd) || "PA".equals(linecd)){
			request.setAttribute("positionList", lovHelper.getList(LOVHelper.POSITION_LISTING));
			String[] domainSex = {"SEX"};
			request.setAttribute("sexList", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainSex));
			String[] domainCS = {"CIVIL STATUS"};
			request.setAttribute("civilStatusList", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainCS));
		}
	}

	/**
	 * @param itemPerilList
	 * @return
	 */
	@SuppressWarnings({ "unchecked" })
	private List<GIPIQuoteItemPerilSummary> passLOVToItemPerilSummary(List itemPerilList){
		List<GIPIQuoteItemPerilSummary> perilSummaryList = new ArrayList<GIPIQuoteItemPerilSummary>();
		Iterator<GIISPeril> lovIterator = itemPerilList.iterator();
		
		GIPIQuoteItemPerilSummary perilSummary = null;
		GIISPeril currentLOV = null;
		while(lovIterator.hasNext()){
			currentLOV = lovIterator.next();
			String pars[] = currentLOV.getPerilType().split("%");
			perilSummary = new GIPIQuoteItemPerilSummary();
			perilSummary.setPerilName(currentLOV.getPerilName());
			perilSummary.setBasicPerilCd(currentLOV.getBascPerlCd()); 
			perilSummary.setPerilCd(currentLOV.getPerilCd());
			perilSummary.setPerilType(pars[0]);			// peril type -- either a or b
			perilSummary.setWcSw(currentLOV.getWcSw());
			for(int i = 0; i< pars.length; i++){
				switch(i){
					case 0: perilSummary.setPerilType(pars[i]); break;
					case 1:{
						if(StringFormatter.isNumber(pars[i]))
							perilSummary.setPremiumRate(currentLOV.getDfltRate());
						else
							perilSummary.setPremiumRate(new BigDecimal(0));
					}break;
					case 2:{
						if(StringFormatter.isNumber(pars[i]))
							perilSummary.setTsiAmount(currentLOV.getDefaultTsi());
						else
							perilSummary.setPremiumRate(new BigDecimal(0));
					}break;
				}
			}
			perilSummaryList.add(perilSummary);
		}
		return perilSummaryList;
	}
	
	/**
	 * 
	 * @param lineCd
	 * @param request
	 * @return
	 * @throws ParseException 
	 */
	private List<?> prepareAdditionalInformationJSON(String lineCd, HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT)
				throws JSONException, ParseException {
		log.info("prepareAdditionalInformationJSON");
		List<?> aiList = null;
		JSONObject objParam = new JSONObject(request.getParameter("parameters"));
		
		if(lineCd.equals("MH")){
			GIPIQuoteItemMHService gipiQuoteItemMHService = (GIPIQuoteItemMHService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMHService");
			aiList = gipiQuoteItemMHService.prepareMarineHullInformationJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")));
		}else if("AC".equals(lineCd) || "PA".equals(lineCd)){
			GIPIQuoteItemACFacadeService gipiQuoteItemACFacadeService = (GIPIQuoteItemACFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemACFacadeService");
			aiList = gipiQuoteItemACFacadeService.prepareAccidentInformationJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")));
		}else if(lineCd.equals("AV")){
			GIPIQuoteItemAVService gipiQuoteItemAVService = (GIPIQuoteItemAVService) APPLICATION_CONTEXT.getBean("gipiQuoteItemAVService");
			aiList = gipiQuoteItemAVService.prepareAviationInformationJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")));
		}else if(lineCd.equals("CA")){
			GIPIQuoteItemCAService gipiQuoteItemCAService = (GIPIQuoteItemCAService) APPLICATION_CONTEXT.getBean("gipiQuoteItemCAService");
			aiList = gipiQuoteItemCAService.prepareCasualtyInformation(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")));
		}else if(lineCd.equals("EN")){
			GIPIQuoteItemENService gipiQuoteItemENService = (GIPIQuoteItemENService) APPLICATION_CONTEXT.getBean("gipiQuoteItemENService");
			aiList = gipiQuoteItemENService.prepareEngineeringInformationJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")));
		}else if(lineCd.equals("FI")){
			GIPIQuoteItemFIFacadeService gipiQuoteItemFIFacadeService = (GIPIQuoteItemFIFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemFIFacadeService");
			aiList = gipiQuoteItemFIFacadeService.prepareFireInformationJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")));
		}else if(lineCd.equals("MN")){
			GIPIQuoteItemMNService gipiQuoteItemMNService = (GIPIQuoteItemMNService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMNService");
			aiList = gipiQuoteItemMNService.prepareMarineCargoInformationJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")));
		}else if(lineCd.equals("MC")){
			GIPIQuoteItemMCService gipiQuoteItemMCService = (GIPIQuoteItemMCService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMCService");
			aiList = gipiQuoteItemMCService.prepareMotorCarInformation(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")));
		}
		return aiList;
	}
	
	/**
	 * 
	 * @param lineCd
	 * @param request
	 * @return
	 * @throws ParseException 
	 */
	private List<?> prepareAdditionalInformationJSONForDelete(String lineCd, HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT)
				throws JSONException, ParseException {
		List<?> aiList = null;
		JSONObject objParam = new JSONObject(request.getParameter("parameters"));
		
		if("AC".equals(lineCd) || "PA".equals(lineCd)){
			GIPIQuoteItemACFacadeService gipiQuoteItemACFacadeService = (GIPIQuoteItemACFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemACFacadeService");
			aiList = gipiQuoteItemACFacadeService.prepareAccidentInformationJSON(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")));
		}else if(lineCd.equals("AV")){
			GIPIQuoteItemAVService gipiQuoteItemAVService = (GIPIQuoteItemAVService) APPLICATION_CONTEXT.getBean("gipiQuoteItemAVService");
			aiList = gipiQuoteItemAVService.prepareAviationInformationJSON(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")));
		}else if(lineCd.equals("CA")){
			GIPIQuoteItemCAService gipiQuoteItemCAService = (GIPIQuoteItemCAService) APPLICATION_CONTEXT.getBean("gipiQuoteItemCAService");
			aiList = gipiQuoteItemCAService.prepareCasualtyInformation(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")));
		}else if(lineCd.equals("EN")){
			GIPIQuoteItemENService gipiQuoteItemENService = (GIPIQuoteItemENService) APPLICATION_CONTEXT.getBean("gipiQuoteItemENService");
			aiList = gipiQuoteItemENService.prepareEngineeringInformationJSON(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")));
		}else if(lineCd.equals("FI")){
			GIPIQuoteItemFIFacadeService gipiQuoteItemFIFacadeService = (GIPIQuoteItemFIFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemFIFacadeService");
			aiList = gipiQuoteItemFIFacadeService.prepareFireInformationJSON(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")));
		}else if(lineCd.equals("MN")){
			GIPIQuoteItemMNService gipiQuoteItemMNService = (GIPIQuoteItemMNService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMNService");
			aiList = gipiQuoteItemMNService.prepareMarineCargoInformationJSON(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")));
		}else if(lineCd.equals("MH")){
			GIPIQuoteItemMHService gipiQuoteItemMHService = (GIPIQuoteItemMHService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMHService");
			aiList = gipiQuoteItemMHService.prepareMarineHullInformationJSON(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")));
		}else if(lineCd.equals("MC")){
			GIPIQuoteItemMCService gipiQuoteItemMCService = (GIPIQuoteItemMCService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMCService");
			aiList = gipiQuoteItemMCService.prepareMotorCarInformation(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")));
		}
		return aiList;
	}
	
	public void setListingAttributeToRequest(String lineCd, HttpServletRequest request, GIPIQuote gipiQuote, ApplicationContext APPLICATION_CONTEXT){
		if(lineCd.equals("FI")){
			GIPIQuoteItemFIFacadeService gipiQuoteItemFIFacadeService = (GIPIQuoteItemFIFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemFIFacadeService");
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
			gipiQuoteItemFIFacadeService.loadListingToRequest(request, lovHelper, gipiQuote);
		}else if(lineCd.equals("CA")){
			GIPIQuoteItemCAService gipiQuoteCAService = (GIPIQuoteItemCAService) APPLICATION_CONTEXT.getBean("gipiQuoteItemCAService");
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
			gipiQuoteCAService.loadListingToRequest(request, lovHelper, gipiQuote);
		}else if(lineCd.equals("MC")){
			GIPIQuoteItemMCService gipiQuoteMCService = (GIPIQuoteItemMCService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMCService");
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
			gipiQuoteMCService.loadListingToRequest(request, lovHelper, gipiQuote);
		}else if(lineCd.equals("MN")){
			GIPIQuoteItemMNService gipiQuoteMNService = (GIPIQuoteItemMNService) APPLICATION_CONTEXT.getBean("gipiQuoteItemMNService");
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
			gipiQuoteMNService.loadListingToRequest(request, lovHelper, gipiQuote);
		}else if(lineCd.equals("MH")){
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
			request.setAttribute("aiItemNo", request.getParameter("itemNo"));
			request.setAttribute("marineHulls", lovHelper.getList(LOVHelper.ALL_MARINE_HULL_LISTING));
		}
	}
}