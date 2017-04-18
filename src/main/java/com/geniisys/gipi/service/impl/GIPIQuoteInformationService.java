/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteDeductibles;
import com.geniisys.gipi.entity.GIPIQuoteDeductiblesSummary;
import com.geniisys.gipi.entity.GIPIQuoteInvTax;
import com.geniisys.gipi.entity.GIPIQuoteInvoiceSummary;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuoteItemPeril;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;
import com.geniisys.gipi.entity.GIPIQuoteMortgagee;
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
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIQuoteInformationService.
 */
public class GIPIQuoteInformationService {
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteInformationService.class);
	
	/** The application context. */
	private ApplicationContext applicationContext;
	
	/**
	 * Instantiates a new gIPI quote information service.
	 * 
	 * @param appContext the app context
	 */
	public GIPIQuoteInformationService(ApplicationContext appContext) {
		this.applicationContext = appContext;
	}
	
	/**
	 * Gets the quote items.
	 * 
	 * @param quoteId the quote id
	 * @return the quote items
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteItem> getQuoteItems(int quoteId)	throws SQLException{
		GIPIQuoteItemFacadeService gipiQuoteItemFacadeService = (GIPIQuoteItemFacadeService) applicationContext.getBean("gipiQuoteItemFacadeService"); // +env
		return gipiQuoteItemFacadeService.getQuoteItemList(quoteId);
	}
	
	/**
	 * Gets the quote item perils.
	 * 
	 * @param quoteId the quote id
	 * @param itemNos the item nos
	 * @return the quote item perils
	 * @throws SQLException the sQL exception
	 */
	public List<Object> getQuoteItemPerils(int quoteId, List<Integer> itemNos) throws SQLException	{
		GIPIQuoteItemPerilFacadeService gipiQuoteItemPerilFacadeService = (GIPIQuoteItemPerilFacadeService) applicationContext.getBean("gipiQuoteItemPerilFacadeService"); // +env
		List<Object> perils = new ArrayList<Object>();
		List<GIPIQuoteItemPerilSummary> list = gipiQuoteItemPerilFacadeService.getQuoteItemPerilSummaryList(quoteId);
		perils = this.buildItemPerils(list, itemNos);
		return perils;
	}
	
	/* Whofeih beyond */
	
	// Building List of List of Item Perils
	/**
	 * Builds the item perils.
	 * 
	 * @param list the list
	 * @param itemNos the item nos
	 * @return the list
	 */
	public List<Object> buildItemPerils(List<GIPIQuoteItemPerilSummary> list, List<Integer> itemNos){
		log.info("Building list of Perils...");
		
		List<Object> perils = new ArrayList<Object>();
		for (Integer itemNo: itemNos)	{
			List<GIPIQuoteItemPerilSummary> finalPerils = new ArrayList<GIPIQuoteItemPerilSummary>();
			
			for (GIPIQuoteItemPerilSummary item: list)	{
				if (itemNo == item.getItemNo())	{	
					finalPerils.add(item);
				}
			}
			
			perils.add(finalPerils);
		}
		return perils;
	}
	
	/**
	 * Creates a list of dummy quoteItems that only contains itemNo and perilList ---used for displaying values in quoteItemPerilListingTable.jsp
	 * @param list
	 * @param itemNos
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteItem> buildItemPerilList(List<GIPIQuoteItemPerilSummary> list, List<Integer> itemNos){
		log.info("Building list of Perils...");
		List<GIPIQuoteItem> itemListWithPeril = new ArrayList<GIPIQuoteItem>();
		
		GIPIQuoteItem anItem = null;
		List<GIPIQuoteItemPerilSummary> perilList = null;
		for (Integer itemNo: itemNos){
			anItem = new GIPIQuoteItem();
			anItem.setItemNo(itemNo);
			
			perilList = new ArrayList<GIPIQuoteItemPerilSummary>();
			for (GIPIQuoteItemPerilSummary item: list){
				if (itemNo.intValue() == item.getItemNo().intValue()){	
					perilList.add(item);
				}
			}
			perilList = (List<GIPIQuoteItemPerilSummary>) StringFormatter.replaceQuotesInList(perilList);
			anItem.setPerilList(perilList);
			itemListWithPeril.add(anItem);
		}
		
		itemListWithPeril = (List<GIPIQuoteItem>) StringFormatter.replaceQuotesInList(itemListWithPeril);
		return itemListWithPeril;
	}
	
	/**
	 * @author rencela
	 * @param list
	 * @param itemNos
	 * @return
	 */
	public Map<String, List<GIPIQuoteItemPerilSummary>> buildItemPerilsMap(List<GIPIQuoteItemPerilSummary> list, List<Integer> itemNos){
		Map<String, List<GIPIQuoteItemPerilSummary>> leMap = new HashMap<String, List<GIPIQuoteItemPerilSummary>>();
		List<GIPIQuoteItemPerilSummary> perilList = null;
		
		for (Integer itemNo: itemNos)	{
			perilList = new ArrayList<GIPIQuoteItemPerilSummary>();
			for (GIPIQuoteItemPerilSummary item: list)	{
				if (itemNo == item.getItemNo())	{	
					perilList.add(item);
				}
			}	
			leMap.put("peril" + itemNo, perilList);
		}
		return leMap;
	}
	
	/**
	 * Save quotation information.
	 * 
	 * @param params 
	 * last modified: 02/01/2010 by: royencela
	 * @throws NullPointerException the null pointer exception
	 * @throws SQLException the sQL exception
	 */
	public void saveQuotationInformation(Map<String, Object> params) throws NullPointerException, SQLException, Exception{
		Map<String, Object> preparedParams = new HashMap<String, Object>();
		GIPIQuoteItemFacadeService	gipiQuoteItemFacadeService 		= (GIPIQuoteItemFacadeService) applicationContext.getBean("gipiQuoteItemFacadeService"); // +env

		HttpServletRequest request 	= (HttpServletRequest) params.get("request");
		GIPIQuote 	gipiQuote 		= (GIPIQuote) params.get("gipiQuote");
		int 		quoteId 		= (Integer) params.get("quoteId");
		String 		lineCd 			= (String)  params.get("lineCd");
		
		preparedParams.put("gipiQuote",	gipiQuote);
		preparedParams.put("quoteId",	quoteId);
		preparedParams.put("lineCd",	lineCd);
		preparedParams.put("itemNos",	(String[])	params.get("itemNos"));
		preparedParams.put("deleteTags",(String[])	params.get("deleteTags"));
		preparedParams.put("currencyCodes",(String[]) params.get("currencys"));
		preparedParams.put("currencyRates",(String[]) params.get("currencyRates"));
		preparedParams.put("currencyLOV", params.get("currencyLOV"));
		preparedParams.putAll(prepareAdditionalInformation(request, params));
		preparedParams.putAll(prepareQuoteItems(	request, params));
		preparedParams.putAll(prepareItemPerils(	request, params)); // TO BE REMOVED
		preparedParams.putAll(prepareMortgagee(		request, params));
		preparedParams.putAll(prepareDeductibles(	request, params));
		//preparedParams.putAll(prepareInvoice(		request, params));
		preparedParams.put("updatedGIPIQuote", params.get("updatedGIPIQuote"));
		preparedParams.put("setPerilRows",   params.get("setPerilRows"));
		preparedParams.put("delPerilRows",	 params.get("delPerilRows"));
		
		preparedParams.put("setInvoiceRows", params.get("setInvoiceRows"));
		preparedParams.put("delInvoiceRows", params.get("delInvoiceRows"));
		
		preparedParams.putAll(prepareRemovedDeductibles(request, params));
		//preparedParams.put("attachedWC", params.get("attachedWC"));
		gipiQuoteItemFacadeService.saveGIPIQuoteItem(preparedParams);
	}
	
	/**
	 * - replacement for the code above.
	 * Saves the whole quotationInformation page.
	 * @param listParams
	 * @throws Exception
	 */
	public void saveQuotationInformationJSON(Map<String, Object> quoteInfoMap) throws Exception{
		GIPIQuoteItemFacadeService	gipiQuoteItemFacadeService = (GIPIQuoteItemFacadeService) applicationContext.getBean("gipiQuoteItemFacadeService"); // +env
		gipiQuoteItemFacadeService.saveQuotationInformation(quoteInfoMap);
	}
	
	/**
	 * Prepare Quotation Item for GIPIQuoteItemDAOImpl
	 * @param request
	 * @param params
	 * @return Map
	 */
	public Map<String, Object> prepareQuoteItems(HttpServletRequest request, Map<String, Object> params){
		log.info("Preparing quote item parameters...");
		Map<String, Object> quoteItemParams = new HashMap<String, Object>();
		List<GIPIQuoteItem> quoteItemList = new ArrayList<GIPIQuoteItem>();
		
		String[] itemNos 		= (String[]) params.get("itemNos");
		String[] itemTitles 	= (String[]) params.get("itemTitles");
		String[] itemDescs 		= (String[]) params.get("itemDescs");
		String[] itemDescs2 	= (String[]) params.get("itemDescs2");
		String[] currencys 		= (String[]) params.get("currencys");
		String[] currencyRates 	= (String[]) params.get("currencyRates");
		String[] coverages 		= (String[]) params.get("coverages");
		
		if(itemDescs!=null){
			GIPIQuoteItem quoteItem = null;			
			BigDecimal currencyRate = null;
			String itemDescription2 = null;
			String itemDescription 	= null;
			String itemTitle 		= null;
			int quoteId 			= (Integer) params.get("quoteId");
			int itemNo 				= 0;
			int coverageCode 		= 0;
			int currencyCode 		= 0;
			
			for(int i = 0; i < itemNos.length; i++){
				itemNo = Integer.parseInt(itemNos[i]);
				itemTitle = itemTitles[i];
				itemDescription = itemDescs[i];
				itemDescription2 = itemDescs2[i];
				currencyCode = Integer.parseInt(currencys[i]);
				currencyRate = new BigDecimal(currencyRates[i]);
				coverageCode = Integer.parseInt(isNumeric(coverages[i]) ? coverages[i] : "0");
				quoteItem = new GIPIQuoteItem(quoteId, itemNo, itemTitle, itemDescription, itemDescription2, currencyCode, currencyRate, coverageCode);
				quoteItemList.add(quoteItem);
			}
		}
		quoteItemParams.put("quoteItemList", quoteItemList);
		return quoteItemParams;
	}
	
	/**
	 * Prepare Item Perils for GIPIQuoteItemDAOImpl
	 * @param request
	 * @param params
	 * @return Map
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> prepareItemPerils(HttpServletRequest request, Map<String, Object> params)throws SQLException{
		log.info("Preparing peril parameters...");
		
		List<GIPIQuoteItemPeril> itemPerilList = null;
		Map<String, Object> itemPerilParams = new HashMap<String, Object>();
		Map<String, Object> itemPerils = (Map<String, Object>) params.get("itemPerils");
		
		String[] itemNos		= (String[])params.get("itemNos");
		String 	prorateFlag		= (String)	params.get("prorateFlag");
		Date 	inceptionDate	= (Date)	params.get("inceptionDate");
		Date 	expiryDate		= (Date)	params.get("expirationDate");
		
		GIPIQuoteItemPerilFacadeService gipiQuoteItemPerilFacadeService = (GIPIQuoteItemPerilFacadeService) applicationContext.getBean("gipiQuoteItemPerilFacadeService");
		if (itemNos != null){
			int quoteId = (Integer) params.get("quoteId");
			
			Map<String, Object> perilMap;
			GIPIQuoteItemPeril quoteItemPeril = null;
			String[] perilCodes;
			String[] perilRates;
			String[] premAmounts;
			String[] tsiAmounts;
			String[] remarks;
			String[] basicPerils;
			String[] perilTypes;
			String[] attachedWCs;
			String lineCd = null;
			BigDecimal perilRate = null;
			BigDecimal premiumAmount = null;
			BigDecimal tsiAmount = null;
			int perilCode;
			int itemNo;
			String tarfCd;
			
			Double kadobol = null;
			
			for(int i = 0; i < itemNos.length; i++){
				itemPerilList 	= new ArrayList<GIPIQuoteItemPeril>();
				itemNo 			= Integer.parseInt(itemNos[i]);
				perilMap = (Map<String, Object>) itemPerils.get(itemNos[i]);
				perilCodes = (String[]) perilMap.get("perilCodes");
				perilRates = (String[]) perilMap.get("perilRates");
				premAmounts = (String[]) perilMap.get("premiumAmounts");
				
				tsiAmounts = (String[]) perilMap.get("tsiAmounts");
				remarks    = (String[]) perilMap.get("remarks");
				basicPerils = (String[]) perilMap.get("basicPerils");
				perilTypes  = (String[]) perilMap.get("perilTypes");
				attachedWCs = (String[]) perilMap.get("attachedWC");
				// loop through quotation item perils
				if (perilCodes != null)	{
					for (int x=0; x < perilCodes.length; x++)	{
						System.out.println("-- perilRate: " + perilRates[x].replace(",", ""));
						System.out.println("-- tsiAmount: " + tsiAmounts[x].replace(",", ""));
						System.out.println("-- tsiAmount: " + premAmounts[x].replace(",", ""));
						
						if(StringFormatter.isNumber(perilRates[x])){
							kadobol = Double.parseDouble(perilRates[x]);
							if(kadobol.equals(new Double(0)) || perilRates[x].equals("0.000000000")){
								System.out.println("ss if(kadobol.equals(new Double(0))->" + perilRates[x]);
								perilRate = new BigDecimal(0);
							}else{
								perilRate = new BigDecimal(perilRates[x].replace(",", ""));
								System.out.println("nonzeross->" + perilRates[x]);
							}
						}
						kadobol = null;
						if(StringFormatter.isNumber(tsiAmounts[x])){
							kadobol = Double.parseDouble(tsiAmounts[x].replace(",", ""));
							if(kadobol.equals(new Double(0)) || tsiAmounts[x].equals("0.000000000")){
								System.out.println("aa if(kadobol.equals(new Double(0))-" + tsiAmounts[x]);
								tsiAmount = new BigDecimal(0);
							}else{
								tsiAmount = new BigDecimal(tsiAmounts[x].replace(",", ""));
								System.out.println("nonzeroaa->" + tsiAmounts[x]);
							}
						}

						
						perilCode = Integer.parseInt(perilCodes[x]);
						tarfCd = attachedWCs[x];
						premiumAmount = gipiQuoteItemPerilFacadeService.computePremiumAmount(prorateFlag, inceptionDate, expiryDate, perilRate, tsiAmount);
						quoteItemPeril = new GIPIQuoteItemPeril(quoteId, lineCd, itemNo, perilCode, perilRate, tsiAmount, premiumAmount, remarks[x], tarfCd);
						
						if(!basicPerils[x].trim().isEmpty()){
							quoteItemPeril.setBasicPerilCd(Integer.parseInt(basicPerils[x]));
						}
						
						quoteItemPeril.setPerilType(perilTypes[x]);
						itemPerilList.add(quoteItemPeril);
					}
				}
				itemPerilParams.put("perilList" + itemNos[i], itemPerilList);
			}
		}
		return itemPerilParams;
	} 
	
	/**
	 * 
	 * @param request
	 * @param params
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> prepareRemovedDeductibles(HttpServletRequest request, Map<String, Object> params) {
		log.info("Preparing removed deductible parameters...");
		Map<String, Object> rmDeduct = new HashMap<String, Object>();
		List<GIPIQuoteDeductibles> dedList = new ArrayList<GIPIQuoteDeductibles>();
		
/*		Map<String, Object> itemDeduct = (Map<String, Object>) params.get("rmDeductibles");
		String[] dItems = (String[]) itemDeduct.get("dItemNos");
		String[] dPerilCds = (String[]) itemDeduct.get("dPerilCds");
		
		int quoteId = (Integer) params.get("quoteId");
		GIPIQuoteDeductibles quoteDeduct = new GIPIQuoteDeductibles();
		if(dPerilCds != null && dItems != null) {
			System.out.println("Number of deductible Items: " + dItems.length);	
			System.out.println("Number of deductible Items by peril: " + dPerilCds.length);	
			for(int j=0; j<dItems.length; j++) {
				quoteDeduct.setQuoteId(quoteId);
				quoteDeduct.setItemNo(Integer.parseInt(dItems[j]));
				quoteDeduct.setPerilCd(Integer.parseInt(dPerilCds[j]));
				dedList.add(quoteDeduct);
				rmDeduct.put("rmDeductibles"+dItems[j], dedList);
			}
		}
		System.out.println("removed deductibles number: " + rmDeduct.size());*/
		String[] itemNos = (String[]) params.get("itemNos");
		Map<String, Object> perItem = (Map<String, Object>) params.get("rmDeductibles");
		Map<String, Object> itemDeduct = null;
		if(itemNos != null) {
			int quoteId = (Integer) params.get("quoteId");
			GIPIQuoteDeductibles quoteDeduct = new GIPIQuoteDeductibles();
			for(int i=0; i<itemNos.length; i++) {
				itemDeduct = (Map<String, Object>) perItem.get(itemNos[i]);
				String[] dItems = (String[]) itemDeduct.get("dItemNos");
				String[] dPerilCds = (String[]) itemDeduct.get("dPerilCds");
				if(dPerilCds != null && dItems != null) {
					for(int j=0; j<dItems.length; j++) {
						quoteDeduct.setQuoteId(quoteId);
						quoteDeduct.setItemNo(Integer.parseInt(dItems[j]));
						quoteDeduct.setPerilCd(Integer.parseInt(dPerilCds[j]));
						dedList.add(quoteDeduct);
						rmDeduct.put("rmDeductibles"+dItems[j], dedList);
					}
				}
			}
		}
		
		return rmDeduct;
	}
	
	/**
	 * Prepare Additional Information for GIPIQuoteItemDAOImpl
	 * @param request
	 * @param params
	 * @return
	 */
	public Map<String, Object> prepareAdditionalInformation(HttpServletRequest request, Map<String, Object> params){
		log.info("Preparing additional information parameters...");
		Map<String, Object> additionalInformationParams = new HashMap<String, Object>();
		GIPIQuote gipiQuote = (GIPIQuote) params.get("gipiQuote");
		
		String lineCd = gipiQuote.getLineCd();
		log.info("Reinserting Additional Information [lineCd=" + lineCd + "]");
		if(request.getParameterValues("aiItemNo") != null){
			if(lineCd.equals("AH")){  	   // ACCIDENT	
				GIPIQuoteItemACFacadeService acService = (GIPIQuoteItemACFacadeService) applicationContext.getBean("gipiQuoteItemACFacadeService");
				additionalInformationParams.putAll(acService.prepareAdditionalInformationParams(request));
			}else if(lineCd.equals("AV")){ // AVIATION
				GIPIQuoteItemAVService avService = (GIPIQuoteItemAVService) applicationContext.getBean("gipiQuoteItemAVService");
				additionalInformationParams.putAll(avService.prepareAdditionalInformationParams(request));
			}else if(lineCd.equals("CA")){ // CASUALTY
				GIPIQuoteItemCAService caService = (GIPIQuoteItemCAService) applicationContext.getBean("gipiQuoteItemCAService");
				additionalInformationParams.putAll(caService.prepareAdditionalInformationParams(request));
			}else if(lineCd.equals("EN")){ // ENGINEERING
				GIPIQuoteItemENService enService = (GIPIQuoteItemENService) applicationContext.getBean("gipiQuoteItemENService");
				additionalInformationParams.putAll(enService.prepareAdditionalInformationParams(request));
			}else if(lineCd.equals("FI")){ // FIRE
				GIPIQuoteItemFIFacadeService fiService = (GIPIQuoteItemFIFacadeService) applicationContext.getBean("gipiQuoteItemFIFacadeService");
				additionalInformationParams.putAll(fiService.prepareAdditionalInformationParams(request));
			}else if(lineCd.equals("MC")){ // MOTOR CAR
				GIPIQuoteItemMCService mcService = (GIPIQuoteItemMCService) applicationContext.getBean("gipiQuoteItemMCService");
				additionalInformationParams.putAll(mcService.prepareAdditionalInformationParams(request, gipiQuote));
			}else if(lineCd.equals("MH")){ // MARINE HULL
				GIPIQuoteItemMHService mhService = (GIPIQuoteItemMHService) applicationContext.getBean("gipiQuoteItemMHService");
				additionalInformationParams.putAll(mhService.prepareAdditionalInformationParams(request));
			}else if(lineCd.equals("MN")){ // MARINE CARGO
				GIPIQuoteItemMNService mnService = (GIPIQuoteItemMNService) applicationContext.getBean("gipiQuoteItemMNService");
				additionalInformationParams.putAll(mnService.prepareAdditionalInformationParams(request));
			} 
		}
		return additionalInformationParams;
	}
	
	/**
	 * Prepare Mortgagees for GIPIQuoteItemDAOImpl
	 * @param request
	 * @param params
	 * @return
	 */
	public Map<String, Object> prepareMortgagee(HttpServletRequest request, Map<String, Object> params){
		log.info("Preparing mortgagee parameters...");
		String[] itemNos = request.getParameterValues("itemNos");
		Map<String, Object> mortgageeParams = new HashMap<String, Object>();
		List<GIPIQuoteMortgagee> mortgageeList = null;
		GIPIQuote gipiQuote = (GIPIQuote) params.get("gipiQuote");
		GIPIQuoteMortgagee aMortgagee = null;
		
		int itemNo;
		BigDecimal mortgageeAmount = null;
		String[] mortgageeItemNos 	= request.getParameterValues("mortgageeItemNos");
		String[] mortgageeCodes		= request.getParameterValues("mortgageeCodes");
		String[] mortgageeAmounts	= request.getParameterValues("mortgageeAmounts");
		
		if(itemNos!=null){
			for(int i = 0;  i < itemNos.length; i++){
				mortgageeList = new ArrayList<GIPIQuoteMortgagee>();
				itemNo = Integer.parseInt(itemNos[i]);
				if(mortgageeItemNos!=null){
					for(int x = 0; x < mortgageeItemNos.length; x++){
						if(Integer.parseInt(mortgageeItemNos[x]) == itemNo){
							mortgageeAmount = new BigDecimal(mortgageeAmounts[x]);
							aMortgagee = new GIPIQuoteMortgagee(gipiQuote.getQuoteId(), 
									gipiQuote.getIssCd(), itemNo, mortgageeCodes[x], 
									mortgageeAmount, gipiQuote.getUserId());
							mortgageeList.add(aMortgagee);
						}
					}
				}
				mortgageeParams.put("mortgageeList" + itemNos[i], mortgageeList);
			}
		}
		return mortgageeParams;
	}
	
	/**
	 * Prepare deductible parameters for GIPIQuoteItemDAOImpl
	 * @param request
	 * @param params
	 * @return Map
	 */
	public Map<String, Object> prepareDeductibles(HttpServletRequest request, Map<String, Object> params){
		log.info("Preparing deductible parameters...");
		Map<String, Object> deductibleParams = new HashMap<String, Object>();
		List<GIPIQuoteDeductiblesSummary> deductibleList = null;
		String[] itemNos 		= request.getParameterValues("itemNos");
		String[] dItemNo 		= request.getParameterValues("deductItemNo");
		String[] dPerilCd		= request.getParameterValues("deductPerilCd");
		String[] dDeductibleCd	= request.getParameterValues("deductDeductibleCd");
		String[] dAmts			= request.getParameterValues("deductAmt");
		String[] dRates			= request.getParameterValues("deductRt");
		String[] dTexts			= request.getParameterValues("deductText");
		GIPIQuote gipiQuote 	= (GIPIQuote) params.get("gipiQuote");
		
		GIPIQuoteDeductiblesSummary aDeductibleSummary = null;
		int ded = 0;
		int itm = 0;
		for (int q = 0	; q < itemNos.length; q++) {
			itm = Integer.parseInt(itemNos[q]);
			deductibleList = new ArrayList<GIPIQuoteDeductiblesSummary>();
			if(dItemNo!=null){
				for(int i = 0; i < dItemNo.length; i++){
					ded = Integer.parseInt(dItemNo[i]);
					if(ded == itm){
						aDeductibleSummary = new GIPIQuoteDeductiblesSummary();
						aDeductibleSummary.setQuoteId(gipiQuote.getQuoteId());
						aDeductibleSummary.setItemNo(Integer.parseInt(dItemNo[i]));
						aDeductibleSummary.setPerilCd(Integer.parseInt(dPerilCd[i]));
						aDeductibleSummary.setDedDeductibleCd(dDeductibleCd[i]);
						aDeductibleSummary.setDeductibleAmt(new BigDecimal(isNumeric(dAmts[i])? dAmts[i].replace(",", ""): "0"));
						aDeductibleSummary.setDeductibleRate(new BigDecimal(isNumeric(dRates[i])? dRates[i]: "0"));
						aDeductibleSummary.setDeductibleText(dTexts[i]);
						aDeductibleSummary.setUserId(gipiQuote.getUserId());
						aDeductibleSummary.setLastUpdate(new Date());
						deductibleList.add(aDeductibleSummary);
					}
				}
			}
			deductibleParams.put("deductibleList" + itm, deductibleList);
		}
		return deductibleParams;
	}
	
	/**
	 * Prepare Invoice parameters for the GIPIQuoteItemDAOImpl
	 * @param request
	 * @param params
	 * @return Map
	 */
	public Map<String, Object> prepareInvoice(HttpServletRequest request, Map<String, Object> params){
		log.info("Preparing invoice parameters...");
		Map<String, Object> invoiceParams = new HashMap<String, Object>();
		
		String[] invItemNo		= request.getParameterValues("invItemNo");				
		String[] currencyCodes 	= request.getParameterValues("iCurrencyCode");			
		String[] currencyRates 	= request.getParameterValues("iCurrencyRate");
		String[] premiumAmounts = request.getParameterValues("iPremiumAmount");			
		String[] intermedNos	= request.getParameterValues("iIntermediaryNumber");	
		String[] taxAmounts		= request.getParameterValues("iTaxAmount");	
		
		GIPIQuote 	gipiQuote 		= (GIPIQuote) params.get("gipiQuote");
		BigDecimal 	currencyRate;
		BigDecimal	premiumAmount;
		BigDecimal  totalTaxAmount;
		Integer intermediaryNumber;
		int	quoteId	= gipiQuote.getQuoteId();
		int	quoteInvoiceNumber;
		int	currencyCode;
		String 	itemNo = "0";
		
		GIPIQuoteInvoiceSummary summary = null;
		
		if(invItemNo!=null){
			String[] taxCodes;
			String[] taxAmts;
			String[] rateInvs;
			
			GIPIQuoteInvTax invTax = null;
			int invTaxCode = 0;
			int invTaxId   = 1;
			String tmpStrInvTaxRate = "";
			String tmpStrInvTaxAmount = "";
			BigDecimal invTaxRate = null;
			BigDecimal invTaxAmount = null;
			
			String strCurrencyRate;
			String strPremiumAmount;
			String strTaxAmount;
			String strIntermeds;
			for(int i = 0; i < invItemNo.length; i++){
				itemNo = invItemNo[i];
				strCurrencyRate 	= this.isNumeric(currencyRates[i]) 	? currencyRates[i].replace(",", "")	: "0";
				strPremiumAmount 	= this.isNumeric(premiumAmounts[i]) ? premiumAmounts[i].replace(",", ""): "0";
				strTaxAmount 		= this.isNumeric(taxAmounts[i]) 	? taxAmounts[i].replace(",", "") 	: "0";
				strIntermeds		= this.isNumeric(intermedNos[i]) 	? intermedNos[i].replace(",", "") : "0";
				
				currencyRate	= new BigDecimal(strCurrencyRate);
				premiumAmount	= new BigDecimal(strPremiumAmount);
				totalTaxAmount	= new BigDecimal(strTaxAmount);
				intermediaryNumber = Integer.parseInt(strIntermeds);
				quoteId	= gipiQuote.getQuoteId();
				quoteInvoiceNumber = 0;
				currencyCode = Integer.parseInt(currencyCodes[i]);
				
				summary = new GIPIQuoteInvoiceSummary(quoteId, gipiQuote.getIssCd(), quoteInvoiceNumber,
						currencyCode, currencyRate, premiumAmount, intermediaryNumber, totalTaxAmount);
				
				taxCodes 	= request.getParameterValues("taxCode"	+ itemNo);
				taxAmts  	= request.getParameterValues("taxAmount"+ itemNo);
				rateInvs 	= request.getParameterValues("rateInv"	+ itemNo);
				
				if(taxCodes!=null){
					for(int r = 0; r < taxCodes.length; r++){
						invTaxCode 	= Integer.parseInt(isNumeric(taxCodes[r]) ? taxCodes[r] : "0");
						tmpStrInvTaxAmount 	= taxAmts[r].replace(",", "");
						tmpStrInvTaxRate 	= rateInvs[r].replace(",", "");
						
						invTaxAmount	= new BigDecimal(isNumeric(tmpStrInvTaxAmount) ? tmpStrInvTaxAmount : "0");
						invTaxRate 		= new BigDecimal(isNumeric(tmpStrInvTaxRate) ? tmpStrInvTaxRate : "0");
						invTax 			= new GIPIQuoteInvTax(gipiQuote.getLineCd(), gipiQuote.getIssCd(), 1, invTaxCode, invTaxId, invTaxAmount, invTaxRate, null, 0, null);
						/*
						if(invTax==null){
							System.out.println("1234567890");
						}else{
							System.out.println("0987654321");
						}
						*/
						summary.addInvoiceTax(invTax);
					}
				}
				invoiceParams.put("invoiceList" + itemNo, summary);
			}
		}
		return invoiceParams;
	}

	/**
	 * Gets the item perils.
	 * 
	 * @param quoteId the quote id
	 * @param itemNo the item no
	 * @return the item perils
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIQuoteItemPerilSummary> getItemPerils(int quoteId, int itemNo) throws SQLException{
		GIPIQuoteItemPerilFacadeService gipiQuoteItemPerilFacadeService = (GIPIQuoteItemPerilFacadeService) applicationContext.getBean("gipiQuoteItemPerilFacadeService"); // +env
		List<GIPIQuoteItemPerilSummary> finalPerils = new ArrayList<GIPIQuoteItemPerilSummary>();
		for (GIPIQuoteItemPerilSummary item: gipiQuoteItemPerilFacadeService.getQuoteItemPerilSummaryList(quoteId))	{
			if(itemNo == item.getItemNo()){
				finalPerils.add(item);
			}
		}
		return finalPerils;
	}
	
	/**
	 * Check if the string is a numeric value
	 * @param queryString
	 * @return true if it is numeric
	 * @return false if non-numeric 
	 */
	private boolean isNumeric(String possiblyNumericString){
		try{
			Float.parseFloat(possiblyNumericString.replace(",", ""));
			return true;
		} catch (NumberFormatException e) {
			return false;
		}
	}
}