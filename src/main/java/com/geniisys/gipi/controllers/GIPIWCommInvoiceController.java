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

import org.json.JSONObject;

import com.geniisys.common.entity.GIISBancType;
import com.geniisys.common.entity.GIISBancTypeDtl;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gipi.entity.GIPIWCommInvoice;
import com.geniisys.gipi.entity.GIPIWCommInvoicePeril;
import com.geniisys.gipi.entity.GIPIWInvoice;
import com.geniisys.gipi.service.GIPIWCommInvoiceService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWCommInvoiceController.
 */
public class GIPIWCommInvoiceController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 6154441583761917258L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWCommInvoiceController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWCommInvoiceService commInvoiceService = null;
			
			List<Map<String, Object>> b240List = null;
			List<GIPIWCommInvoice> wcommInvoices = null;
			List<GIPIWInvoice> winvoices = null;
			List<GIPIWCommInvoicePeril> wcommInvoicePerils = null;
			List<Map<String, Object>> packParlistParams = null;
			//
			int parId 		= Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			int itemGroup 	= Integer.parseInt(request.getParameter("inputItemGroup") == null ? "0" : request.getParameter("inputItemGroup"));
			int assdNo		= Integer.parseInt((request.getParameter("globalAssdNo") == null) ? "0" : request.getParameter("globalAssdNo"));
			String parNo	= (request.getParameter("globalParNo") == null ? "" : request.getParameter("globalParNo"));
			
			String lineCd = request.getParameter("globalLineCd");
			String issCd = request.getParameter("globalIssCd");
			String globalCancelTag = "N"; // temporary value (emman 12.21.2010)
			//String parType = request.getParameter("parType");
			String intmTypeNbt = null;
			String recordStatus = "NEW";
			String isPack = (request.getParameter("isPack") == null) ? "N" : (request.getParameter("isPack").toString().isEmpty() ? "N" : request.getParameter("isPack"));
			
			if ("showCommInvoicePage".equals(ACTION)) {
				// this will be for testing for the JSONification of this page
				// services
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				
				//parameters
				if (parId == 0) {
					parId 	 = Integer.parseInt((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				}
				
				log.info("Par ID: " + parId);
				
				parNo 	 = (request.getParameter("parNo") == null) ? "" : request.getParameter("parNo");
				assdNo 	 = Integer.parseInt((request.getParameter("assdNo") == null) ? "0" : (request.getParameter("assdNo").isEmpty() ? "0" : request.getParameter("assdNo")));
				lineCd 	 = (request.getParameter("lineCd") == null) ? "0" : request.getParameter("lineCd");
				issCd 	 = (request.getParameter("issCd") == null) ? "0" : request.getParameter("issCd");
				
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("userId", USER.getUserId());
				params.put("parId", parId);
				params.put("globalCancelTag", globalCancelTag);
				params.put("isPack", isPack);
				
				commInvoiceService.executeGipis085WhenNewFormInstance(params);
				
				// objects/listings
				b240List = (List<Map<String, Object>>) params.get("parlist");
				wcommInvoices = (List<GIPIWCommInvoice>) params.get("wcommInvoices");
				StringFormatter.replaceQuotesInList(wcommInvoices);
				winvoices = (List<GIPIWInvoice>) params.get("winvoice");
				//StringFormatter.replaceQuotesInList(winvoices); kenneth 10.22.2014
				StringFormatter.escapeHTMLInList4(winvoices);
				wcommInvoicePerils = (List<GIPIWCommInvoicePeril>) params.get("wcommInvPerils");
				StringFormatter.replaceQuotesInList(wcommInvoicePerils);
				List<Map<String, Object>> itemGrpList = (ArrayList<Map<String, Object>>) params.get("itemGrpList");
				
				// for enhancements
				
				GIISBancType giisBancType = null;
				List<GIISBancTypeDtl> giisBancTypeDtlList = null;
				
				for (GIISBancType bancType : (List<GIISBancType>) params.get("giisBancType")) {
					giisBancType = bancType;
				}
				
				giisBancTypeDtlList = (List<GIISBancTypeDtl>) params.get("giisBancTypeDtlList");
								
				// execute the GET_DEFAULT_ASSURED_INTM codes here
				String parType = (params.get("vParType") == null) ? "" : params.get("vParType").toString();
				//String assdName = StringFormatter.replaceQuotes((String) b240Param.get("dspAssdName"));
				//b240Param.put("dspAssdName", assdName);
				
				// if package, load basic params for each par
				if ("Y".equals(isPack)) {
					packParlistParams = commInvoiceService.getPackParlistParams(parId);
				}
				
				// set page attributes
				request.setAttribute("parNo", parNo);
				request.setAttribute("assdNo", assdNo);
				//request.setAttribute("assdName", assdName);
				request.setAttribute("b240", new JSONArray((List<Map<String, Object>>) StringFormatter.replaceQuotesInList(b240List)));
				if ("Y".equals(isPack)) {
					request.setAttribute("packParlistParams", new JSONArray((List<Map<String, Object>>) StringFormatter.replaceQuotesInList(packParlistParams)));
				}
				request.setAttribute("wcommInvoices", new JSONArray(wcommInvoices));
				System.out.println("wcominvoicessssssssssssss: " +wcommInvoices.toString());
				request.setAttribute("winvoices", new JSONArray(winvoices));
				request.setAttribute("itemGrpList", itemGrpList);
				request.setAttribute("wcommInvoicePerils", new JSONArray(wcommInvoicePerils));
				request.setAttribute("globalCancelTag", params.get("globalCancelTag"));
				request.setAttribute("isBancassuranceRec", params.get("isBancassuranceRec"));
				request.setAttribute("isCancellationType", params.get("isCancellationType"));
				request.setAttribute("isBancaBtnEnabled", params.get("isBancaBtnEnabled"));
				request.setAttribute("isBancaCheckEnabled", params.get("isBancaCheckEnabled"));
				request.setAttribute("varBancRateSw", params.get("varBancRateSw"));
				request.setAttribute("varOverrideWhtax", params.get("varOverrideWhtax"));
				request.setAttribute("varParamReqDefIntm", params.get("varParamReqDefIntm"));
				request.setAttribute("varVCommUpdateTag", params.get("varVCommUpdateTag"));
				request.setAttribute("varVParamShowComm", params.get("varVParamShowComm"));
				request.setAttribute("varEndtYy", params.get("varEndtYy"));
				request.setAttribute("vOra2010Sw", params.get("vOra2010Sw"));
				request.setAttribute("vValidateBanca", params.get("vValidateBanca"));
				request.setAttribute("vAllowApplySlComm", params.get("vAllowApplySlComm"));
				request.setAttribute("vParType", parType);
				request.setAttribute("vEndtTax", params.get("vEndtTax"));
				request.setAttribute("vPolFlag", params.get("vPolFlag"));
				request.setAttribute("vLovTag", params.get("vLovTag"));
				request.setAttribute("vWcominvIntmLov", params.get("vWcominvIntmLov"));
				request.setAttribute("coinsurerSw", params.get("coinsurerSw"));
				
				request.setAttribute("vGipiWpolnrepExist", params.get("vGipiWpolnrepExist"));
				request.setAttribute("banca", giisBancType);
				request.setAttribute("bancaB", new JSONArray(giisBancTypeDtlList));
				System.out.println("params.get(dfltIntmNo)::: "+params.get("dfltIntmNo"));
				request.setAttribute("dfltIntmNo", params.get("dfltIntmNo"));
				request.setAttribute("dfltIntmName", StringFormatter.replaceQuotesInObject(params.get("dfltIntmName")));
				request.setAttribute("dfltParentIntmNo", params.get("dfltParentIntmNo"));
				request.setAttribute("dfltParentIntmName", StringFormatter.replaceQuotesInObject(params.get("dfltParentIntmName")));
				
				/* benjo 09.07.2016 SR-5604 */
				request.setAttribute("maintainedDfltIntmNo", params.get("maintainedDfltIntmNo"));
				request.setAttribute("reqDfltIntmPerAssd", params.get("reqDfltIntmPerAssd"));
				request.setAttribute("allowUpdIntmPerAssd", params.get("allowUpdIntmPerAssd"));
				request.setAttribute("userId", USER.getUserId());
				/* end SR-5604 */
				
				//checking if package - "Y" for true and "N" for false (emman 06.28.2011)
				request.setAttribute("isPack", isPack);
				request.setAttribute("userCommUpdateTag", USER.getCommUpdateTag());
				
				//retrieving of default intermediaries for endorsement/renewal - apollo cruz
				if(parType.equals("E") || params.get("vPolFlag").equals("2")){
					Map<String, Object> p = new HashMap<String, Object>();
					p.put("parType", parType);
					p.put("polFlag", params.get("vPolFlag"));
					p.put("parId", parId);
					p.put("assdNo", assdNo);
					p.put("lineCd", lineCd);
					
					request.setAttribute("dfltIntms", new JSONArray(commInvoiceService.getCommInvDfltIntms(p)));
				}
				
				PAGE = "/pages/underwriting/invoiceCommission.jsp";				
			} else if ("saveWcommInvoice".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				
				commInvoiceService.saveGipiWcommInvoice(request.getParameter("strParameters"));
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveIntmInfo".equals(ACTION)){
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				
				log.info("Emman - Save Intm Info");
				message = "SUCCESS";
				PAGE = "/pages/underwriting/subPages/ajaxUpdateIntmInfo.jsp";
				
				//intm no, takeup seq no, and item grp
				int intmNo = Integer.parseInt(request.getParameter("inputIntermediaryNo") == null ? "0" : request.getParameter("inputIntermediaryNo"));
				int takeupSeqNo = Integer.parseInt(request.getParameter("inputTakeupSeqNo") == null ? "0" : request.getParameter("inputTakeupSeqNo"));				
				
				BigDecimal sharePercentage = new BigDecimal(request.getParameter("inputPercentage") == null ? "0" : request.getParameter("inputPercentage").replaceAll(",", ""));
				BigDecimal prevSharePercentage = new BigDecimal(request.getParameter("prevSharePercentage") == null ? "0" : request.getParameter("prevSharePercentage").replaceAll(",", ""));
				BigDecimal commissionAmt = new BigDecimal(request.getParameter("inputTotalCommission") == null ? "0" : request.getParameter("inputTotalCommission").replaceAll(",", ""));
				BigDecimal premiumAmt = new BigDecimal(request.getParameter("inputPremium") == null ? "0" : request.getParameter("inputPremium").replaceAll(",", ""));
				BigDecimal varTaxAmt = new BigDecimal(0);
				//Add the following on jsp - emman 03.31.10
				String perilCd = "1";//request.getParameter("paramPerilCd");
				BigDecimal commissionRate = new BigDecimal(0);//new BigDecimal(request.getParameter("paramCommissionRate") == null ? "0" : request.getParameter("paramCommissionRate").replaceAll(",", ""));				
				BigDecimal wholdingTax = new BigDecimal(request.getParameter("wholdingTax") == null ? "0" : request.getParameter("wholdingTax").replaceAll(",", ""));
				String nbtRetOrig = (request.getParameter("origPolCommRts") == null) ? "" : request.getParameter("origPolCommRts"); 
				
				log.info("Emman test...");
				log.info("Intm No: " + intmNo);
				log.info("Takeup Seq No: " + takeupSeqNo);
				log.info("Share Percentage: " + sharePercentage);
				log.info("Prev Share Percentage: " + prevSharePercentage);
				log.info("Line CD: " + lineCd);
				log.info("ISS Cd: " + issCd);
				log.info("Intm Type: " + intmTypeNbt);
				log.info("Record Status: " + recordStatus);
				log.info("Nbt Ret Orig: " + nbtRetOrig);
				log.info("Peril Cd:" + perilCd);								
				
				Map<String, Object> params = commInvoiceService.getApplyBtnMap(parId, itemGroup, intmNo, intmNo, takeupSeqNo, sharePercentage, 
						sharePercentage, prevSharePercentage, lineCd, issCd, intmTypeNbt, recordStatus, perilCd, commissionAmt, commissionAmt, premiumAmt, commissionRate, wholdingTax);
				
				log.info("Apply Btn Enabled: " + params.get("applyBtnEnabled"));
				log.info("Commission Rate Enabled: " + params.get("commissionRateEnabled"));
				log.info("Commission Amt Enabled: " + params.get("commissionAmtEnabled"));
				log.info("Message: " + params.get("varMessage"));
				log.info("Tax Amt: " + params.get("varTaxAmt"));
				log.info("Share Percentage: " + params.get("varSharePercentage"));
				log.info("Function: " + params.get("varFunction"));
				log.info("Switch No: " + params.get("varSwitchNo"));
				log.info("Switch Name: " + params.get("varSwitchName"));
				log.info("Switch Name: " + params.get("varMessage"));
				
				varTaxAmt =  new BigDecimal(params.get("varTaxAmt").toString());
				
				/*
				 * Populate Wcomm Inv Perils and Compute Total Comm
				 */
				
				String[] perilCode = request.getParameterValues("perilPerilCd");
				String[] perilPremiumAmt = request.getParameterValues("perilPremiumAmount");
				String[] perilCommissionRate = request.getParameterValues("perilCommissionRate");
				String[] perilCommissionAmt = request.getParameterValues("perilCommissionAmount");
				String[] perilWholdingTax = request.getParameterValues("perilWithholdingTax");
				String[] perilNetCommission = request.getParameterValues("perilNetCommission");
				String[] itemGrp = request.getParameterValues("perilItemGroup");
				String[] perilTakeupSeqNo = request.getParameterValues("perilTakeupSeqNo");
				String[] varRate = null;
				
				//double check param values if they are not null but has no value
				if (perilCode != null) {
					if (perilCode.length > 0) {
						varRate = new String[perilCode.length];
					}
					
					for (int i = 0; i < perilCode.length; i++) {
						if (itemGrp[i].equals(Integer.toString(itemGroup)) && perilTakeupSeqNo[i].equals(Integer.toString(takeupSeqNo))) {
							if (nbtRetOrig.equals("Y") || nbtRetOrig.equals("N")) {
								varRate[i] = (request.getParameter("invVarRate" + perilCode[i] + itemGrp[i] + perilTakeupSeqNo[i]) == null) ? "0" : request.getParameter("invVarRate" + perilCode[i] + itemGrp[i] + perilTakeupSeqNo[i]).toString();
							} else {
								varRate[i] = (request.getParameter("localVarRate" + itemGrp[i] + perilTakeupSeqNo[i]) == null) ? "0" : request.getParameter("localVarRate" + itemGrp[i] + perilTakeupSeqNo[i]).toString();
							}
							
							log.info("Populating Wcomm Inv Perils " + i + "..");
							log.info("Par ID - " + parId);
							log.info("Item Group - " + itemGroup);
							log.info("Takeup Seq No - " + takeupSeqNo);
							log.info("Line Code - " + lineCd);
							log.info("Intm No - " + intmNo);
							log.info("Intm Type NBT - " + intmTypeNbt);
							log.info("NBT Ret Orig - " + nbtRetOrig);
							log.info("Peril Code - " + perilCode[i]);
							log.info("Share Percentage - " + sharePercentage);
							log.info("Prev Share Percentage - " + prevSharePercentage);
							log.info("Peril Prem Amt - " + perilPremiumAmt[i]);
							log.info("Peril Comm Rate - " + perilCommissionRate[i]);
							log.info("Peril Comm Amt - " + perilCommissionAmt[i]);
							log.info("Peril Net Commission - " + perilNetCommission[i]);
							log.info("Peril Withholding Tax - " + perilWholdingTax[i]);
							log.info("Iss Code - " + issCd);
							log.info("Var Rate - " + varRate[i]);
							
							//temporarily removes (emman 01.20.2011)
							//params = commInvoiceService.populateWcommInvPerils(parId, itemGroup, takeupSeqNo, lineCd, intmNo, intmTypeNbt, nbtRetOrig, perilCode[i], perilCode[i], sharePercentage, prevSharePercentage, new BigDecimal(perilPremiumAmt[i]), new BigDecimal(perilCommissionRate[i]), new BigDecimal(perilCommissionAmt[i]), new BigDecimal(perilNetCommission[i]), new BigDecimal(perilWholdingTax[i]), issCd, new BigDecimal(varRate[i]));
							
							log.info("Populate Wcomm Inv Perils - Result");
							log.info("Peril Cd: " + perilCode[i]);
							log.info("Item Group: " + itemGrp[i]);
							log.info("Takeup Seq No: " + perilTakeupSeqNo[i]);
							log.info("Nbt Peril Cd: " + params.get("nbtPerilCd"));
							log.info("Share Percentage: " + params.get("sharePercentage"));
							log.info("Prev Share Percentage: " + params.get("prevSharePercentage"));
							log.info("Premium Amt: " + params.get("premiumAmt"));
							log.info("Comm Rate: " + params.get("commissionRate"));
							log.info("Comm Amt: " + params.get("commissionAmt"));
							log.info("Nbt Commission Amt: " + params.get("nbtCommissionAmt"));
							log.info("Withholding Tax: " + params.get("wholdingTax"));
							log.info("Message: " + params.get("varMessage"));
							log.info("Var Rate of " + perilCode[i] + " : " + varRate[i]);
							
							perilPremiumAmt[i] = (params.get("premiumAmt") == null) ? "0" : params.get("premiumAmt").toString();
							perilCommissionRate[i] = (params.get("commissionRate") == null) ? "0" : params.get("commissionRate").toString();
							perilCommissionAmt[i] = "0";
							perilWholdingTax[i] = "0";
							perilNetCommission[i] = "0";
							varRate[i] = (params.get("varRate") == null) ? "0" : params.get("varRate").toString();
						}
					}
				}
				
				request.setAttribute("varTaxAmt", varTaxAmt);
				request.setAttribute("pSharePremium", params.get("premiumAmt"));
				request.setAttribute("pPerilCode", perilCode);
				request.setAttribute("pPremiumAmt", perilPremiumAmt);
				request.setAttribute("pCommissionRate", perilCommissionRate);
				request.setAttribute("pCommissionAmt", perilCommissionAmt);
				request.setAttribute("pWholdingTax", perilWholdingTax);
				request.setAttribute("pNetCommission", perilNetCommission);
				request.setAttribute("varRate", varRate);
				request.setAttribute("message", message);
				request.setAttribute("param", params);			
			} else if ("validateIntmNo".equals(ACTION)){
				PAGE = "/pages/genericMessage.jsp";
				int intmNo = Integer.parseInt(request.getParameter("inputIntermediaryNo"));
				String lovTag = request.getParameter("lovTag");
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				
				Map<String, Object> params = commInvoiceService.validateIntmNo(parId, intmNo, lineCd, lovTag, globalCancelTag);
				
				message = params.get("message").toString();
			} else if ("validateGipis085IntmNo".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				commInvoiceService.validateGipis085IntmNo(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("executeBancassuranceGetDefaultTaxRt".equals(ACTION)) {			
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				System.out.println("BANCASSURANCE.get_default_tax_rt");
				System.out.println("parId: " + params.get("parId"));
				System.out.println("parType: " + params.get("parType"));
				System.out.println("wcominvParId: " + params.get("wcomInvParId"));
				System.out.println("intrmdryIntmNo: " + params.get("intrmdryIntmNo"));
				System.out.println("intrmdryIntmNoNbt: " + params.get("intrmdryIntmNoNbt"));
				System.out.println("sharePercentage: " + params.get("sharePercentage"));
				System.out.println("sharePercentageNbt: " + params.get("sharePercentageNbt"));
				System.out.println("takeupSeqNo: " + params.get("takeupSeqNo"));
				System.out.println("systemRecordStatus: " + params.get("systemRecordStatus"));
				System.out.println("itemGrp: " + params.get("itemGrp"));
				System.out.println("globalCancelTag: " + params.get("globalCancelTag"));
				System.out.println("perilCommissionAmount: " + params.get("perilCommissionAmount"));
				
				commInvoiceService.executeBancassuranceGetDefaultTaxRt(params);
				System.out.println(params);
				message = QueryParamGenerator.generateQueryParams(params);
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("executeBancassuranceProcessCommission".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				commInvoiceService.executeBancassuranceProcessCommission(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkPerilCommRate".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				message = commInvoiceService.checkPerilCommRate(params);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("populateWcommInvPerils".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				commInvoiceService.populateWcommInvPerils(params);
				message = QueryParamGenerator.generateQueryParams(params);
				System.out.println("populateWcommInvPerils::: "+params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("populateWcommInvPerils2".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				List<Map<String, Object>> winvperlList = null;
				
				commInvoiceService.populateWcommInvPerils2(params);
				
				// set the GIPI_WINVPERL cursor to JSONArray
				winvperlList = (List<Map<String, Object>>)params.get("gipiWinvperlList");
				request.setAttribute("object", new JSONArray(winvperlList));
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("getIntmdryRate".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				String intmdryRate = null;
				System.out.println("getIntmdryRate::: "+params);
				commInvoiceService.getIntmdryRate(params);
				intmdryRate = (String) params.get("varRate");
				
				if (intmdryRate == null) {
					intmdryRate = new String("0");
				}
				
				message = intmdryRate;
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getAdjustIntmdryRate".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				BigDecimal intmdryRate = null;
				
				intmdryRate = commInvoiceService.getAdjustIntmdryRate(params);
				
				if (intmdryRate == null) {
					intmdryRate = new BigDecimal("0");
				}
				
				message = intmdryRate.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("populatePackagePerils".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				List<Map<String, Object>> witmperlList = null;
				
				commInvoiceService.populatePackagePerils(params);
				
				// set the GIPI_WINVPERL cursor to JSONArray
				witmperlList = (List<Map<String, Object>>)params.get("packWitmperlList");
				System.out.println("pack witmperlList size: " + witmperlList.size());
				for(Map<String, Object> a: witmperlList) {
					System.out.println("winvperlList content: "+a);
				}
				
				request.setAttribute("object", new JSONArray(witmperlList));
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("getPackageIntmRate".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				BigDecimal intmdryRate = null;
				
				intmdryRate = commInvoiceService.getPackageIntmRate(params);
				
				if (intmdryRate == null) {
					intmdryRate = new BigDecimal("0");
				}
				
				message = intmdryRate.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showWtRateRecordGroupListing".equals(ACTION)) {
				HashMap<String, Object> params = new HashMap<String, Object>();
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				//params.put("filter", request.getParameter("objFilter"));
				params.put("parameters", request.getParameter("parameters"));
				params = commInvoiceService.prepareWtRateRecordGroupMap(params);
				request.setAttribute("wtRateTableGrid", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("refreshAction", "refreshSetupGroupDistributionForPerilDist");
				PAGE = "/pages/underwriting/pop-ups/wtRateListing.jsp";
			} else if ("showEndtBondCommInvoicePage".equals(ACTION)) {
				// this will be for testing for the JSONification of this page
				// services
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				//parameters
				if (parId == 0) {
					parId 	 = Integer.parseInt((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				}
				
				log.info("Par ID: " + parId);
				
				Map<String, Object> params = new HashMap<String, Object>();
				Map<String, Object> b240 = null;
				Map<String, Object> wcominvTableGridParams = new HashMap<String, Object>();
				
				params.put("parId", parId);
				params.put("globalCancelTag", globalCancelTag);
				
				commInvoiceService.executeGIPIS160WhenNewFormInstance(params);
				
				// objects/listings
				GIISBancType giisBancType = null;
				List<GIISBancTypeDtl> giisBancTypeDtlList = null;
				
				for (Map<String, Object> par : (List<Map<String, Object>>) params.get("parlist")) {
					b240 = (Map<String, Object>) StringFormatter.replaceQuotesInMap(par);
				}
				
				winvoices = (List<GIPIWInvoice>) StringFormatter.replaceQuotesInList((List<GIPIWInvoice>) params.get("winvoice"));
				wcommInvoicePerils = (List<GIPIWCommInvoicePeril>) StringFormatter.replaceQuotesInList((List<GIPIWCommInvoicePeril>) params.get("wcommInvPerils"));
				
				for (GIISBancType bancType : (List<GIISBancType>) params.get("giisBancType")) {
					giisBancType = bancType;
				}
				
				giisBancTypeDtlList = (List<GIISBancTypeDtl>) params.get("giisBancTypeDtlList");
				
				wcominvTableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				wcominvTableGridParams.put("parId", parId);
				wcominvTableGridParams = commInvoiceService.getWCommInvoiceTableGridMap(wcominvTableGridParams);
				
				request.setAttribute("vWcominvIntmLov", params.get("vWcominvIntmLov"));
				request.setAttribute("vLovTag", params.get("vLovTag"));
				request.setAttribute("vPolFlag", params.get("vPolFlag"));
				request.setAttribute("dfltIntmNo", params.get("dfltIntmNo"));
				request.setAttribute("dfltIntmName", params.get("dfltIntmName"));
				request.setAttribute("dfltParentIntmNo", params.get("dfltParentIntmNo"));
				request.setAttribute("dfltParentIntmName", params.get("dfltParentIntmName"));
				request.setAttribute("varParamReqDefIntm", params.get("varParamReqDefIntm"));
				request.setAttribute("vAllowApplySlComm", params.get("vAllowApplySlComm"));
				request.setAttribute("globalCancelTag", globalCancelTag);
				request.setAttribute("winvoices", new JSONArray(winvoices));
				request.setAttribute("wcommInvoicePerils", new JSONArray(wcommInvoicePerils));
				request.setAttribute("parlist", new JSONObject(b240).toString());
				//request.setAttribute("wcominvListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(wcominvTableGridParams)));
				request.setAttribute("wcominvListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(wcominvTableGridParams))); //belle 08.01.2012
				request.setAttribute("banca", giisBancType);
				request.setAttribute("bancaB", new JSONArray(giisBancTypeDtlList));
				request.setAttribute("varBancRateSw", params.get("varBancRateSw"));
				request.setAttribute("vGipiWpolnrepExist", params.get("vGipiWpolnrepExist"));
				request.setAttribute("varUserCommUpdateTag", USER.getCommUpdateTag());
				request.setAttribute("varVParamShowComm", giacParamService.getParamValueV2("SHOW_COMM_AMT"));
				// other variables
				request.setAttribute("varOverrideWhtax", params.get("varOverrideWhtax"));
				request.setAttribute("vOra2010Sw", params.get("vOra2010Sw"));
				request.setAttribute("vValidateBanca", params.get("vValidateBanca"));
				request.setAttribute("wComInvIntmNo", params.get("wComInvIntmNo")); //belle 06.04.12
				
				/* benjo 09.07.2016 SR-5604 */
                request.setAttribute("maintainedDfltIntmNo", params.get("maintainedDfltIntmNo"));
                request.setAttribute("reqDfltIntmPerAssd", params.get("reqDfltIntmPerAssd"));
                request.setAttribute("allowUpdIntmPerAssd", params.get("allowUpdIntmPerAssd"));
                request.setAttribute("userId", USER.getUserId());
                /* end SR-5604 */
								
				//retrieving of default intermediaries for endorsement/renewal - apollo cruz
				if(b240.get("parType").equals("E") || params.get("vPolFlag").equals("2")){
					Map<String, Object> p = new HashMap<String, Object>();
					p.put("parType", b240.get("parType"));
					p.put("polFlag", params.get("vPolFlag"));
					p.put("parId", parId);
					p.put("assdNo", b240.get("assdNo"));
					p.put("lineCd", b240.get("lineCd"));
					System.out.println("params p : " + p);
					request.setAttribute("dfltIntms", new JSONArray(commInvoiceService.getCommInvDfltIntms(p)));
				}
				
				PAGE = "/pages/underwriting/bondInvoiceCommission.jsp";				
			} else if ("refreshWcominvListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				Integer itemGrp = request.getParameter("itemGrp") == null ? 0 : (request.getParameter("itemGrp").isEmpty() ? 0 : new Integer(request.getParameter("itemGrp")));
				Integer takeupSeqNo = request.getParameter("takeupSeqNo") == null ? 0 : (request.getParameter("takeupSeqNo").isEmpty() ? 0 : new Integer(request.getParameter("takeupSeqNo")));
				parId = request.getParameter("parId") == null ? 0 : (request.getParameter("parId").isEmpty() ? 0 : new Integer(request.getParameter("parId")));
				
				System.out.println("Emman : " + request.getParameter("takeupSeqNo"));
				
				// services
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				
				params.put("currentPage", (currentPage == 0) ? 1 : currentPage);
				params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
				params.put("parId", parId);
				params.put("itemGrp", itemGrp);
				params.put("takeupSeqNo", takeupSeqNo);
				
				params = commInvoiceService.getWCommInvoiceTableGridMap(params);
				
				JSONObject json = new JSONObject(params);
				//Debug.print(json);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if ("applySlidingCommission".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				Map<String, Object>params = FormInputUtil.getFormInputs(request);
				commInvoiceService.applySlidingCommission(params);
				message = QueryParamGenerator.generateQueryParams(params);
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getPackParlistParams".equals(ACTION)) {
				commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				parId 	 = Integer.parseInt((request.getParameter("parId") == null) ? "0" : (request.getParameter("parId").isEmpty() ? "0" : request.getParameter("parId")));
				packParlistParams = commInvoiceService.getPackParlistParams(parId);
				System.out.println("getPackParlistParams: " + packParlistParams.size());
				request.setAttribute("object", new JSONArray((List<Map<String, Object>>) StringFormatter.replaceQuotesInList(packParlistParams)));
				PAGE = "/pages/genericObject.jsp";
			}
		} catch (SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}

	}
}
