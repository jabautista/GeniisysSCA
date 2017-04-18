/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuoteItemDiscount;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilDiscount;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;
import com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemDiscountFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemPerilDiscountFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService;
import com.geniisys.gipi.service.GIPIQuotePolItemPerilDiscountService;
import com.geniisys.gipi.service.GIPIQuotePolicyBasicDiscountFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIQuotationDiscountController.
 */
public class GIPIQuotationDiscountController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 2584797566659537728L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	
	@Override
	@SuppressWarnings( { "unused", "deprecation" })
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, 
			GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException { //, String env

		try {
			/* default attributes */
			log.info("Initializing: " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/* end of default attributes */

			StringBuilder output = new StringBuilder();
			
			/* Define services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIPIQuotePolicyBasicDiscountFacadeService discBasicService = (GIPIQuotePolicyBasicDiscountFacadeService) APPLICATION_CONTEXT.getBean("gipiQuotePolicyBasicDiscountFacadeService"); // +env
			GIPIQuoteItemDiscountFacadeService discItemService = (GIPIQuoteItemDiscountFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemDiscountFacadeService"); // +env
			GIPIQuoteItemPerilDiscountFacadeService discPerilService = (GIPIQuoteItemPerilDiscountFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemPerilDiscountFacadeService"); // +env
			GIPIQuoteItemFacadeService itemService = (GIPIQuoteItemFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemFacadeService"); // +env
			GIPIQuoteItemPerilFacadeService perilService = (GIPIQuoteItemPerilFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemPerilFacadeService"); // +env
			GIPIQuotePolItemPerilDiscountService polItemPerilService = (GIPIQuotePolItemPerilDiscountService) APPLICATION_CONTEXT.getBean("gipiQuotePolItemPerilDiscountService"); // +env
			
			GIPIQuote gipiQuote = null;
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null || request.getParameter("quoteId").equals("")) ? "0" : request.getParameter("quoteId"));
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", StringFormatter.escapeHTMLInObject2(gipiQuote));//reymon 04222013
				System.out.println(gipiQuote.getPremAmt());
			}

			if("showDiscountPage".equalsIgnoreCase(ACTION)){
				log.info("Redirecting to discount page...");
				List<GIPIQuotePolicyBasicDiscount> basicD = null;
				List<GIPIQuoteItem> items = null;
				List<GIPIQuoteItemPerilSummary> perils = null;
				List<GIPIQuoteItemDiscount> itemD = new ArrayList<GIPIQuoteItemDiscount>();
				List<GIPIQuoteItemPerilDiscount> perilD = new ArrayList<GIPIQuoteItemPerilDiscount>();
				log.info("loading basic discounts...");
				basicD = discBasicService.retrievePolicyDiscountList(quoteId);
				itemD = discItemService.retrieveItemDiscountList(quoteId);
				perilD = discPerilService.retrieveItemPerilDiscountList(quoteId);
				log.info("loading items...");
				items = itemService.getQuoteItemList(quoteId);
				request.setAttribute("quoteItems",items);
				log.info("Items List Size():"+items.size());
				log.info("loading perils...");
				perils = perilService.getQuoteItemPerilSummaryList(quoteId);
				request.setAttribute("quotePerils",perils);
				log.info("Item Perils List Size():"+perils.size());
				log.info("loading item discounts...");
				/*
				for(GIPIQuoteItem item: items){					
					//itemD.addAll(discItemService.retrieveItemDiscountList(quoteId, item.getItemNo()));
					perils = getPerils(perilService.getQuoteItemPerilSummaryList(quoteId),item.getItemNo());
					log.info("loading item peril discounts...");
					for (GIPIQuoteItemPerilSummary peril: perils){
						
						//perilD.addAll(discPerilService.retrieveItemPerilDiscountList(quoteId));
					}
				}
				*/	
				System.out.println("peril discount size"+perilD.size());
				int pageNo = 0;

				PaginatedList searchResult = getListingBasic(basicD);
				searchResult.gotoPage(pageNo);
				request.setAttribute("pageNoBasic", pageNo);
				request.setAttribute("listBasic", searchResult);
				request.setAttribute("pageIndexBasic", searchResult.getPageIndex() + 1);
				request.setAttribute("noOfPagesBasic", searchResult.getNoOfPages());
				searchResult = getListingItem(itemD);
				searchResult.gotoPage(pageNo);
				request.setAttribute("pageNoItem", pageNo);
				request.setAttribute("listItem", searchResult);
				request.setAttribute("pageIndexItem", searchResult.getPageIndex() + 1);
				request.setAttribute("noOfPagesItem", searchResult.getNoOfPages());
				searchResult = getListingPeril(perilD);
				searchResult.gotoPage(pageNo);
				request.setAttribute("pageNoPeril", pageNo);
				request.setAttribute("listPeril", searchResult);
				request.setAttribute("hiddenPerilList", perilD);
				request.setAttribute("pageIndexPeril", searchResult.getPageIndex() + 1);
				request.setAttribute("noOfPagesPeril", searchResult.getNoOfPages());

				PAGE = "/pages/marketing/quotation/quotationDiscount.jsp";
				
			} else if ("saveDiscounts".equalsIgnoreCase(ACTION)){
				log.info("Saving discount page...");
				
				GIPIQuote quote = serv.getQuotationDetailsByQuoteId(quoteId);
				
				//Old Basic list to delete
				String[] sequenceList = request.getParameter("sequenceList").split(",");
				Map<String, Object> oldBasicListToDelete = new HashMap<String, Object>();
				oldBasicListToDelete.put("oldBasicListToDelete", sequenceList);
				
				//Retrieve Policy Basic Discount List

				List<GIPIQuotePolicyBasicDiscount> oldBasic = discBasicService.retrievePolicyDiscountList(quoteId);
				
				//for(GIPIQuoteItem item: itemService.getQuoteItemList(quoteId)){
				List<GIPIQuoteItem> quoteItemList = itemService.getQuoteItemList(quoteId);
				
				//for(GIPIQuoteItemPerilSummary summary: perilService.getQuoteItemPerilSummaryList(quoteId)){
				List<GIPIQuoteItemPerilSummary> quoteItemPerilSummary = perilService.getQuoteItemPerilSummaryList(quoteId);
				
				//new basic
				List<GIPIQuotePolicyBasicDiscount> newBasic = parseBasic(request.getParameter("basicDiscounts"), quote);
				
				//new Items
				List<GIPIQuoteItemDiscount> newItems = parseItems(request.getParameter("itemDiscounts"), quote);
				
				//new Perils
				List<GIPIQuoteItemPerilDiscount> newPerils = parsePerils(request.getParameter("perilDiscounts"), quote);
				
				//new Basic/Item/Peril Premium Amounts
				BigDecimal gipiQuotePremAmt = new BigDecimal(request.getParameter("polQuotePremAmt"));
				List<String> newItemPremAmts = getListPipe(request.getParameter("quoteItemPremAmts"));
				List<String> newPerilPremAmts = getListPipe(request.getParameter("quotePerilPremAmts"));
				
				//Put all Maps in a single Map
				Map<String, Object> allParam = new HashMap<String, Object>();
				allParam.put("oldBasicListToDelete", oldBasicListToDelete);
				allParam.put("oldBasic", oldBasic);
				allParam.put("quoteItemList", quoteItemList);
				allParam.put("quoteItemPerilSummary", quoteItemPerilSummary);
				allParam.put("newBasic", newBasic);
				allParam.put("newItems", newItems);
				allParam.put("newPerils", newPerils);
				allParam.put("newItemPremAmts", newItemPremAmts);
				allParam.put("newPerilPremAmts", newPerilPremAmts);				
				
				polItemPerilService.saveGipiPolItemPerilDetails(quoteId, gipiQuotePremAmt, allParam);
				
				
				/*
				log.info("Saving discount page...");
				boolean result = false;
				log.info("Deleting old basic policy discounts...");
				GIPIQuote quote = serv.getQuotationDetailsByQuoteId(quoteId);
				String[] sequenceList = request.getParameter("sequenceList").split(",");
				List<GIPIQuotePolicyBasicDiscount> oldBasic = discBasicService.retrievePolicyDiscountList(quoteId);
				for(int i=0; i < sequenceList.length; i++){
					result = discBasicService.deletePolicyDiscount(oldBasic, Integer.parseInt(sequenceList[i]));
				}
				if (result) {
					log.info("Deleting old quote item discounts...");
					for(GIPIQuoteItem item: itemService.getQuoteItemList(quoteId)){
						List<GIPIQuoteItemDiscount> oldItem = discItemService.retrieveItemDiscountList(quoteId, item.getItemNo());
						if (result) {
							result = discItemService.deleteItemDiscount(oldItem);					
							for(GIPIQuoteItemPerilSummary summary: perilService.getQuoteItemPerilSummaryList(quoteId)){
								if(summary.getItemNo()==item.getItemNo()){
									log.info("Deleting old quote item peril discounts...");
									List<GIPIQuoteItemPerilDiscount> oldPerils = discPerilService.retrieveItemPerilDiscountList(quoteId, item.getItemNo(), summary.getPerilCd());
									if (result) {
										result =  discPerilService.deleteItemPerilDiscount(oldPerils);
									}									
								}						
							}
						}											
					}
				}						
				if (result) {
					if(null!=request.getParameter("basicDiscounts")){
						if(!"".equalsIgnoreCase(request.getParameter("basicDiscounts"))){
							List<GIPIQuotePolicyBasicDiscount> newBasic = parseBasic(request.getParameter("basicDiscounts"), quote);
							result = discBasicService.savePolicyDiscount(newBasic);
						}
					}
				}
				if (result) {
					if(null!=request.getParameter("itemDiscounts")){
						if(!"".equalsIgnoreCase(request.getParameter("itemDiscounts"))){
							List<GIPIQuoteItemDiscount> newItems = parseItems(request.getParameter("itemDiscounts"), quote);
							result = discItemService.saveItemDiscount(newItems);
						}
					}
				}
				if (result) {
					if(null!=request.getParameter("perilDiscounts")){
						if(!"".equalsIgnoreCase(request.getParameter("perilDiscounts"))){
							List<GIPIQuoteItemPerilDiscount> newPerils = parsePerils(request.getParameter("perilDiscounts"), quote);
							result = discPerilService.saveItemPerilDiscount(newPerils);
						}
					}
				}
				serv.updateQuotePremAmt(quoteId, new BigDecimal(request.getParameter("polQuotePremAmt")));
				List<String> strItemPrem = getListPipe(request.getParameter("quoteItemPremAmts"));
				List<String> strPerilPrem = getListPipe(request.getParameter("quotePerilPremAmts"));
				BigDecimal strItemPrems;
				for (int i=0; i<strItemPrem.size(); i=i+2){
					itemService.updateQuoteItemPremAmt(quoteId, Integer.parseInt(strItemPrem.get(i)), new BigDecimal(strItemPrem.get(i+1)));
				}
				for (int j=0; j<strPerilPrem.size(); j=j+3){
					perilService.updateItemPerilPremAmt(quoteId, Integer.parseInt(strPerilPrem.get(j)), Integer.parseInt(strPerilPrem.get(j+1)), new BigDecimal(strPerilPrem.get(j+2)));
				}*/
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			}
		} catch (NumberFormatException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
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

	/**
	 * Gets the listing basic.
	 * 
	 * @param list the list
	 * @return the listing basic
	 */
	private PaginatedList getListingBasic(List<GIPIQuotePolicyBasicDiscount> list) {
		PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE + 50);
		return result;
	}

	/**
	 * Gets the listing item.
	 * 
	 * @param list the list
	 * @return the listing item
	 */
	private PaginatedList getListingItem(List<GIPIQuoteItemDiscount> list) {
		PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE + 50);
		return result;
	}

	/**
	 * Gets the listing peril.
	 * @param list the list
	 * @return the listing peril
	 */
	private PaginatedList getListingPeril(List<GIPIQuoteItemPerilDiscount> list) {
		PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE + 50);
		return result;
	}

	/**
	 * Gets the perils.
	 * @param list the list
	 * @param itemNo the item no
	 * @return the perils
	 */
	@SuppressWarnings("unused")
	private List<GIPIQuoteItemPerilSummary> getPerils(List<GIPIQuoteItemPerilSummary> list, int itemNo){
		List<GIPIQuoteItemPerilSummary> finalList = new ArrayList<GIPIQuoteItemPerilSummary>();
		for (GIPIQuoteItemPerilSummary peril: list){
			if(peril.getItemNo()==itemNo){
				finalList.add(peril);
			}
		}
		return finalList;
	}
	
	/**
	 * Parses the basic.
	 * 
	 * @param arg the arg
	 * @param quote the quote
	 * @return the list
	 */
	private List<GIPIQuotePolicyBasicDiscount> parseBasic(String arg, GIPIQuote quote){
		SimpleDateFormat sdf = new SimpleDateFormat("dd/mm/yyyy");
		List<GIPIQuotePolicyBasicDiscount> list = new ArrayList<GIPIQuotePolicyBasicDiscount>();
		List<String> strs = getListPipe(arg);
		for(int x = 0; x < strs.size(); x++){
			GIPIQuotePolicyBasicDiscount disc = null;
			try {
				disc = new GIPIQuotePolicyBasicDiscount(
						Integer.valueOf(strs.get(x)).intValue(),
						Integer.valueOf(strs.get(x+1)).intValue(),
						//strs.get(x+2),strs.get(x+3),
						quote.getLineCd(), quote.getSublineCd(),
						"".equalsIgnoreCase(strs.get(x+4))?null:new BigDecimal(strs.get(x+4)),
								"".equalsIgnoreCase(strs.get(x+5))?null:new BigDecimal(strs.get(x+5)),
										"".equalsIgnoreCase(strs.get(x+6))?null:new BigDecimal(strs.get(x+6)),
												"".equalsIgnoreCase(strs.get(x+7))?null:new BigDecimal(strs.get(x+7)),
															"".equalsIgnoreCase(strs.get(x+8))?null:new BigDecimal(strs.get(x+8)),
																"".equalsIgnoreCase(strs.get(x+9))?null:new BigDecimal(strs.get(x+9)),
																		strs.get(x+10), "".equalsIgnoreCase(strs.get(x+11))?new Date():sdf.parse(strs.get(x+11)),strs.get(x+12)
				);
				list.add(disc);
				
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 12;
		}
		return list;
	}

	/**
	 * Parses the items.
	 * 
	 * @param arg the arg
	 * @param quote the quote
	 * @return the list
	 */
	private List<GIPIQuoteItemDiscount> parseItems(String arg, GIPIQuote quote){
		List<GIPIQuoteItemDiscount> list = new ArrayList<GIPIQuoteItemDiscount>();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/mm/yyyy");
		List<String> strs = getListPipe(arg);
		for(int x = 0; x < strs.size(); x++){
			GIPIQuoteItemDiscount disc = null;
			try {
				disc = new GIPIQuoteItemDiscount(
						Integer.valueOf(strs.get(x)).intValue(),
						Integer.valueOf(strs.get(x+1)).intValue(),
						//strs.get(x+2),strs.get(x+3),
						quote.getLineCd(), quote.getSublineCd(),
						Integer.valueOf(strs.get(x+4)).intValue(),						
						"".equalsIgnoreCase(strs.get(x+5))?null:new BigDecimal(strs.get(x+5)),
								"".equalsIgnoreCase(strs.get(x+6))?null:new BigDecimal(strs.get(x+6)),
										"".equalsIgnoreCase(strs.get(x+7))?null:new BigDecimal(strs.get(x+7)),
												"".equalsIgnoreCase(strs.get(x+8))?null:new BigDecimal(strs.get(x+8)),
														"".equalsIgnoreCase(strs.get(x+9))?null:new BigDecimal(strs.get(x+9)),
																"".equalsIgnoreCase(strs.get(x+10))?null:new BigDecimal(strs.get(x+10)),
																		strs.get(x+11), "".equalsIgnoreCase(strs.get(x+12))?new Date():sdf.parse(strs.get(x+12)),strs.get(x+13)
				);
				list.add(disc);
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 13;
		}
		return list;
	}

	
	/**
	 * Parses the perils.
	 * 
	 * @param arg the arg
	 * @param quote the quote
	 * @return the list
	 */
	private List<GIPIQuoteItemPerilDiscount> parsePerils(String arg, GIPIQuote quote){
		List<GIPIQuoteItemPerilDiscount> list = new ArrayList<GIPIQuoteItemPerilDiscount>();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/mm/yyyy");
		List<String> strs = getListPipe(arg);
		for(int x = 0; x < strs.size(); x++){
			GIPIQuoteItemPerilDiscount disc = null;
			try {
				disc = new GIPIQuoteItemPerilDiscount(
						Integer.valueOf(strs.get(x)).intValue(),
						Integer.valueOf(strs.get(x+1)).intValue(),
						//strs.get(x+2),strs.get(x+3),
						quote.getLineCd(), quote.getSublineCd(),
						Integer.valueOf(strs.get(x+4)).intValue(),
						strs.get(x+5),strs.get(x+6),strs.get(x+7),strs.get(x+8),
						"".equalsIgnoreCase(strs.get(x+9))?null:new BigDecimal(strs.get(x+9)),
								"".equalsIgnoreCase(strs.get(x+10))?null:new BigDecimal(strs.get(x+10)),
										"".equalsIgnoreCase(strs.get(x+11))?null:new BigDecimal(strs.get(x+11)),
												"".equalsIgnoreCase(strs.get(x+12))?null:new BigDecimal(strs.get(x+12)),
														"".equalsIgnoreCase(strs.get(x+13))?null:new BigDecimal(strs.get(x+13)),
																"".equalsIgnoreCase(strs.get(x+14))?null:new BigDecimal(strs.get(x+14)),
																		"".equalsIgnoreCase(strs.get(x+15))?null:new BigDecimal(strs.get(x+15)),
																				strs.get(x+16), "".equalsIgnoreCase(strs.get(x+17))?new Date():sdf.parse(strs.get(x+17)),strs.get(x+18)
				);
				list.add(disc);
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 18;
		}
		return list;
	}

	/**
	 * Gets the list pipe.
	 * 
	 * @param req the req
	 * @return the list pipe
	 */
	public static List<String> getListPipe(String req) {
		List<String> list = new ArrayList<String>();
		req = req.replaceAll(",", "");
		int start = 0;
		if (req.length() > 0)	{
			for (int x=0; x<req.length();x++){
				if ("|".equalsIgnoreCase(String.valueOf(req.charAt(x)))){
					list.add(req.substring(start, x));
					start = x+1;
				}			
			}
			if(!"".equalsIgnoreCase(req.substring(start, req.length()))){
				list.add(req.substring(start, req.length()));
			}			
		}		
		for (String str: list){
			log.info("List Elem:"+ str);
		}
		return list;
	}

}
