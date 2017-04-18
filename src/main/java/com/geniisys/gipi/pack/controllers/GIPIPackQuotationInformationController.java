package com.geniisys.gipi.pack.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuoteItemAC;
import com.geniisys.gipi.entity.GIPIQuoteItemAV;
import com.geniisys.gipi.entity.GIPIQuoteItemCA;
import com.geniisys.gipi.entity.GIPIQuoteItemEN;
import com.geniisys.gipi.entity.GIPIQuoteItemFI;
import com.geniisys.gipi.entity.GIPIQuoteItemMC;
import com.geniisys.gipi.entity.GIPIQuoteItemMH;
import com.geniisys.gipi.entity.GIPIQuoteItemMN;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;
import com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService;
import com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService;
import com.geniisys.gipi.service.GIPIQuotePicturesService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIPackQuotationInformationController extends BaseController  {

	private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(GIPIPackQuotationInformationController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		GIPIQuoteFacadeService quoteService = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService");
		GIPIQuoteItemFacadeService gipiQuoteItemFacadeService = (GIPIQuoteItemFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemFacadeService");
		GIPIQuoteItemPerilFacadeService gipiQuoteItemPerilFacadeService = (GIPIQuoteItemPerilFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteItemPerilFacadeService");
		
		try{
			if("showPackQuotationInformationPage".equals(ACTION)){
				Integer packQuoteId = request.getParameter("packQuoteId")== null ? 0 : Integer.parseInt(request.getParameter("packQuoteId"));
					
				log.info("Retrieving Package quotation information for pack_quote_id: " + packQuoteId);
				List<GIPIQuote> packQuoteList = quoteService.getGipiPackQuoteList(packQuoteId);
				StringFormatter.escapeHTMLInList(packQuoteList);
				List<GIPIQuoteItem> packQuoteItemList = gipiQuoteItemFacadeService.getGIPIQuoteItemListForPack(packQuoteId);
				StringFormatter.escapeHTMLInList(packQuoteItemList);
				List<GIPIQuoteItemPerilSummary> packQuotePerilList = gipiQuoteItemPerilFacadeService.getGIPIQuoteItemPerilSummaryListForPack(packQuoteId);
				StringFormatter.escapeHTMLInList(packQuotePerilList);
				
				String[] params = {"", ""};
				request.setAttribute("objPackQuoteList", new JSONArray(packQuoteList));
				request.setAttribute("objPackQuoteItemList", new JSONArray(packQuoteItemList));
				request.setAttribute("objPackQuoteItemPerilList", new JSONArray(packQuotePerilList));
				request.setAttribute("packQuoteList", packQuoteList);
				request.setAttribute("currencyLovJSON", new JSONArray(lovHelper.getList(LOVHelper.CURRENCY_CODES)));
				request.setAttribute("coverageLovJSON", new JSONArray(lovHelper.getList(LOVHelper.COVERAGE_CODES,params)));
				request.setAttribute("defaultCurrencyCd", (lovHelper.getList(LOVHelper.DEFAULT_CURRENCY)).get(0).getCode());
				request.setAttribute("fromCreatePackQuote", request.getParameter("fromCreatePackQuote") == null ? "N" : "Y");
				
				List<GIPIQuote> packQuoteIncludedLinesList = quoteService.getIncludedLinesOfPackQuote(packQuoteId);
				request.setAttribute("packLines", packQuoteIncludedLinesList);
				StringFormatter.escapeHTMLInList(packQuoteIncludedLinesList);
				request.setAttribute("objPackLines", new JSONArray(packQuoteIncludedLinesList));
				
				for(GIPIQuote quote : packQuoteIncludedLinesList){
					String lineCd = quote.getLineCd();
					String menuLineCd = quote.getMenuLineCd();
					this.setAttributesForListing(lineCd, menuLineCd, request, lovHelper);
				}
				
				PAGE = "/pages/marketing/quotation-pack/quotationInformation-pack/packQuotationInformationMain.jsp";
			}else if("savePackQuotationInformation".equals(ACTION)){
				GIPIQuoteDeductiblesFacadeService gipiQuoteDeductiblesFacadeService = (GIPIQuoteDeductiblesFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteDeductiblesFacadeService");
				GIPIQuoteMortgageeFacadeService gipiQuoteMortgageeFacadeService = (GIPIQuoteMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteMortgageeFacadeService");
				GIPIQuoteInvoiceFacadeService gipiQuoteInvoiceFacadeService = (GIPIQuoteInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteInvoiceFacadeService");
				
				Map<String,Object> params = new HashMap<String, Object>();
				JSONObject objParam = new JSONObject(request.getParameter("parameters"));
				params.put("setItemRows", gipiQuoteItemFacadeService.prepareGipiQuoteItemJSON(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), USER));
				params.put("delItemRows", gipiQuoteItemFacadeService.prepareGipiQuoteItemJSON(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")), USER));
				params.put("setPerilRows", gipiQuoteItemPerilFacadeService.prepareItemPerilSummaryJSON(new JSONArray(objParam.isNull("setPerilRows") ? null : objParam.getString("setPerilRows")), USER));
				params.put("delPerilRows", gipiQuoteItemPerilFacadeService.prepareItemPerilSummaryJSON(new JSONArray(objParam.isNull("delPerilRows") ? null : objParam.getString("delPerilRows")), USER));
				params.put("setDeductibleRows", gipiQuoteDeductiblesFacadeService.prepareGIPIQuoteDeductiblesSummaryJSON(new JSONArray(objParam.isNull("setDeductibleRows") ? null : objParam.getString("setDeductibleRows")), USER));
				params.put("delDeductibleRows", gipiQuoteDeductiblesFacadeService.prepareGIPIQuoteDeductiblesSummaryJSON(new JSONArray(objParam.isNull("delDeductibleRows") ? null : objParam.getString("delDeductibleRows")), USER));
				params.put("setMortgageeRows", gipiQuoteMortgageeFacadeService.prepareMortgageeInformationJSON(new JSONArray(objParam.isNull("setMortgageeRows") ? null : objParam.getString("setMortgageeRows")), USER));
				params.put("delMortgageeRows", gipiQuoteMortgageeFacadeService.prepareMortgageeInformationJSON(new JSONArray(objParam.isNull("delMortgageeRows") ? null : objParam.getString("delMortgageeRows")), USER));
				params.put("setInvoiceRows", gipiQuoteInvoiceFacadeService.prepareQuoteInvoiceJSON(new JSONArray(objParam.isNull("setInvoiceRows") ? null : objParam.getString("setInvoiceRows")), USER));
				params.put("delInvoiceRows", gipiQuoteInvoiceFacadeService.prepareQuoteInvoiceJSON(new JSONArray(objParam.isNull("delInvoiceRows") ? null : objParam.getString("delInvoiceRows")), USER));
				params.put("setAIRows", preparePackQuoteItemAdditionalInfo(new JSONArray(objParam.isNull("setItemRows") ? null : objParam.getString("setItemRows")), USER));
				params.put("delAIRows", preparePackQuoteItemAdditionalInfo(new JSONArray(objParam.isNull("delItemRows") ? null : objParam.getString("delItemRows")), USER));
				params.put("accountOfSW", Integer.parseInt(request.getParameter("accountOfSW")));
				gipiQuoteItemFacadeService.saveGIPIQuoteItemForPackQuotation(params);
				
				// delete attachments
				GIPIQuotePicturesService gipiQuotePicturesService = (GIPIQuotePicturesService) APPLICATION_CONTEXT.getBean("gipiQuotePicturesService");
				List<GIPIQuoteItem> delItemRows = (List<GIPIQuoteItem>) params.get("delItemRows");
				gipiQuotePicturesService.deleteItemsAttachment(delItemRows);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){ //added by steven 01/30/2013
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			//message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
	public void setAttributesForListing(String lineCd, String menuLineCd, HttpServletRequest request, LOVHelper lovHelper) throws JSONException{
		log.info("Loading listing for lineCd: " + lineCd + ", menuLineCd:" + menuLineCd);
		
		if ("AC".equals(lineCd) || "AC".equals(menuLineCd)){
			request.setAttribute("positionList", lovHelper.getList(LOVHelper.POSITION_LISTING));
			String[] domainSex = {"SEX"};
			request.setAttribute("sexList", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainSex));
			String[] domainCS = {"CIVIL STATUS"};
			request.setAttribute("civilStatusList", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainCS));
		}else if ("AV".equals(lineCd) || "AV".equals(menuLineCd)) {
			request.setAttribute("aircrafts", lovHelper.getList(LOVHelper.AIRCRAFT_LISTING));
		}else if ("FI".equals(lineCd) || "FI".equals(menuLineCd)) {
			request.setAttribute("itemTypeList", lovHelper.getList(LOVHelper.FIRE_ITEM_TYPE_LISTING));
			request.setAttribute("tariffZoneList", lovHelper.getList(LOVHelper.ALL_TARIFF_ZONE_LISTING));
			request.setAttribute("tariffList", lovHelper.getList(LOVHelper.TARIFF_LISTING));
			request.setAttribute("constructionList", lovHelper.getList(LOVHelper.FIRE_CONSTRUCTION_LISTING));
		}else if ("CA".equals(lineCd) || "CA".equals(menuLineCd)) {
			request.setAttribute("positionLov", lovHelper.getList(LOVHelper.POSITION_LISTING));
			request.setAttribute("hazardLov", lovHelper.getList(LOVHelper.SECTION_OR_HAZARD_LISTING));
		}else if ("MH".equals(lineCd) || "MH".equals(menuLineCd)) {
			request.setAttribute("marineHulls", lovHelper.getList(LOVHelper.ALL_MARINE_HULL_LISTING));
		}else if ("MC".equals(lineCd) || "MC".equals(menuLineCd)) {
			request.setAttribute("typeOfBodies", lovHelper.getList(LOVHelper.TYPE_OF_BODY_LISTING));
			request.setAttribute("allMotorTypesLOV", new JSONArray(lovHelper.getList(LOVHelper.ALL_MOTOR_TYPE_LISTING)));
			request.setAttribute("allSublineTypesLOV", new JSONArray(lovHelper.getList(LOVHelper.ALL_SUBLINE_TYPE_LISTING)));
		}else if ("MN".equals(lineCd) || "MN".equals(menuLineCd)) {
			String[] printTagParams = {"GIPI_WCARGO.PRINT_TAG"};
			request.setAttribute("cargoClasses", lovHelper.getList(LOVHelper.CARGO_CLASS_LISTING));
			request.setAttribute("cargoTypes", lovHelper.getList(LOVHelper.CARGO_TYPE_LISTING));
			request.setAttribute("printTags", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, printTagParams));
		}
	}
	
	public List<Object> preparePackQuoteItemAdditionalInfo(JSONArray rows, GIISUser USER) throws JSONException{
		List<Object> aiList = new ArrayList<Object>();
		
		for(int index=0; index<rows.length(); index++){
			JSONObject objItem = rows.getJSONObject(index);
			String lineCd = objItem.isNull("lineCd") ? "" : StringEscapeUtils.unescapeHtml(objItem.getString("lineCd"));
			String menuLineCd = objItem.isNull("menuLineCd") ? "" : StringEscapeUtils.unescapeHtml(objItem.getString("menuLineCd"));
			System.out.println("Line code: " + lineCd + " MenulineCd: " + menuLineCd);
			
			if((lineCd.equals("CA") || menuLineCd.equals("CA")) && !objItem.isNull("gipiQuoteItemCA")){
				GIPIQuoteItemCA itemCA = new GIPIQuoteItemCA();
				JSONObject objItemAI = new JSONObject(objItem.getString("gipiQuoteItemCA"));
				itemCA = (GIPIQuoteItemCA) JSONUtil.prepareObjectFromJSON(objItemAI, USER.getUserId(), GIPIQuoteItemCA.class);
				aiList.add(itemCA);
			}else if((lineCd.equals("EN") || menuLineCd.equals("EN")) && !objItem.isNull("gipiQuoteItemEN")){
				GIPIQuoteItemEN itemEN = new GIPIQuoteItemEN();
				JSONObject objItemAI = new JSONObject(objItem.getString("gipiQuoteItemEN"));
				itemEN = (GIPIQuoteItemEN) JSONUtil.prepareObjectFromJSON(objItemAI, USER.getUserId(), GIPIQuoteItemEN.class);
				aiList.add(itemEN);
			}else if((lineCd.equals("FI") || menuLineCd.equals("FI")) && !objItem.isNull("gipiQuoteItemFI")){
				GIPIQuoteItemFI itemFI = new GIPIQuoteItemFI();
				JSONObject objItemAI = new JSONObject(objItem.getString("gipiQuoteItemFI")); 
				itemFI = (GIPIQuoteItemFI) JSONUtil.prepareObjectFromJSON(objItemAI, USER.getUserId(), GIPIQuoteItemFI.class);
				aiList.add(itemFI);
			}else if((lineCd.equals("MC") || menuLineCd.equals("MC")) && !objItem.isNull("gipiQuoteItemMC")){
				GIPIQuoteItemMC itemMC = new GIPIQuoteItemMC();
				JSONObject objItemAI = new JSONObject(objItem.getString("gipiQuoteItemMC"));
				itemMC = (GIPIQuoteItemMC) JSONUtil.prepareObjectFromJSON(objItemAI, USER.getUserId(), GIPIQuoteItemMC.class);
				aiList.add(itemMC);
			}else if((lineCd.equals("MN") || menuLineCd.equals("MN")) && !objItem.isNull("gipiQuoteItemMN")){
				GIPIQuoteItemMN itemMN = new GIPIQuoteItemMN();
				JSONObject objItemAI = new JSONObject(objItem.getString("gipiQuoteItemMN")); 
				itemMN = (GIPIQuoteItemMN) JSONUtil.prepareObjectFromJSON(objItemAI, USER.getUserId(), GIPIQuoteItemMN.class);
				aiList.add(itemMN);
			}else if((lineCd.equals("AC") || menuLineCd.equals("AC")) && !objItem.isNull("gipiQuoteItemAC")){
				GIPIQuoteItemAC itemAC = new GIPIQuoteItemAC();
				JSONObject objItemAI = new JSONObject(objItem.getString("gipiQuoteItemAC")); 
				itemAC = (GIPIQuoteItemAC) JSONUtil.prepareObjectFromJSON(objItemAI, USER.getUserId(), GIPIQuoteItemAC.class);
				aiList.add(itemAC);
			}else if((lineCd.equals("AV") || menuLineCd.equals("AV")) && !objItem.isNull("gipiQuoteItemAV")){
				GIPIQuoteItemAV itemAV = new GIPIQuoteItemAV();
				JSONObject objItemAI = new JSONObject(objItem.getString("gipiQuoteItemAV")); 
				itemAV = (GIPIQuoteItemAV) JSONUtil.prepareObjectFromJSON(objItemAI, USER.getUserId(), GIPIQuoteItemAV.class);
				aiList.add(itemAV);
			}else if((lineCd.equals("MH") || menuLineCd.equals("MH")) && !objItem.isNull("gipiQuoteItemMH")){
				GIPIQuoteItemMH itemMH = new GIPIQuoteItemMH();
				JSONObject objItemAI = new JSONObject(objItem.getString("gipiQuoteItemMH")); 
				itemMH = (GIPIQuoteItemMH) JSONUtil.prepareObjectFromJSON(objItemAI, USER.getUserId(), GIPIQuoteItemMH.class);
				aiList.add(itemMH);
			}
		}
		
		return aiList;
	}

}
