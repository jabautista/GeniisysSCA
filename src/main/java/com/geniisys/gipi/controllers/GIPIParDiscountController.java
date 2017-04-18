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
import java.util.ArrayList;
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

import com.geniisys.common.entity.GIISSubline;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISSublineFacadeService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWItemDiscount;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWPerilDiscount;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWPolbasDiscount;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWItemDiscountService;
import com.geniisys.gipi.service.GIPIWPerilDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasDiscountService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIParDiscountController.
 */
public class GIPIParDiscountController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIParDiscountController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try {
			/* default attributes */
			log.info("Initializing: " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/* end of default attributes */
			
			int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
			String lineCd = request.getParameter("lineCd");
			System.out.println("ACTION: "+ACTION);
			System.out.println("PAR ID: "+ parId);
		    
			if("showBillDiscount".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				GIPIWPolbasDiscountService gipiWPolbasDiscountService = (GIPIWPolbasDiscountService) APPLICATION_CONTEXT.getBean("gipiWPolbasDiscountService");
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIISSublineFacadeService giisSublineFacadeService = (GIISSublineFacadeService) APPLICATION_CONTEXT.getBean("giisSublineFacadeService");
				GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				GIPIWItemDiscountService gipiWItemDiscountService = (GIPIWItemDiscountService) APPLICATION_CONTEXT.getBean("gipiWItemDiscountService");
				GIPIWPerilDiscountService gipiWPerilDiscountService = (GIPIWPerilDiscountService) APPLICATION_CONTEXT.getBean("gipiWPerilDiscountService");
				
				log.info("Getting discount/surcharge details...");
				GIPIPARList gipiParList = null;
				GIISSubline giisSubline = null;
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				String sublineCd = par.getSublineCd();
				
				giisSubline = giisSublineFacadeService.getSublineDetails(lineCd, sublineCd);
				request.setAttribute("benefitFlag", giisSubline.getBenefitFlag());
				
				gipiParList = gipiParService.getGIPIPARDetails(parId);
				request.setAttribute("gipiParList", gipiParList);
				
				request.setAttribute("parNo", gipiParList.getParNo());
				request.setAttribute("assdName", gipiParList.getAssdName());
			
				List<GIPIWPolbasDiscount> gipiWPolbasDiscount = gipiWPolbasDiscountService.getGipiWPolbasDiscount(parId);
				request.setAttribute("listBasic", gipiWPolbasDiscount);
				
				String[] args = {request.getParameter("parId")};
				List<LOV> billItems = (List<LOV>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.WITEM_DISCOUNT_LISTING, args));
				request.setAttribute("billItems", billItems);
				request.setAttribute("billItemsJSON", new JSONArray((List<LOV>) billItems)); //added by steven 10/01/2012
				
				Map origPremAmt = new HashMap();
				origPremAmt = gipiWPolbasDiscountService.getOrigPremAmt(parId);
				String origPremAmt2 = (String) origPremAmt.get("origPremAmt");
				
				Map origPremAmt3 = new HashMap();
				origPremAmt3 = gipiWPolbasDiscountService.getOrigPremAmt2(parId);
				String origPremAmt4 = (String) origPremAmt3.get("origPremAmt");
				String netPremAmt4 = (String) origPremAmt3.get("netPremAmt");
				
				if (origPremAmt2.equals("0")){
					request.setAttribute("origPremAmt", origPremAmt4);
					request.setAttribute("netPremAmt", netPremAmt4);
				} else {
					request.setAttribute("origPremAmt", origPremAmt2);
					request.setAttribute("netPremAmt", origPremAmt2);
				}
				
				Map netPolPrem = new HashMap();
				netPolPrem = gipiWPolbasDiscountService.getNetPolPrem(parId);
				String discTotal = (String) netPolPrem.get("discTotal");
				String surcTotal = (String) netPolPrem.get("surcTotal");
				request.setAttribute("discTotal", discTotal);
				request.setAttribute("surcTotal", surcTotal);
				
				List<GIPIWItemDiscount> gipiWItemDiscount = gipiWItemDiscountService.getGipiWItemDiscount(parId);
				request.setAttribute("listItem", gipiWItemDiscount);

				List<GIPIWPerilDiscount> gipiWPerilDiscount = gipiWPerilDiscountService.getGipiWPerilDiscount(parId);
				request.setAttribute("listPeril", gipiWPerilDiscount);
				
				String[] params = {request.getParameter("parId") , lineCd};
				List<LOV> itemPerils = lovHelper.getList(LOVHelper.WPERIL_LISTING3, params);
				request.setAttribute("perilListing", itemPerils);
				request.setAttribute("perilListingJSON", new JSONArray((List<GIPIWItemPeril>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.WPERIL_LISTING3, params))));
				
				message = "SUCCESS";
				PAGE = "/pages/underwriting/billDiscountSurcharge.jsp";
			} else if("saveBillDiscount".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIPIWPolbasDiscountService gipiWPolbasDiscountService = (GIPIWPolbasDiscountService) APPLICATION_CONTEXT.getBean("gipiWPolbasDiscountService");
				
				log.info("Saving discount/surcharge details...");
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				String sublineCd = StringFormatter.unescapeHtmlJava(par.getSublineCd()); //Deo [01.03.2017]: added StringFormatter (SR-23567)
				
				HashMap<String, Object> mainParams = new HashMap<String, Object>();
				mainParams = prepareAll(request, parId, lineCd, sublineCd);
				gipiWPolbasDiscountService.saveAllDiscount(mainParams);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getItemPerils".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				String[] params = {request.getParameter("parId") , lineCd, request.getParameter("itemNo")};
				List<LOV> itemPerils = lovHelper.getList(LOVHelper.ITEM_PERIL_LISTING, params);
				request.setAttribute("perilListing", itemPerils);
				PAGE = "/pages/underwriting/dynamicDropDown/peril.jsp";
			} else if ("getOrigItemPremAmt".equals(ACTION)){		
				GIPIWItemDiscountService gipiWItemDiscountService = (GIPIWItemDiscountService) APPLICATION_CONTEXT.getBean("gipiWItemDiscountService");
				String itemNo = request.getParameter("itemNo");
				Map origPremAmtItem = new HashMap();
				origPremAmtItem = gipiWItemDiscountService.getOrigItemPrem(parId, itemNo);
				String origPremAmt = (String) origPremAmtItem.get("origPremAmt");
				String netPremAmt = (String) origPremAmtItem.get("netPremAmt");
				message = origPremAmt+","+netPremAmt;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getNetItemPrem".equals(ACTION)){
				log.info("Getting item net premium amount...");
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIPIWPolbasDiscountService gipiWPolbasDiscountService = (GIPIWPolbasDiscountService) APPLICATION_CONTEXT.getBean("gipiWPolbasDiscountService");
				
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				String sublineCd = par.getSublineCd();
				
				HashMap<String, Object> mainParams = new HashMap<String, Object>();
				mainParams = prepareAll(request, parId, lineCd, sublineCd);
				
				Map netPremAmtItem = new HashMap();
				mainParams.put("itemNo", request.getParameter("itemNo"));
				netPremAmtItem = gipiWPolbasDiscountService.getNetItemPrem(mainParams);
				
				String discTotal = (String) netPremAmtItem.get("discTotal");
				String surcTotal = (String) netPremAmtItem.get("surcTotal");
				
				message = discTotal+ApplicationWideParameters.RESULT_MESSAGE_DELIMITER+surcTotal;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getOrigPerilPremAmt".equals(ACTION)){
				GIPIWPerilDiscountService gipiWPerilDiscountService = (GIPIWPerilDiscountService) APPLICATION_CONTEXT.getBean("gipiWPerilDiscountService");
				String itemNo = request.getParameter("itemNo");
				String perilCd = request.getParameter("perilCd");
				Map origPerilPremAmtItem = new HashMap();
				origPerilPremAmtItem = gipiWPerilDiscountService.getOrigPerilPrem(parId, itemNo, perilCd);
				String origPerilPremAmt = (String) origPerilPremAmtItem.get("origPerilPremAmt");
				String netPremAmt = (String) origPerilPremAmtItem.get("netPremAmt");
				
				String sequence = request.getParameter("sequence");
				Map setOrigAmounts = new HashMap();
				setOrigAmounts = gipiWPerilDiscountService.setOrigAmount2(parId, itemNo, perilCd, sequence);
				String origPerilAnnPremAmt = (String) setOrigAmounts.get("origPerilAnnPremAmt");
				String origItemAnnPremAmt = (String) setOrigAmounts.get("origItemAnnPremAmt");
				String origPolAnnPremAmt = (String) setOrigAmounts.get("origPolAnnPremAmt");
				
				message = origPerilPremAmt+","+netPremAmt+","+origPerilAnnPremAmt+","+origItemAnnPremAmt+","+origPolAnnPremAmt;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getNetPerilPrem".equals(ACTION)){		
				log.info("Getting item peril net premium amount...");
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIPIWPolbasDiscountService gipiWPolbasDiscountService = (GIPIWPolbasDiscountService) APPLICATION_CONTEXT.getBean("gipiWPolbasDiscountService");
				
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				String sublineCd = par.getSublineCd();
				
				HashMap<String, Object> mainParams = new HashMap<String, Object>();
				mainParams = prepareAll(request, parId, lineCd, sublineCd);
				
				Map netPremAmtItem = new HashMap();
				mainParams.put("itemNo", request.getParameter("itemNo"));
				mainParams.put("perilCd", request.getParameter("perilCd"));
				mainParams.put("sequenceNoPeril", request.getParameter("sequenceNoPeril")); //Added by Apollo Cruz 09.17.2014
				netPremAmtItem = gipiWPolbasDiscountService.getNetPerilPrem(mainParams);
				
				String discTotal = (String) netPremAmtItem.get("discTotal");
				String surcTotal = (String) netPremAmtItem.get("surcTotal");
				
				message = discTotal+ApplicationWideParameters.RESULT_MESSAGE_DELIMITER+surcTotal;
				PAGE = "/pages/genericMessage.jsp";
			} else if("getDeleteDiscountList".equals(ACTION)){
				GIPIWPerilDiscountService gipiWPerilDiscountService = (GIPIWPerilDiscountService) APPLICATION_CONTEXT.getBean("gipiWPerilDiscountService");
				
				request.setAttribute("object", new JSONArray(gipiWPerilDiscountService.getDeleteDiscountList(parId)));				
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateSurchargeAmt".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIPIWPolbasDiscountService gipiWPolbasDiscountService = (GIPIWPolbasDiscountService) APPLICATION_CONTEXT.getBean("gipiWPolbasDiscountService");
				
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				String sublineCd = par.getSublineCd();
				
				HashMap<String, Object> mainParams = new HashMap<String, Object>();
				mainParams = prepareAll(request, parId, lineCd, sublineCd);
				
				log.info("Validating surcharge amount...");
				message = gipiWPolbasDiscountService.validateSurchargeAmt(mainParams);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateDiscSurcAmtItem".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIPIWPolbasDiscountService gipiWPolbasDiscountService = (GIPIWPolbasDiscountService) APPLICATION_CONTEXT.getBean("gipiWPolbasDiscountService");
				
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				String sublineCd = par.getSublineCd();
				
				HashMap<String, Object> mainParams = new HashMap<String, Object>();
				mainParams = prepareAll(request, parId, lineCd, sublineCd);
				mainParams.put("itemNo", request.getParameter("itemNo"));
				
				log.info("Validating item amount...");
				message = gipiWPolbasDiscountService.validateDiscSurcAmtItem(mainParams);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getItemPerilsPerItem".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIPIWPolbasDiscountService gipiWPolbasDiscountService = (GIPIWPolbasDiscountService) APPLICATION_CONTEXT.getBean("gipiWPolbasDiscountService");
				
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				String sublineCd = par.getSublineCd();
				
				HashMap<String, Object> mainParams = new HashMap<String, Object>();
				mainParams = prepareAll(request, parId, lineCd, sublineCd);
				mainParams.put("itemNo", request.getParameter("itemNo"));
				
				log.info("Getting item perils...");
				message = gipiWPolbasDiscountService.getItemPerilsPerItem(mainParams);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateDiscSurcAmtPeril".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIPIWPolbasDiscountService gipiWPolbasDiscountService = (GIPIWPolbasDiscountService) APPLICATION_CONTEXT.getBean("gipiWPolbasDiscountService");
				
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				String sublineCd = StringFormatter.unescapeHtmlJava(par.getSublineCd()); //Deo [01.03.2017]: added StringFormatter (SR-23567)
				
				HashMap<String, Object> mainParams = new HashMap<String, Object>();
				mainParams = prepareAll(request, parId, lineCd, sublineCd);
				mainParams.put("itemNo", request.getParameter("itemNo"));
				mainParams.put("perilCd", request.getParameter("perilCd"));
				mainParams.put("toDo", request.getParameter("toDo"));
				log.info("Validating peril amount...");
				message = gipiWPolbasDiscountService.validateDiscSurcAmtPeril(mainParams);
				PAGE = "/pages/genericMessage.jsp";
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
	
	private List<GIPIWPerilDiscount> preparePerilDisc(
			HttpServletRequest request, int parId, String lineCd,
			String sublineCd) {
		List<GIPIWPerilDiscount> wperilDisc = new ArrayList<GIPIWPerilDiscount>();
		
		String[] perilItemNos = request.getParameterValues("perilItemNos");
		String[] perilSequenceNos = request.getParameterValues("perilSequenceNos");
		String[] perilCodes = request.getParameterValues("perilCodes");
		String[] perilLevelTags = request.getParameterValues("perilLevelTags");
		String[] perilNetPremAmts = request.getParameterValues("perilNetPremAmts");
		String[] perilOrigPerilPremAmt = request.getParameterValues("perilOrigPerilPremAmt");
		String[] perilDiscountAmts = request.getParameterValues("perilDiscountAmts");
		String[] perilDiscountRts = request.getParameterValues("perilDiscountRts");
		String[] perilSurchargeAmts = request.getParameterValues("perilSurchargeAmts");
		String[] perilSurchargeRts = request.getParameterValues("perilSurchargeRts");
		String[] perilNetGrossTags = request.getParameterValues("perilNetGrossTags");
		String[] perilRemarks = request.getParameterValues("perilRemarks");
		String[] perilOrigPerilAnnPremAmt = request.getParameterValues("perilOrigPerilAnnPremAmt");
		String[] perilOrigItemAnnPremAmt = request.getParameterValues("perilOrigItemAnnPremAmt");
		String[] perilOrigPolAnnPremAmt = request.getParameterValues("perilOrigPolAnnPremAmt");
		
		if (request.getParameterValues("perilSequenceNos") != null) {
			for (int a = 0; a < perilSequenceNos.length; a++) {
				wperilDisc.add(new GIPIWPerilDiscount(parId,perilItemNos[a],lineCd,perilCodes[a],
						sublineCd,(perilDiscountRts[a] == null || perilDiscountRts[a] == "" ? null : new BigDecimal(perilDiscountRts[a].replaceAll(",", ""))),
						perilLevelTags[a],(perilDiscountAmts[a] == null || perilDiscountAmts[a] == "" ? null : new BigDecimal(perilDiscountAmts[a].replaceAll(",", ""))),
						(perilNetGrossTags[a] == null || perilNetGrossTags[a] == "" ? "N" : perilNetGrossTags[a]),
						(perilOrigPerilPremAmt[a] == null || perilOrigPerilPremAmt[a] == "" ? null : new BigDecimal(perilOrigPerilPremAmt[a].replaceAll(",", ""))),
						perilSequenceNos[a],perilRemarks[a],
						(perilNetPremAmts[a] == null || perilNetPremAmts[a] == "" ? null : new BigDecimal(perilNetPremAmts[a].replaceAll(",", ""))),
						(perilOrigPerilAnnPremAmt[a] == null || perilOrigPerilAnnPremAmt[a] == "" ? null : new BigDecimal(perilOrigPerilAnnPremAmt[a].replaceAll(",", ""))),
						(perilOrigItemAnnPremAmt[a] == null || perilOrigItemAnnPremAmt[a] == "" ? null : new BigDecimal(perilOrigItemAnnPremAmt[a].replaceAll(",", ""))),
						(perilOrigPolAnnPremAmt[a] == null || perilOrigPolAnnPremAmt[a] == "" ? null : new BigDecimal(perilOrigPolAnnPremAmt[a].replaceAll(",", ""))),
						(perilSurchargeRts[a] == null || perilSurchargeRts[a] == "" ? null : new BigDecimal(perilSurchargeRts[a].replaceAll(",", ""))),
						(perilSurchargeAmts[a] == null || perilSurchargeAmts[a] == "" ? null : new BigDecimal(perilSurchargeAmts[a].replaceAll(",", "")))
						));
			}
		}
		return wperilDisc;
	}

	private List<GIPIWItemDiscount> prepareItemDisc(HttpServletRequest request,
			Integer parId, String lineCd, String sublineCd) {
		List<GIPIWItemDiscount> witemDisc = new ArrayList<GIPIWItemDiscount>();
		
		String[] itemItemNos = request.getParameterValues("itemItemNos");
		String[] itemSequenceNos = request.getParameterValues("itemSequenceNos");
		String[] itemNetPremAmts = request.getParameterValues("itemNetPremAmts");
		String[] itemOrigPremAmts = request.getParameterValues("itemOrigPremAmts");
		String[] itemDiscountAmts = request.getParameterValues("itemDiscountAmts");
		String[] itemDiscountRts = request.getParameterValues("itemDiscountRts");
		String[] itemSurchargeAmts = request.getParameterValues("itemSurchargeAmts");
		String[] itemSurchargeRts = request.getParameterValues("itemSurchargeRts");
		String[] itemNetGrossTags = request.getParameterValues("itemNetGrossTags");
		String[] itemRemarks = request.getParameterValues("itemRemarks");
		
		if (request.getParameterValues("itemSequenceNos") != null) {
			for (int a = 0; a < itemSequenceNos.length; a++) {
				witemDisc.add(new GIPIWItemDiscount(parId,lineCd,itemItemNos[a],sublineCd,
						(itemDiscountRts[a] == null || itemDiscountRts[a] == "" ? null : new BigDecimal(itemDiscountRts[a].replaceAll(",", ""))),
						(itemDiscountAmts[a] == null || itemDiscountAmts[a] == "" ? null : new BigDecimal(itemDiscountAmts[a].replaceAll(",", ""))),
						(itemNetGrossTags[a] == null || itemNetGrossTags[a] == "" ? "N" : itemNetGrossTags[a]),
						(itemOrigPremAmts[a] == null || itemOrigPremAmts[a] == "" ? null : new BigDecimal(itemOrigPremAmts[a].replaceAll(",", ""))),
						itemSequenceNos[a],itemRemarks[a],
						(itemNetPremAmts[a] == null || itemNetPremAmts[a] == "" ? null : new BigDecimal(itemNetPremAmts[a].replaceAll(",", ""))),
						(itemSurchargeRts[a] == null || itemSurchargeRts[a] == "" ? null : new BigDecimal(itemSurchargeRts[a].replaceAll(",", ""))),
						(itemSurchargeAmts[a] == null || itemSurchargeAmts[a] == "" ? null : new BigDecimal(itemSurchargeAmts[a].replaceAll(",", "")))
						));
			}
		}
		return witemDisc;
	}

	public List<GIPIWPolbasDiscount> prepareBasicDisc(HttpServletRequest request,
			Integer parId, String lineCd, String sublineCd){
		List<GIPIWPolbasDiscount> wpolbasDisc = new ArrayList<GIPIWPolbasDiscount>();
		
		String[] sequenceNos = request.getParameterValues("sequenceNos");
		String origPremAmts = request.getParameter("paramOrigPremAmt");
		String[] netPremAmts = request.getParameterValues("origPremAmts");
		String[] discountAmts = request.getParameterValues("discountAmts");
		String[] discountRts = request.getParameterValues("discountRts");
		String[] surchargeAmts = request.getParameterValues("surchargeAmts");
		String[] surchargeRts = request.getParameterValues("surchargeRts");
		String[] netGrossTags = request.getParameterValues("netGrossTags");
		String[] remarks = request.getParameterValues("remarks");
		
		if (request.getParameterValues("sequenceNos") != null) {
			for (int i=0; i < sequenceNos.length; i++)	{
				wpolbasDisc.add(new GIPIWPolbasDiscount(parId,lineCd,sublineCd,
						(discountRts[i] == null || discountRts[i] == "" ? null : new BigDecimal(discountRts[i].replaceAll(",", ""))),
						(discountAmts[i] == null || discountAmts[i] == "" ? null : new BigDecimal(discountAmts[i].replaceAll(",", ""))),
						(netGrossTags[i] == null || netGrossTags[i] == "" ? "N" : netGrossTags[i]),
						(origPremAmts == null || origPremAmts == "" ? null : new BigDecimal(origPremAmts.replaceAll(",", ""))),
						 sequenceNos[i],remarks[i],
						(netPremAmts[i] == null || netPremAmts[i] == "" ? null : new BigDecimal(netPremAmts[i].replaceAll(",", ""))),
						(surchargeRts[i] == null || surchargeRts[i] == "" ? null : new BigDecimal(surchargeRts[i].replaceAll(",", ""))),
						(surchargeAmts[i] == null || surchargeAmts[i] == "" ? null : new BigDecimal(surchargeAmts[i].replaceAll(",", "")))
						));
			}
		}
		return wpolbasDisc;
	}

	public HashMap<String, Object> prepareAll(HttpServletRequest request, Integer parId, String lineCd, String sublineCd){
		String issCd = request.getParameter("issCd");
		
		List<GIPIWPolbasDiscount> wpolbasDisc = new ArrayList<GIPIWPolbasDiscount>();
		List<GIPIWItemDiscount> witemDisc = new ArrayList<GIPIWItemDiscount>();
		List<GIPIWPerilDiscount> wperilDisc = new ArrayList<GIPIWPerilDiscount>();
		
		wpolbasDisc = prepareBasicDisc(request, parId, lineCd, sublineCd);
		witemDisc = prepareItemDisc(request, parId, lineCd, sublineCd);
		wperilDisc = preparePerilDisc(request, parId, lineCd, sublineCd);
		
		HashMap<String, Object> mainParams = new HashMap<String, Object>();
		mainParams.put("wpolbasDisc", wpolbasDisc);
		mainParams.put("witemDisc", witemDisc);
		mainParams.put("wperilDisc", wperilDisc);
		mainParams.put("parId", parId);
		mainParams.put("lineCd", lineCd);
		mainParams.put("issCd", issCd);
		return mainParams;	
	}
	
}