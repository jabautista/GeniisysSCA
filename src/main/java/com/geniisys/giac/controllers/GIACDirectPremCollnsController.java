package com.geniisys.giac.controllers;

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
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACDirectPremCollns;
import com.geniisys.giac.entity.GIACParameter;
import com.geniisys.giac.entity.GIACPdcPremColln;
import com.geniisys.giac.entity.GIACTaxCollns;
import com.geniisys.giac.service.GIACAccTransService;
import com.geniisys.giac.service.GIACAgingSoaDetailService;
import com.geniisys.giac.service.GIACDirectPremCollnsService;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giac.service.GIACOrderOfPaymentService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACPdcPremCollnService;
import com.geniisys.giac.service.GIACTaxCollnsService;
import com.geniisys.giac.service.GIACUserFunctionsService;
import com.geniisys.gipi.service.GIPIInstallmentService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACDirectPremCollnsController extends BaseController{

	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACDirectPremCollnsController.class);

	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACDirectPremCollnsService giacDirectPremCollnsService = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");
			
			/*end of default attributes*/
			if ("loadDirectPremForm".equals(ACTION)) {
			//if ("showDirectPremiumColln".equals(ACTION)){
				GIACDirectPremCollnsService directPremCollns = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");
				GIACParameterFacadeService giacParamService  = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				GIACTaxCollnsService giacTaxCollnsService = (GIACTaxCollnsService) APPLICATION_CONTEXT.getBean("giacTaxCollnsService"); //added by alfie 12.08.2010
				GIACAccTransService giacAccTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				
				List<LOV> currencyDetails = helper.getList(LOVHelper.CURRENCY_CODES);
				StringFormatter.replaceQuotesInList(currencyDetails);
				request.setAttribute("currencyDetails", new JSONArray(currencyDetails));
				
				List<LOV> defaultCurrency = helper.getList(LOVHelper.DEFAULT_CURRENCY);
				request.setAttribute("defaultCurrency", defaultCurrency.get(0));
				
				String[] argsTransType = {"GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE"};
				request.setAttribute("transactionTypeList", helper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, argsTransType));
				
				String[] argsIssCd = {"GIACS007", USER.getUserId()};
				request.setAttribute("issueSourceList", helper.getList(LOVHelper.ACCTG_ISSUE_CD_LISTING, argsIssCd));
				
				GIACParameter tAlloc = giacParamService.getParamValueV("TAX_ALLOCATION");
				request.setAttribute("taxAllocation", tAlloc.getParamValueV());
				
				GIACParameter tPriority = giacParamService.getParamValueV("PREM_TAX_PRIORITY");
				request.setAttribute("taxPriority", tPriority.getParamValueV());
				//added by d.alcantara, 12/13/2012
				GIACParameter enterAdvPayt = giacParamService.getParamValueV("ENTER_ADVANCED_PAYT");
				request.setAttribute("enterAdvPayt", enterAdvPayt.getParamValueV());
				
				GIACParameter chkPremAging = giacParamService.getParamValueV("CHECK_PREMIUM_AGING");
				request.setAttribute("chkPremAging", chkPremAging.getParamValueV());
				
				Integer chkBillPremOverdue = giacParamService.getParamValueN("BILL_PREMIUM_OVERDUE");
				request.setAttribute("chkBillPremOverdue", chkBillPremOverdue);
				
				request.setAttribute("allowCancelledPol", giacParamService.getParamValueV2("ALLOW_PAYT_OF_CANCELLED_POL"));
				
				request.setAttribute("giacs007But", giacParamService.getParamValueV2("GIACS007_BUT"));
				
				List<Map<String, Object>> giacDirectPremCollnsDtls = directPremCollns.getDirectPremCollnsDtls(Integer.parseInt(request.getParameter("gaccTranId"))); //alfie
				for(Map<String, Object> gdcp: giacDirectPremCollnsDtls) {
					gdcp.put("isSaved", "Y");
				}
				//StringFormatter.replaceQuotesInListOfMap(giacDirectPremCollnsDtls);
				JSONArray jsonDirectPremiumCollnListing =  new JSONArray((List<Map<String, Object>>) StringFormatter.escapeHTMLInListOfMap(giacDirectPremCollnsDtls));
				request.setAttribute("giacDirectPremCollnsDtls", jsonDirectPremiumCollnListing);
				
				List<GIACTaxCollns> giacTaxCollnsListing = giacTaxCollnsService.getTaxCollnsListing(Integer.parseInt(request.getParameter("gaccTranId")));
				JSONArray jsonTaxCollnsListing = new JSONArray(giacTaxCollnsListing);
				request.setAttribute("giacTaxCollectionsListing", jsonTaxCollnsListing);
				
				String tranFlag = giacAccTransService.getTranFlag(Integer.parseInt(request.getParameter("gaccTranId")));
				request.setAttribute("tranFlag", tranFlag);
				
				//System.out.println("tranType: " + giacDirectPremCollnsDtls.get(0).get("assdName"));
				System.out.println("GaccTranId param: " + request.getParameter("gaccTranId"));
				System.out.println("Tax Allocation: " + tAlloc.getParamValueV());
				System.out.println("Tax Priority: " + tPriority.getParamValueV());
				System.out.println("Check Prem Aging: " + chkPremAging.getParamValueV());
				System.out.println("Check Bill Due Date: " + chkBillPremOverdue);
				
				PAGE = "/pages/accounting/officialReceipt/subPages/directPremiumCollection.jsp";
			} else if ("validateBillNo".equals(ACTION)){
				GIACDirectPremCollnsService directPremCollns = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				StringBuilder sb = new StringBuilder();
				Map<String, Object> params = new HashMap<String, Object>();
				
				String[] argsTransType = {request.getParameter("issCd"), request.getParameter("premSeqNo")};
				List<LOV> currCd = helper.getList(LOVHelper.CURRENCY_BY_PREMSEQNO, argsTransType);
				
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("tranType", request.getParameter("tranType"));
				
				Map<String, Object> dtlsBillNo = directPremCollns.validateBillNo(params);
				
				if (dtlsBillNo.get("msgAlert").toString().equals("Ok")){
					sb.append("policyNo=" + dtlsBillNo.get("policyNo").toString());
					sb.append("&policyId=" + dtlsBillNo.get("policyId").toString());
					sb.append("&lineCd=" + dtlsBillNo.get("lineCd").toString());
					sb.append("&sublineCd=" + dtlsBillNo.get("sublineCd").toString());
					sb.append("&issCd=" + dtlsBillNo.get("issCd").toString());
					sb.append("&issueYear=" + dtlsBillNo.get("issueYear").toString());
					sb.append("&polSeqNo=" + dtlsBillNo.get("polSeqNo").toString());
					sb.append("&endtSeqNo=" + dtlsBillNo.get("endtSeqNo").toString());
					sb.append("&endtType=" + dtlsBillNo.get("endtType").toString());
					sb.append("&polFlag=" + dtlsBillNo.get("polFlag").toString());
					sb.append("&assdNo=" + dtlsBillNo.get("assdNo").toString());
					sb.append("&assdName=" + dtlsBillNo.get("assdName").toString());
					//sb.append("&currRt=" + dtlsBillNo.get("currRt").toString());
					//sb.append("&currCd=" + dtlsBillNo.get("currCd").toString());
					sb.append("&msgAlertBillNo=" + dtlsBillNo.get("msgAlert").toString());
					
					System.out.println("Policy No: " + dtlsBillNo.get("policyNo").toString());
					System.out.println("Policy ID: " + dtlsBillNo.get("policyId").toString());
					System.out.println("Line CD: " + dtlsBillNo.get("lineCd").toString());
					System.out.println("Subline CD: " + dtlsBillNo.get("sublineCd").toString());
					System.out.println("Iss CD: " + dtlsBillNo.get("issCd").toString());
					System.out.println("Issue Year: " + dtlsBillNo.get("issueYear").toString());
					System.out.println("Pol SeqNo: " + dtlsBillNo.get("polSeqNo").toString());
					System.out.println("EndT SeqNo: " + dtlsBillNo.get("endtSeqNo").toString());
					System.out.println("EndT Type: " + dtlsBillNo.get("endtType").toString());
					System.out.println("Pol Flag: " + dtlsBillNo.get("polFlag").toString());
					System.out.println("Assured No: " + dtlsBillNo.get("assdNo").toString());
					System.out.println("Assured Name: " + dtlsBillNo.get("assdName").toString());
					//log.info("Currency RT: " + dtlsBillNo.get("currRt").toString());
					
				}else{
					sb.append("msgAlertBillNo=" + dtlsBillNo.get("msgAlert").toString());
					log.info("msgAlert for BillNo: " + dtlsBillNo.get("msgAlert").toString());
				}
				
				Map<String, Object> dtlsOpenPolicy = directPremCollns.validateOpenPolicy(params);
				if (!dtlsOpenPolicy.get("msgAlert").toString().equals("Ok")){
					sb.append("&msgAlertOpenPolicy=" + dtlsOpenPolicy.get("msgAlert").toString());
				}
				
				if (currCd.size() > 0) {
					String currencyCd = helper.getList(LOVHelper.CURRENCY_BY_PREMSEQNO, argsTransType).get(0).getCode();
					String currShortName = helper.getList(LOVHelper.CURRENCY_BY_PREMSEQNO, argsTransType).get(0).getShortName();
					String currDesc = helper.getList(LOVHelper.CURRENCY_BY_PREMSEQNO, argsTransType).get(0).getDesc();
					BigDecimal currRt = new BigDecimal(helper.getList(LOVHelper.CURRENCY_BY_PREMSEQNO, argsTransType).get(0).getValueFloat());
					sb.append("&currCd=" + currencyCd);
					sb.append("&currRt=" + currRt);
					sb.append("&currShortName=" + currShortName);
					sb.append("&currDesc=" + currDesc);
					log.info("Currency Code: " + currencyCd);
					log.info("Currency ShortName: " + currShortName);
					log.info("Currency RT: " + currRt);
					log.info("Currency Desc: " + currDesc);
				}else{
					log.info("Currency Code: 0");
					sb.append("&currCd=0");
					sb.append("&currRt=0");
					sb.append("&currShortName=" + " ");
					sb.append("&currDesc=" + " ");
				}
				// Validate BillNo logs
				log.info("Validate Bill No parameters.");
				log.info("PremSeqNo: " + request.getParameter("premSeqNo"));
				log.info("IssCd: " + request.getParameter("issCd"));
				log.info("tranType: " + request.getParameter("tranType"));
				log.info("msgAlert for OpenPolicy: " + dtlsOpenPolicy.get("msgAlert").toString());
	
				PAGE = "/pages/genericMessage.jsp";
				message = sb.toString();
			} else if ("openSearchInvoiceModal".equals(ACTION)){
				
				PAGE = "/pages/pop-ups/searchInvoice.jsp";
				
			}else if("getSearchResult".equals(ACTION)){
				/* Define Services needed */
				GIACDirectPremCollnsService directPremCollnsService = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");	
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("premSeqNo", request.getParameter("premSeqNo").equals("") ? null : Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("issCd", 	request.getParameter("issCd").equals("") ? null : request.getParameter("issCd"));
				params.put("tranType", 	request.getParameter("tranType"));
				
				params.put("filter", request.getParameter("objFilter"));
				
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}

				//PaginatedList searchResult = null;
				HashMap<String, Object> searchResult = null;
				Integer pageNo = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				//System.out.println("pageNO from request: " + request.getParameter("pageNo"));
				//pageNo
				//if(null!=request.getParameter("page")){
				//	if(!"undefined".equals(request.getParameter("page"))){
				//		pageNo = new Integer(request.getParameter("page"))-1;
				//	}
				//}
				//searchResult = directPremCollnsService.getInvoiceListing(params, pageNo);
				
				System.out.println(request.getParameter("page") + "getparameter page");
				params.put("currentPage", pageNo);
				
				searchResult = directPremCollnsService.getInvoiceListingTableGrid(params);
				//System.out.println("pageNo: " + searchResult.getPageIndex()+1);
				//System.out.println("noPages: " + searchResult.getNoOfPages());

				request.setAttribute("searchResult",  new JSONObject(searchResult));
				//request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				//request.setAttribute("noOfpages", searchResult.getNoOfPages());
				
				//JSONArray jsonArraySearchResult = new JSONArray(searchResult);
				//request.setAttribute("jsonSearchResult", jsonArraySearchResult);
				
				//Get Search Results Logs
				System.out.println("Get Search Results parameters.");
				System.out.println("PremSeqNo: " + request.getParameter("premSeqNo"));
				System.out.println("IssCd: " + request.getParameter("issCd"));
				System.out.println("tranType: " + request.getParameter("tranType"));
				System.out.println("Keyword: " + request.getParameter("keyword"));
				System.out.println("PageNo: " + request.getParameter("pageNo"));
				//log.info("SearchResult List: " + searchResult.toString());
				System.out.println(request.getParameter("page") + " page");
				if (request.getParameter("page") == null) {
					PAGE = "/pages/pop-ups/searchInvoiceAjaxResult.jsp";
				} else {
					//message = (new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(searchResult))).toString();
					message = new JSONObject(searchResult).toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showInstNoDetails".equals(ACTION)){
				PAGE = "/pages/pop-ups/searchInstNoDetails.jsp";
			}else if("getInstNoResults".equals(ACTION)){
				/*GIACAgingSoaDetailService agingSoaService = (GIACAgingSoaDetailService) APPLICATION_CONTEXT.getBean("giacAgingSoaDetailService");
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				
				List<GIACAgingSoaDetail> instNoDetail = agingSoaService.getInstnoDetails(request.getParameter("issCd"), Integer.parseInt(request.getParameter("premSeqNo")));
				request.setAttribute("instNoDetails", instNoDetail);*/
				
				GIACDirectPremCollnsService directPremCollnsService = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");	
				Map<String, Object> params = new HashMap<String, Object>();
			
				params.put("premSeqNo", request.getParameter("premSeqNo") == "" ? 0 : Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("tranType", request.getParameter("tranType"));
				
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}

				PaginatedList searchResult = null;
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				//try {
				searchResult = directPremCollnsService.getInvoiceListing(params, pageNo);
				
				JSONArray jsonInstallmentListing =  new JSONArray(searchResult);
				
				request.setAttribute("searchResults", jsonInstallmentListing);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				//getInstNoResults Logs
				System.out.println("Get InstNo Results parameters.");
				System.out.println("PremSeqNo: " + request.getParameter("premSeqNo"));
				System.out.println("IssCd: " + request.getParameter("issCd"));
				System.out.println("tranType: " + request.getParameter("tranType"));
				System.out.println("Keyword: " + request.getParameter("keyword"));
				System.out.println("PageNo: " + request.getParameter("pageNo"));
				log.info("getInstNoResults: " + searchResult.toString());
				
				PAGE = "/pages/pop-ups/searchInstNoDetailsAjaxResult.jsp";
			}else if("checkInstNo".equals(ACTION)){
				GIPIInstallmentService gipiInstallService = (GIPIInstallmentService) APPLICATION_CONTEXT.getBean("gipiInstallmentService");
				GIACDirectPremCollnsService directPremCollnsService = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("premSeqNo", request.getParameter("premSeqNo") == "" ? 0 : Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("tranType", request.getParameter("tranType"));
				
				StringBuilder sb = new StringBuilder();
				
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				param.put("issCd", request.getParameter("issCd"));
				param.put("instNo", Integer.parseInt(request.getParameter("instNo")));
				
				Map<String, Object> numInstallments = gipiInstallService.checkInstNo(param);
				sb.append("recCount=" + numInstallments.get("recCount"));
				sb.append("&msgAlert=" + numInstallments.get("msgAlert"));
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = directPremCollnsService.getInvoiceListing(params, pageNo);
				System.out.println(searchResult);
				BigDecimal collectionAmt = new BigDecimal("0.00");
				BigDecimal premAmt = new BigDecimal("0.00");
				BigDecimal taxAmt = new BigDecimal("0.00");
				BigDecimal negCollectionAmt = new BigDecimal("0.00");
				BigDecimal negPremAmt = new BigDecimal("0.00");
				BigDecimal negTaxAmt = new BigDecimal("0.00");
				BigDecimal currRt = new BigDecimal("0.00");
				Map<String, Object> listAmounts = null;
				
				if(searchResult.size() > 0){
					for (int i=0; i<searchResult.size(); i++){
						listAmounts = (Map<String, Object>) searchResult.get(i);
						BigDecimal bd = (BigDecimal) listAmounts.get("instNo");
						if (bd.equals(new BigDecimal(request.getParameter("instNo")))){
							collectionAmt = (BigDecimal) listAmounts.get("collectionAmt");
							premAmt = (BigDecimal) listAmounts.get("premAmt");
							taxAmt = (BigDecimal) listAmounts.get("taxAmt");
							negCollectionAmt = (BigDecimal) listAmounts.get("collectionAmt1");
							negPremAmt = (BigDecimal) listAmounts.get("premAmt1");
							negTaxAmt = (BigDecimal) listAmounts.get("taxAmt1");
							currRt = (BigDecimal) listAmounts.get("currRts");
							break;
						}
					}
				}
				
				sb.append("&collectionAmt=" + collectionAmt);
				sb.append("&premAmt=" + premAmt);
				sb.append("&taxAmt=" + taxAmt);
				sb.append("&negCollectionAmt=" + negCollectionAmt);
				sb.append("&negPremAmt=" + negPremAmt);
				sb.append("&negTaxAmt=" + negTaxAmt);
				sb.append("&instNoStatus=" + searchResult.size());
				sb.append("&currRt=" + currRt);
				sb.append("&searchResult=" + new JSONObject(searchResult));
				//checkInstNo Logs
				log.info("check InstNo parameters.");
				log.info("PremSeqNo: " + request.getParameter("premSeqNo"));
				log.info("IssCd: " + request.getParameter("issCd"));
				log.info("tranType: " + request.getParameter("tranType"));
				log.info("InstNo: " + request.getParameter("instNo"));
				log.info("Keyword: " + request.getParameter("keyword"));
				log.info("PageNo: " + request.getParameter("pageNo"));
				log.info("Record size: "+ searchResult.size());
				log.info("Record count: " + numInstallments.get("recCount"));
				log.info("SearchResult List: " + searchResult.toString());
				log.info("Collection Amt: " + collectionAmt);
				log.info("Prem Amt: " + premAmt);
				log.info("Tax Amt: " + taxAmt);
				log.info("Negative Collection Amt: " + negCollectionAmt);
				log.info("Negative Prem Amt: " + negPremAmt);
				log.info("Negative Tax Amt: " + negTaxAmt);
				log.info("Installment Details: " + numInstallments.toString());
				log.info("InstNo Status: " + searchResult.size());
				log.info("Currency RT: " + currRt);
				
				PAGE = "/pages/genericMessage.jsp";
				message = sb.toString();
			}else if ("validateInstNo".equals(ACTION)){
				GIPIInstallmentService gipiInstallService = (GIPIInstallmentService) APPLICATION_CONTEXT.getBean("gipiInstallmentService");
				
				/*
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				String[] argsTransType = {request.getParameter("issCd"), request.getParameter("premSeqNo")};
				
				StringBuilder sb = new StringBuilder();
				List<LOV> currCd = helper.getList(LOVHelper.CURRENCY_BY_PREMSEQNO, argsTransType);
				if (currCd.size() > 0) {
					sb.append("currCd=" + helper.getList(LOVHelper.CURRENCY_BY_PREMSEQNO, argsTransType).get(0).getCode());
				}else{
					sb.append("currCd=" + "0");
				}*/
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("premSeqNo", request.getParameter("premSeqNo") == "" ? 0 : Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("instNo", Integer.parseInt(request.getParameter("instNo")));
				
				Map<String, Object> numInstallments = gipiInstallService.checkInstNo(params);
				
				//validateInstNo Logs
				log.info("validate InstNo parameters.");
				log.info("PremSeqNo: " + request.getParameter("premSeqNo"));
				log.info("IssCd: " + request.getParameter("issCd"));
				log.info("InstNo: " + request.getParameter("instNo"));
				log.info("Installment Details: " + numInstallments.toString());
				
				PAGE = "/pages/genericMessage.jsp";
				message = numInstallments.get("recCount").toString();
			}else if ("taxDefaultValueType".equals(ACTION)){
				GIACDirectPremCollnsService directPremCollnsService = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
				params.put("tranType", Integer.parseInt(request.getParameter("tranType")));
				params.put("issCd", request.getParameter("tranSource"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("instNo", Integer.parseInt(request.getParameter("instNo")));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("collnAmt", new BigDecimal(request.getParameter("collnAmt")));
				params.put("paramPremAmt", new BigDecimal(request.getParameter("paramPremAmt")));
				params.put("premAmt", new BigDecimal(request.getParameter("premAmt")));
				params.put("taxAmt", new BigDecimal(request.getParameter("taxAmt").toString()));
				params.put("premVatExempt", request.getParameter("premVatExempt").equals("") ? null : new BigDecimal(request.getParameter("premVatExempt")));
				params.put("revTranId", request.getParameter("revTranId").equals("") ? null : 
					Integer.parseInt(request.getParameter("revTranId")));
				params.put("commitTag", (request.getParameter("commitTag") == "" || request.getParameter("commitTag") == null) ? "N" : request.getParameter("commitTag")); //benjo 11.03.2015 GENQA-SR-5015
				
				System.out.println("TAX PARAMS: " + params);
				Map<String, Object> defTaxValue = directPremCollnsService.getDefaultTaxValueType(params, Integer.parseInt(request.getParameter("taxType")));
				System.out.println("defTaxValue: " + defTaxValue);
				StringBuilder sb = new StringBuilder();
				sb.append("taxAmt=" + defTaxValue.get("taxAmt").toString());
				sb.append("&premAmt=" + defTaxValue.get("premAmt").toString());
				sb.append("&collnAmt=" + defTaxValue.get("collnAmt").toString());
				sb.append("&premVatExempt=" + (defTaxValue.get("premVatExempt")==null ? 0 : defTaxValue.get("premVatExempt").toString()));
				System.out.println("Test Retrieved Tax - "+defTaxValue);
				
				//added by alfie 11.26.2010
				List<GIACTaxCollns> taxCollnsListing = (List<GIACTaxCollns>) defTaxValue.get("giacTaxCollnCur");
				JSONArray taxCollns = new JSONArray(taxCollnsListing);
				sb.append("&giacTaxCollnCur="+taxCollns);
				//until here
				
				//message = new JSONObject(defTaxValue).toString();
				PAGE = "/pages/genericMessage.jsp";
				message = sb.toString();
			}else if ("getDaysOverdue".equals(ACTION)){
				GIPIInstallmentService gipiInstallmentService = (GIPIInstallmentService) APPLICATION_CONTEXT.getBean("gipiInstallmentService");
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("instNo", request.getParameter("instNo"));
				param.put("premSeqNo", request.getParameter("premSeqNo"));
				param.put("issCd", request.getParameter("tranSource"));
				param.put("tranDate", request.getParameter("tranDate"));
				
				log.info("parameter InstNo: " + request.getParameter("instNo"));
				log.info("parameter PremSeqNo: " + request.getParameter("premSeqNo"));
				log.info("parameter IssCd: " + request.getParameter("tranSource"));
				log.info("parameter tranDate: " + request.getParameter("tranDate"));
				
				Integer dateDue = gipiInstallmentService.getDaysOverdue(param);
				
				log.info("DueDate Retrieved: " + dateDue);
				
				PAGE = "/pages/genericMessage.jsp";
				message = dateDue.toString();
			}else if ("validateUserFunc".equals(ACTION)){
				GIACModulesService giacModulesService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("user", USER.getUserId());
				param.put("funcCode", request.getParameter("funcCode"));
				param.put("moduleName", request.getParameter("moduleName"));
				
				log.info("User Param: " + USER.getUserId());
				log.info("Function Code Param: " + request.getParameter("funcCode"));
				log.info("Module Name Param: " + request.getParameter("moduleName"));
				
				String userAccessFlag = giacModulesService.validateUserFunc(param);
				log.info("User Module Access Flag: " + userAccessFlag);
				
				PAGE = "/pages/genericMessage.jsp";
				message = userAccessFlag.toString();
			}else if ("showDatedCheckDetail".equals(ACTION)){
				
				PAGE = "/pages/pop-ups/showDatedCheckDtls.jsp";
			}else if ("showDatedCheckDetailResult".equals(ACTION)){
				GIACPdcPremCollnService giacPdcPremCollnService = (GIACPdcPremCollnService) APPLICATION_CONTEXT.getBean("giacPdcPremCollnService");
				Integer gaccTranId = Integer.parseInt(request.getParameter("gaccTranId"));
				List<GIACPdcPremColln> datedChkDtls = giacPdcPremCollnService.getDatedChkDtls(gaccTranId);
				request.setAttribute("datedCheckDtls", datedChkDtls);
				
				log.info("showDatedCheckDetailResult");
				log.info("TranID: " + gaccTranId);
				log.info("Dated Check Record Size: " + datedChkDtls.size());
				
				PAGE = "/pages/pop-ups/showDatedCheckDtlsResult.jsp";
			}else if ("printPremiumCollections".equals(ACTION)){
				
				PAGE = "/pages/pop-ups/printPremiumCollections.jsp";
			}else if ("showForeignCurrDtls".equals(ACTION)){
				
				PAGE = "/pages/pop-ups/foreignCurrencyDtls.jsp";
			}else if ("showPolicyEntry".equals(ACTION)){
				
				PAGE = "/pages/pop-ups/policyEntry.jsp";
				//PAGE = "/pages/pop-ups/policyEntryOverlay.jsp";
			}else if ("getPolicyEntryDetails".equals(ACTION)){
				GIACAgingSoaDetailService agingSoaService = (GIACAgingSoaDetailService) APPLICATION_CONTEXT.getBean("giacAgingSoaDetailService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issYear", request.getParameter("issYear"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("refPolNo", request.getParameter("refPolNo"));
				params.put("checkDue", request.getParameter("checkDue"));
				
				log.info("getPolicyEntryDetails - "+params);
				
				List<Map<String, Object>> policyDetails = agingSoaService.getPolicyDetails(params); 
				
				JSONArray policyDetailsArray = new JSONArray(policyDetails);
				if (policyDetails == null){
					log.info("No Policy Found.");
					message = "recFound=0";
				} else {
					//StringBuilder sb = new StringBuilder();
					//request.setAttribute("policyDetailsListing", policyDetailsArray);
					message = policyDetailsArray.toString();
					/*sb.append("issCd=" + policyDetails.get("issCd").toString());
					sb.append("&tranType=" + policyDetails.get("tranType").toString());
					sb.append("&premSeqNo=" + policyDetails.get("premSeqNo").toString());
					sb.append("&instNo=" + policyDetails.get("instNo").toString());
					sb.append("&balAmtDue=" + policyDetails.get("balAmtDue").toString());
					sb.append("&premBalDue=" + policyDetails.get("premBalDue").toString());
					sb.append("&taxBalDue=" + policyDetails.get("taxBalDue").toString());
					sb.append("&chkTag=" + policyDetails.get("chkTag").toString());
					sb.append("&msgAlert=" + policyDetails.get("msgAlert").toString());
					sb.append("&recFound=1");*/
					log.info("Result policyGetDetails: " + policyDetails.toString());
					/*log.info("Result tranType: " + policyDetails.get("tranType").toString());
					log.info("Result premSeqNo: " + policyDetails.get("premSeqNo").toString());
					log.info("Result instNo: " + policyDetails.get("instNo").toString());
					log.info("Result balanceAmtDue: " + policyDetails.get("balAmtDue").toString());
					log.info("Result premBalDue: " + policyDetails.get("premBalDue").toString());
					log.info("Result taxBalDue: " + policyDetails.get("taxBalDue").toString());
					log.info("Result chkTag: " + policyDetails.get("chkTag").toString());
					log.info("Result msgAlert: " + policyDetails.get("msgAlert").toString());*/
					//message = sb.toString();
				}
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveDirectPremCollnsDtls".equals(ACTION)){
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIACDirectPremCollnsService directPremCollnsService = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");
				System.out.println("giacDirectPremCollns size: " + request.getParameter("giacDirectPremCollns").length());

				List<GIACDirectPremCollns> giacDirectPremCollns = parseGIACDirectPremCollns(request.getParameter("giacDirectPremCollns"));
				Debug.print("giacDirectPremCollns params: " + giacDirectPremCollns);
				List<GIACDirectPremCollns> giacDirectPremCollnsAll = parseGIACDirectPremCollns(request.getParameter("giacDirectPremCollnsAll"));
				Debug.print("giacDirectPremCollnsAll params: " + giacDirectPremCollnsAll);
				List<GIACDirectPremCollns> listToDelete = parseListToDelete(request.getParameter("listToDelete"));
				List<Map<String, Object>> taxDefaultParams =  parseTaxDefaultParams(request.getParameter("taxDefaultParams"));
				//System.out.println("tax params: " + request.getParameter("taxDefaultParams"));
				//System.out.println("tax params size: " + taxDefaultParams.size());
				
				//GIAC PARAMETERS
				GIACParameter giacBut = giacParamService.getParamValueV("GIACS007_BUT");
				request.setAttribute("giacs007But", giacBut.getParamValueV());
				
				GIACParameter premRecGrossTag = giacParamService.getParamValueV("PREM_REC_GROSS_TAG");
				
				Map<String, Object> giacParams = new HashMap<String, Object>();
				giacParams.put("premRecGrossTag", premRecGrossTag.getParamValueV());
				
				System.out.println(premRecGrossTag.getParamValueV());
				log.info("giacs007But value: " + giacBut.getParamValueV());
				log.info("PremRecGrossTag value: " + premRecGrossTag.getParamValueV() );
				
				Map<String, Object> aegParams = new HashMap<String, Object>();
				aegParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				aegParams.put("moduleName", request.getParameter("moduleName"));
				aegParams.put("moduleId", 0);
				aegParams.put("genType", "");
				aegParams.put("msgAlert", "");
				
				Map<String, Object> genAcctEntrYParams = new HashMap<String, Object>();
				genAcctEntrYParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				genAcctEntrYParams.put("moduleName", request.getParameter("moduleName"));
				genAcctEntrYParams.put("itemNo", 0);
				genAcctEntrYParams.put("msgAlert", "");
				genAcctEntrYParams.put("branchCd", request.getParameter("branchCd"));
				genAcctEntrYParams.put("fundCd", request.getParameter("fundCd"));
				
				Map<String, Object> genAcctEntrNParams = new HashMap<String, Object>();
				genAcctEntrNParams.put("moduleName", request.getParameter("moduleName"));
				//genAcctEntrNParams.put("tranType", request.getParameter("tranType"));
				genAcctEntrNParams.put("fundCd", request.getParameter("fundCd"));
				genAcctEntrNParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				genAcctEntrNParams.put("itemNo", 0);
				genAcctEntrNParams.put("msgAlert", "");
				
				Map<String, Object> genOpTextParams = new HashMap<String, Object>();
				genOpTextParams.put("tranSource", request.getParameter("tranSource"));
				genOpTextParams.put("orFlag", request.getParameter("orFlag"));
				genOpTextParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				genOpTextParams.put("moduleName", request.getParameter("moduleName"));
				genOpTextParams.put("fundCd", request.getParameter("fundCd"));
				
				List<Map<String, Object>> updateGiacOrderOfPaymtsParam = new ArrayList<Map<String,Object>>();
				Map<String, Object> params = null;
				//for (int i=0; i < giacDirectPremCollnsAll.size(); i++){giacDirectPremCollns
				for (int i=0; i < giacDirectPremCollns.size(); i++){
					params = new HashMap<String, Object>();
					params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
					params.put("premSeqNo", giacDirectPremCollnsAll.get(i).getPremSeqNo());
					params.put("issCd", giacDirectPremCollnsAll.get(i).getIssCd());
					params.put("tranSource", request.getParameter("tranSource"));
					params.put("moduleName", request.getParameter("moduleName"));
					params.put("msgAlert", " ");
					params.put("workflowMsg", " ");
					params.put("userId", USER.getUserId());
					params.put("orPartSw", "O");
					updateGiacOrderOfPaymtsParam.add(params);
				}
				
				Map<String, Object> allPremParams = new HashMap<String, Object>();
				allPremParams.put("giacDirectPremCollns", giacDirectPremCollns);
				allPremParams.put("giacDirectPremCollnsAll", giacDirectPremCollnsAll);
				allPremParams.put("listToDelete",listToDelete);
				allPremParams.put("taxDefaultParams", taxDefaultParams);
				allPremParams.put("aegParams", aegParams);
				allPremParams.put("giacParams", giacParams);
				
				Map<String, Object> allAcctParams = new HashMap<String, Object>();
				allAcctParams.put("genAcctEntrYParams", genAcctEntrYParams);
				allAcctParams.put("genAcctEntrNParams", genAcctEntrNParams);
				allAcctParams.put("giacDirectPremCollnsAll", giacDirectPremCollnsAll);
				allAcctParams.put("genOpTextParams", genOpTextParams);
				allAcctParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				allAcctParams.put("updateGiacOrderOfPaymtsParam", updateGiacOrderOfPaymtsParam);
			
				String strParams = directPremCollnsService.saveDirectPremCollnsDtls(allPremParams);
				directPremCollnsService.saveDirectPremCollnsAcctDtls(allAcctParams);
				
				StringBuilder sb = new StringBuilder();
				sb.append("strParams=" + strParams);
				sb.append("&giacsBut=" + giacBut.getParamValueV().toString());
				
				PAGE = "/pages/genericMessage.jsp";
				message = "SUCCESS";
			}else if ("showOverideUser".equals(ACTION)){
				PAGE = "/pages/pop-ups/OverrideUser.jsp";
			}else if ("showOverideUser2".equals(ACTION)){
				PAGE = "/pages/pop-ups/overrideUser2.jsp";
			}else if ("validateOverideUserDtls".equals(ACTION)) {
				GIISUserFacadeService giisUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				DriverManagerDataSource dataSource = (DriverManagerDataSource) APPLICATION_CONTEXT.getBean("dataSource");
				String url = dataSource.getUrl();
				String databaseName = url.substring(url.lastIndexOf(":")+1, url.length());
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("user", 		request.getParameter("userName"));
				params.put("password", 		request.getParameter("password"));
				params.put("funcCode", 	request.getParameter("funcCode"));
				params.put("moduleName", 		request.getParameter("moduleName"));
				Map<String, Object> usrParams = giisUserService.userOveride(params);
				
				StringBuilder sb = new StringBuilder();
				sb.append("message="+ usrParams.get("message").toString());
				Debug.print(sb);
				
				System.out.println("database: " + databaseName);
				PAGE = "/pages/genericMessage.jsp";
				message = sb.toString();
				System.out.println("result message: "+message);
			}else if ("validateOverideUserDtls2".equals(ACTION)) {
				GIISUserFacadeService giisUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				DriverManagerDataSource dataSource = (DriverManagerDataSource) APPLICATION_CONTEXT.getBean("dataSource");
				String url = dataSource.getUrl();
				String databaseName = url.substring(url.lastIndexOf(":")+1, url.length());
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("user", request.getParameter("userName"));
				params.put("password", request.getParameter("password"));
				params.put("funcName", request.getParameter("funcName"));
				params.put("moduleName", request.getParameter("moduleName"));
				Map<String, Object> usrParams = giisUserService.userOveride2(params);
				
				StringBuilder sb = new StringBuilder();
				sb.append("message="+ usrParams.get("message").toString());
				Debug.print(sb);
				
				System.out.println("database: " + databaseName);
				PAGE = "/pages/genericMessage.jsp";
				message = sb.toString();
			}else if ("checkClaim".equals(ACTION)){
				log.info("CHECK CLAIM");
				GIPIPolbasicService gipiPolService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("issCd", request.getParameter("issCd"));
				log.info("PremSeqNo: " + request.getParameter("premSeqNo"));
				log.info("Iss Cd: " + request.getParameter("issCd"));
				String claimExist = gipiPolService.checkClaim(params);
				log.info("Claims Found: " + claimExist);
				
				PAGE = "/pages/genericMessage.jsp";
				message = claimExist;
			/*}else if ("updateAllPayorIntmDtls".equals(ACTION)){
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				Map<String, Object> params = new HashMap<String, Object>();
			
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("payorBtn", request.getParameter("payorBtn"));
				params.put("msg", ".");
				
				orderPaymentDetailService.updateAllPayorItmDtls(params);
				
				log.info(params.get("msg").toString());
				PAGE = "/pages/genericMessage.jsp";
				message = params.get("msg").toString();	commented by alfie 03-14-2011*/
			}else if ("showSpecUpdate".equals(ACTION)){
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/directPremCollnsSpecUpdate.jsp";
			}else if ("updateSelectedPayorItmDtls".equals(ACTION)){
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("payorBtn", request.getParameter("payorBtn"));
				params.put("payorAdd", request.getParameter("payorAdd"));
				params.put("addressAdd", request.getParameter("addressAdd"));
				params.put("intmAdd", request.getParameter("intmAdd"));
				params.put("particularsAdd", request.getParameter("particularsAdd"));
				params.put("msg", ".");
				
				Debug.print("Before:" + params);
				orderPaymentDetailService.updateSelectedPayorItmDtls(params);
				Debug.print("After:" + params);
				
				PAGE = "/pages/genericMessage.jsp";
				message = params.get("msg").toString();;
			} else if ("getTaxCollections".equals(ACTION)) { //added by alfie 11.26.2010
				GIACTaxCollnsService giacTaxCollnsService = (GIACTaxCollnsService) APPLICATION_CONTEXT.getBean("giacTaxCollnsService");
				
				List<GIACTaxCollns> giacTaxCollnsListing = giacTaxCollnsService.getTaxCollnsListing(Integer.parseInt(request.getParameter("gaccTranId")));
				JSONArray jsonTaxCollnsListing = new JSONArray(giacTaxCollnsListing);
				
				message = jsonTaxCollnsListing.toString();
				PAGE = "/pages/genericMessage.jsp"; //until here 11.26.2010
			} else if ("updateAllPayorIntmDtls2".equals(ACTION)){ //added by alfie 12.10.2010
				
				String outMessage = null;
				String payor = null;
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				orderPaymentDetailService.updateAllPayorItmDtls2(new JSONArray(request.getParameter("premCollnsDtls")));
				outMessage = orderPaymentDetailService.getUpdatedPayorIntmDtls(new JSONArray(request.getParameter("premCollnsDtls")));
				
				System.out.println("tran ID:::::::::::::::: " + request.getParameter("tranId"));
				payor = orderPaymentDetailService.getPayorIntmDtls(new Integer(request.getParameter("tranId")));
				HashMap<String, Object> resultParams = new HashMap<String, Object>();//aww
				resultParams.put("outMessage", outMessage);
				resultParams.put("payor", payor);
				log.info(outMessage);
				
				/*PAGE = "/pages/genericMessage.jsp";
				message = outMessage;*/
				//until here 12.13.2010
				
				request.setAttribute("object", new JSONObject(resultParams));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateRecord".equals(ACTION)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("premSeqNo", 			 new Integer(request.getParameter("premSeqNo")));
				param.put("issCd", 				 request.getParameter("issCd"));
				param.put("instNo", 			 new Integer(request.getParameter("instNo")));
				param.put("tranType", 			 Integer.parseInt(request.getParameter("tranType")));
				param.put("billPremiumOverdue",  request.getParameter("billPremiumOverdue"));
				param.put("tranDate",            request.getParameter("tranDate"));
				param.put("revGaccTranId",       request.getParameter("revGaccTranId"));
				
				Debug.print(" validate param: " + param);
				
				Map <String, Object> validationDtlListing = giacDirectPremCollnsService.validateRecord(param);
				
				JSONArray jsonArrayValidationDtls = new JSONArray();
				
				jsonArrayValidationDtls.put(validationDtlListing);
				System.out.println("jsonArrayValidationDtls: "+jsonArrayValidationDtls);
				request.setAttribute("object", jsonArrayValidationDtls);
				
				PAGE="/pages/genericObject.jsp";
				
			}  else if ("getEnteredBillDetails".equals(ACTION)) {
				Map<String, Object> param = new HashMap<String, Object>();
				Map<String, Object> resultParams = new HashMap<String, Object>();
				
				param.put("premSeqNo", new Integer(request.getParameter("premSeqNo")));
				param.put("issCd", request.getParameter("issCd"));
				param.put("instNo", request.getParameter("instNo"));
				param.put("tranType", request.getParameter("tranType"));
				String checkBill = giacDirectPremCollnsService.checkIfInvoiceExists(param);
				System.out.println("checkIfInvoiceExists - "+checkBill);
				resultParams.put("errorMsg", checkBill);
				
				List<Map <String, Object>> enteredBillDetails = giacDirectPremCollnsService.getInvoiceListing(param);
				System.out.println("Get # of entered bill: "+enteredBillDetails.size());
				resultParams.put("bills", new JSONArray(enteredBillDetails));
				
				//Map <String, Object> enteredBillDetails = giacDirectPremCollnsService.getEnteredBillDetails(param);
				
				request.setAttribute("object", new JSONObject(resultParams));
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("saveDirectPremCollnsDtls2".equals(ACTION)){
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIACDirectPremCollnsService directPremCollnsService = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");

				JSONArray giacDirectPremCollns 		= new JSONArray(request.getParameter("giacDirectPremCollns").toString());
				JSONArray giacDirectPremCollnsAll 	= new JSONArray(request.getParameter("giacDirectPremCollnsAll").toString());
				JSONArray listToDelete = null;
				if ((request.getParameter("listToDelete")==null)) {
					listToDelete 				= new JSONArray();
				} else {
					listToDelete 				= new JSONArray(request.getParameter("listToDelete").toString());
				}
				
				JSONArray taxDefaultParams 			= new JSONArray(request.getParameter("taxDefaultParams").toString());
				
				//GIAC PARAMETERS
				GIACParameter giacBut = giacParamService.getParamValueV("GIACS007_BUT");
				request.setAttribute("giacs007But", giacBut.getParamValueV());
				
				GIACParameter premRecGrossTag = giacParamService.getParamValueV("PREM_REC_GROSS_TAG");
				
				Map<String, Object> giacParams = new HashMap<String, Object>();
				giacParams.put("premRecGrossTag", premRecGrossTag.getParamValueV());
				
				System.out.println("giacs007But value: " + giacBut.getParamValueV());
				System.out.println("PremRecGrossTag value: " + premRecGrossTag.getParamValueV());
				
				Map<String, Object> aegParams = new HashMap<String, Object>();
				aegParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				aegParams.put("moduleName", request.getParameter("moduleName"));
				aegParams.put("moduleId", 0);
				aegParams.put("genType", "");
				aegParams.put("msgAlert", "");
				
				Map<String, Object> genAcctEntrYParams = new HashMap<String, Object>();
				genAcctEntrYParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				genAcctEntrYParams.put("moduleName", request.getParameter("moduleName"));
				genAcctEntrYParams.put("itemNo", 0);
				genAcctEntrYParams.put("msgAlert", "");
				genAcctEntrYParams.put("branchCd", request.getParameter("branchCd"));
				genAcctEntrYParams.put("fundCd", request.getParameter("fundCd"));
				
				Map<String, Object> genAcctEntrNParams = new HashMap<String, Object>();
				genAcctEntrNParams.put("moduleName", request.getParameter("moduleName"));
				//genAcctEntrNParams.put("tranType", request.getParameter("tranType"));
				genAcctEntrNParams.put("fundCd", request.getParameter("fundCd"));
				genAcctEntrNParams.put("branchCd", request.getParameter("branchCd")); //marco - 12.16.2014
				genAcctEntrNParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				genAcctEntrNParams.put("itemNo", 0);
				genAcctEntrNParams.put("msgAlert", "");
				
				Map<String, Object> genOpTextParams = new HashMap<String, Object>();
				genOpTextParams.put("tranSource", request.getParameter("tranSource"));
				genOpTextParams.put("orFlag", request.getParameter("orFlag"));
				genOpTextParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				genOpTextParams.put("moduleName", request.getParameter("moduleName"));
				genOpTextParams.put("fundCd", request.getParameter("fundCd"));
				genOpTextParams.put("recCount", Integer.parseInt(request.getParameter("recCount")));
				
				List<Map<String, Object>> updateGiacOrderOfPaymtsParam = new ArrayList<Map<String,Object>>();
				Map<String, Object> params = null;
				System.out.println("giacDirectPremCollnsAll.length - "+giacDirectPremCollnsAll.length());
				for (int i=0; i < giacDirectPremCollnsAll.length(); i++){
					//System.out.println();
					params = new HashMap<String, Object>();
					JSONObject obj = giacDirectPremCollnsAll.getJSONObject(i);
					params.put("userId", USER.getUserId());
					params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
					params.put("premSeqNo", obj.isNull("premSeqNo") ? null : obj.getInt("premSeqNo"));
					params.put("issCd", obj.isNull("issCd") ? null : obj.getString("issCd"));
					params.put("tranType", obj.isNull("tranType") ? null : obj.getInt("tranType"));
					params.put("instNo", obj.isNull("instNo") ? null : obj.getInt("instNo"));
					params.put("premAmt", obj.isNull("premAmt") ? null : new BigDecimal(obj.getString("premAmt")));
					params.put("taxAmt", obj.isNull("taxAmt") ? null : new BigDecimal(obj.getString("taxAmt")));
					params.put("tranSource", request.getParameter("tranSource"));
					params.put("moduleName", request.getParameter("moduleName"));
					params.put("msgAlert", " ");
					params.put("workflowMsg", " ");
					params.put("orPartSw", "O");
					updateGiacOrderOfPaymtsParam.add(params);
				}
				/*				
				Map<String, Object> allAcctParams = new HashMap<String, Object>();
				allAcctParams.put("genAcctEntrYParams", genAcctEntrYParams);
				allAcctParams.put("genAcctEntrNParams", genAcctEntrNParams);
				allAcctParams.put("giacDirectPremCollnsAll", giacDirectPremCollnsAll);
				allAcctParams.put("genOpTextParams", genOpTextParams);
				allAcctParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				allAcctParams.put("updateGiacOrderOfPaymtsParam", updateGiacOrderOfPaymtsParam);
				allAcctParams.put("appUser", USER.getUserId());
				*/
				
				Map<String, Object> allPremParams = new HashMap<String, Object>();
				allPremParams.put("giacDirectPremCollns", giacDirectPremCollns);
				allPremParams.put("giacDirectPremCollnsAll", giacDirectPremCollnsAll);
				allPremParams.put("listToDelete",listToDelete);
				allPremParams.put("taxDefaultParams", taxDefaultParams);
				allPremParams.put("aegParams", aegParams);
				allPremParams.put("giacParams", giacParams);
				allPremParams.put("appUser", USER.getUserId());
				//acct details
				allPremParams.put("genAcctEntrYParams", genAcctEntrYParams);
				allPremParams.put("genAcctEntrNParams", genAcctEntrNParams);
				allPremParams.put("giacDirectPremCollnsAll", giacDirectPremCollnsAll);
				allPremParams.put("genOpTextParams", genOpTextParams);
				allPremParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				allPremParams.put("updateGiacOrderOfPaymtsParam", updateGiacOrderOfPaymtsParam);
				allPremParams.put("appUser", USER.getUserId());
				allPremParams.put("tranSource", request.getParameter("tranSource"));
				log.info("saveDirectPremCollnsDtls2: "+allPremParams);
				String strParams = directPremCollnsService.saveDirectPremCollnsDtls(allPremParams);
				//directPremCollnsService.saveDirectPremCollnsAcctDtls(allAcctParams);
				
				StringBuilder sb = new StringBuilder();
				sb.append("strParams=" + strParams);
				sb.append("&giacsBut=" + giacBut.getParamValueV().toString());
				message = strParams;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showInvoicesOfPolicy".equals(ACTION)) {
				log.info("ACTION: showInvoicesOfPolicy");
				PAGE = "/pages/pop-ups/policyListing.jsp";
				
			} else if ("getRelatedDirectPremColl".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giacDirectPremCollnsService.getRelatedDirectPremCollns(params);
				
				JSONObject directPremCollnsObject = new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params));
				request.setAttribute("gipiRelatedDirectPremCollnsTableGrid",directPremCollnsObject );
				if(request.getParameter("lineCd").equals("SU")){
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedDirectPremCollnsTableSu.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedDirectPremCollnsTable.jsp";
				}
				
			}else if ("refreshRelatedDirectPremColl".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("issCd",request.getParameter("issCd"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giacDirectPremCollnsService.getRelatedDirectPremCollns(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
				
			}else if ("validateUserFunc3".equals(ACTION)){
				GIACModulesService giacModulesService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("user", request.getParameter("userId"));
				param.put("funcCode", request.getParameter("funcCode"));
				param.put("moduleName", request.getParameter("moduleName"));
				
				log.info("User Param: " + request.getParameter("userId"));
				log.info("Function Code Param: " + request.getParameter("funcCode"));
				log.info("Module Name Param: " + request.getParameter("moduleName"));
				
				String userAccessFlag = giacModulesService.validateUserFunc3(param);
				log.info("User Module Access Flag: " + userAccessFlag);
				
				PAGE = "/pages/genericMessage.jsp";
				message = userAccessFlag.toString();
			} else if ("getPolicyInvoices".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issYear", request.getParameter("issYear"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("refPolNo", request.getParameter("refPolNo"));
				params.put("dueTag", request.getParameter("checkDue"));//bert 01.23.2013
				List<Map <String, Object>> policyBillDetails = giacDirectPremCollnsService.getPolicyInvoices(params);
				log.info("getPolicyInvoices - "+policyBillDetails.size()+": "+params);
				JSONArray jsonObjBillDetails = new JSONArray(policyBillDetails);
				request.setAttribute("object", jsonObjBillDetails);
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateGIACS007PremSeqNo".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("tranType", Integer.parseInt(request.getParameter("tranType")));
				message = giacDirectPremCollnsService.validateGIACS007PremSeqNo(params);
				log.info("Validating entered Prem Seq No: "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("setPremTaxTranType".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("tranType", Integer.parseInt(request.getParameter("tranType")));
				params.put("instNo", Integer.parseInt(request.getParameter("instNo")));
				params.put("premAmt", new BigDecimal(request.getParameter("premAmt")));
				message = new JSONObject(giacDirectPremCollnsService.setPremTaxTranType(params)).toString();
				System.out.println("setPremTaxTranType result: "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("getIncTagForAdvPremPayts".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("tranId")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				message = giacDirectPremCollnsService.getIncTagForAdvPremPayts(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkSpecialBill".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				message = giacDirectPremCollnsService.checkSpecialBill(params);
				System.out.println("checkSpecialBill: "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("preValidateBill".equals(ACTION)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("premSeqNo", new Integer(request.getParameter("premSeqNo")));
				param.put("issCd", request.getParameter("issCd"));
				
				param = giacDirectPremCollnsService.validateBillNo(param);
				message = new JSONObject(StringFormatter.escapeHTMLInMap(param)).toString();
				//message = (String) param.get("msgAlert");
				System.out.println("validateBillNo: "+message);
				
				PAGE = "/pages/genericMessage.jsp";
			}else if ("loadDirectPremForm2".equals(ACTION)) {
				GIACParameterFacadeService giacParamService  = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGdpcTableGrid");
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				Map<String, Object> gdpcTableGrid = TableGridUtil.getTableGrid(request, params);
				gdpcTableGrid.putAll(giacDirectPremCollnsService.getDirectPremTotals(params));
				JSONObject json = new JSONObject(gdpcTableGrid);
				request.setAttribute("directPremExist", json.getString("total"));
				
				List<LOV> currencyDetails = helper.getList(LOVHelper.CURRENCY_CODES);
				StringFormatter.replaceQuotesInList(currencyDetails);
				request.setAttribute("currencyDetails", new JSONArray(currencyDetails));
				
				String[] argsTransType = {"GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE"};
				request.setAttribute("transactionTypeList", helper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, argsTransType));
				
				request.setAttribute("giacs007But", giacParamService.getParamValueV2("GIACS007_BUT"));
				
				String[] argsIssCd = {"GIACS007", USER.getUserId()};
				request.setAttribute("issueSourceList", helper.getList(LOVHelper.ACCTG_ISSUE_CD_LISTING, argsIssCd));
				
				Integer chkBillPremOverdue = giacParamService.getParamValueN("BILL_PREMIUM_OVERDUE");
				request.setAttribute("chkBillPremOverdue", chkBillPremOverdue);
				
				GIACParameter chkPremAging = giacParamService.getParamValueV("CHECK_PREMIUM_AGING");
				request.setAttribute("chkPremAging", chkPremAging.getParamValueV());
				
				GIACParameter tPriority = giacParamService.getParamValueV("PREM_TAX_PRIORITY");
				request.setAttribute("taxPriority", tPriority.getParamValueV());
				
				GIACParameter tAlloc = giacParamService.getParamValueV("TAX_ALLOCATION");
				request.setAttribute("taxAllocation", tAlloc.getParamValueV());
				
				//added by d.alcantara, 10/30/2012
				request.setAttribute("allowCancelledPol", giacParamService.getParamValueV2("ALLOW_PAYT_OF_CANCELLED_POL"));
				
				GIACParameter enterAdvPayt = giacParamService.getParamValueV("ENTER_ADVANCED_PAYT");
				request.setAttribute("enterAdvPayt", enterAdvPayt.getParamValueV());
				
				//marco - 09.16.2014
				GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT.getBean("giacUserFunctionsService");
				request.setAttribute("hasCCFunction", giacUserFunctionsService.checkIfUserHasFunction("CC", "GIACS007", USER.getUserId()));
				
				request.setAttribute("allowNonseqPaytInst", giacParamService.getParamValueV2("ALLOW_NONSEQ_PAYT_INST")); //robert
				request.setAttribute("autoGenCommPayt", giacParamService.getParamValueV2("AUTO_GENERATE_COMM_PAYT")); //robert
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("gdpcTableGrid", json);
					PAGE = "/pages/accounting/officialReceipt/subPages/directPremiumCollection2.jsp";
				}
			}else if("refreshTaxCollectionTG".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIACTaxCollnTG");
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("instNo", request.getParameter("instNo"));
				Map<String, Object> taxCollTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(taxCollTableGrid);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("refreshPremCollectionTG".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getPremCollnsTG");
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				Map<String, Object> premCollTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(premCollTableGrid);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showInvoiceListingTg".equals(ACTION)){Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("tranType", request.getParameter("tranType"));
				params.put("instNo", request.getParameter("instNo"));
				params.put("ACTION", "getInvoiceListingTG3");
				Map<String, Object> reserveDSTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(reserveDSTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("reserveDsTG", json);
					PAGE = "/pages/pop-ups/searchInvoiceInstNo.jsp";
				}
			}else if("refreshInvoiceListingTg".equals(ACTION)){Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("tranType", request.getParameter("tranType"));
				params.put("instNo", request.getParameter("instNo"));
				params.put("ACTION", "getInvoiceListingTG3");
				Map<String, Object> reserveDSTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(reserveDSTableGrid);
				//if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				/*} else {
					request.setAttribute("reserveDsTG", json);
					PAGE = "/pages/pop-ups/searchInvoiceInstNo.jsp";
				}*/
			
			}else if ("validateBillNo2".equals(ACTION)){
				GIACDirectPremCollnsService directPremCollns = (GIACDirectPremCollnsService) APPLICATION_CONTEXT.getBean("giacDirectPremCollnsService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("issCd", request.getParameter("issCd"));
				params = directPremCollns.validateBillNo(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkInstNoGIACS007".equals(ACTION)){
				GIPIInstallmentService gipiInstallmentService = (GIPIInstallmentService) APPLICATION_CONTEXT.getBean("gipiInstallmentService");
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("issCd", request.getParameter("issCd"));
				param.put("premSeqNo", request.getParameter("premSeqNo"));
				param.put("instNo", request.getParameter("instNo"));
				Integer instNoExist = gipiInstallmentService.checkInstNoGIACS007(param);
				log.info("Check Inst No  " + instNoExist);
				message = instNoExist == null ? null : instNoExist.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("preValidateBill".equals(ACTION)) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("premSeqNo", new Integer(request.getParameter("premSeqNo")));
				param.put("issCd", request.getParameter("issCd"));
				
				param = giacDirectPremCollnsService.validateBillNo(param);
				message = new JSONObject(StringFormatter.escapeHTMLInMap(param)).toString();
				//message = (String) param.get("msgAlert");
				System.out.println("validateBillNo: "+message);
				
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("getPackInvoices".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();

				params.put("dueTag", request.getParameter("dueTag"));
				params.put("packLineCd", request.getParameter("lineCd"));
				params.put("packSublineCd", request.getParameter("sublineCd"));
				params.put("packIssCd", request.getParameter("issCd"));
				params.put("issYear", request.getParameter("issYear"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("ACTION", "getPackInvoices");
				
				Map<String, Object> packInvoicesTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(packInvoicesTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("packInvoicesTG", json);
					PAGE = "/pages/pop-ups/packInvoices.jsp";
				}
			}else if("getNumberOfInst".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("tranType", request.getParameter("tranType"));
				message = giacDirectPremCollnsService.getNumberOfInst(params).toString();
			} else if("validatePolicy".equals(ACTION)){
				message = new JSONObject(giacDirectPremCollnsService.validatePolicy(request)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkPreviousInst".equals(ACTION)){
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("issCd", request.getParameter("issCd"));
				param.put("premSeqNo", request.getParameter("premSeqNo"));
				param.put("instNo", request.getParameter("instNo"));
				System.out.println("robertooooo "+giacDirectPremCollnsService.checkPreviousInst(param));
				message = giacDirectPremCollnsService.checkPreviousInst(param);
				PAGE = "/pages/genericMessage.jsp";
			} 
			
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (SQLException e){
			if(e.getErrorCode() > 20000 && e.getCause().toString().contains("Geniisys Exception")){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	private List<GIACDirectPremCollns> parseGIACDirectPremCollns(String arg){
		
		List<GIACDirectPremCollns> list = new ArrayList<GIACDirectPremCollns>();
		List<String> strs = getListPipe(arg);
		for(int x = 0; x < strs.size(); x++){	
			GIACDirectPremCollns coll = null;
			try {
				coll = new GIACDirectPremCollns(
						Integer.valueOf(strs.get(x)).intValue(),
						Integer.valueOf(strs.get(x+1)),
						strs.get(x+2),
						Integer.valueOf(strs.get(x+3)).intValue(),
						Integer.valueOf(strs.get(x+4)).intValue(),
						new BigDecimal(strs.get(x+5)),
						new BigDecimal(strs.get(x+6)),
						new BigDecimal(strs.get(x+7)),
						strs.get(x+8),
						strs.get(x+9),
						Integer.valueOf(strs.get(x+10)).intValue(),
						new BigDecimal(strs.get(x+11)),
						new BigDecimal(strs.get(x+12))
				);
				list.add(coll);
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 12;
		}
		return list;
	}
	
	private List<GIACDirectPremCollns> parseListToDelete(String arg){
		
		List<GIACDirectPremCollns> list = new ArrayList<GIACDirectPremCollns>();
		List<String> strs = getListPipe(arg);
		for(int x = 0; x < strs.size(); x++){	
			GIACDirectPremCollns coll = null;
			try {
				coll  = new GIACDirectPremCollns(
					Integer.valueOf(strs.get(x)).intValue(),
					Integer.valueOf(strs.get(x+1)).intValue(),
					strs.get(x+2),
					Integer.valueOf(strs.get(x+3)).intValue(),
					Integer.valueOf(strs.get(x+4)).intValue()
				);
				list.add(coll);
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 4;
		}
		return list;
	}
	
private List<Map<String, Object>> parseTaxDefaultParams(String arg){
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		List<String> strs = getListPipe(arg);
		for(int x = 0; x < strs.size(); x++){	
			try {
				System.out.println("CAUSE OF ERROR VALUE: " + strs.get(x+9));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.valueOf(strs.get(x)).intValue());
				params.put("tranType", Integer.valueOf(strs.get(x+1)).intValue());
				params.put("issCd", strs.get(x+2));
				params.put("premSeqNo", Integer.valueOf(strs.get(x+3)).intValue());
				params.put("instNo", Integer.valueOf(strs.get(x+4)).intValue());
				params.put("fundCd", strs.get(x+5));
				params.put("collnAmt", new BigDecimal(strs.get(x+6)));
				params.put("premAmt", new BigDecimal(strs.get(x+7)));
				params.put("taxAmt", new BigDecimal(strs.get(x+8)));
				params.put("origPremAmt", new BigDecimal(strs.get(x+9)));
				params.put("sumTaxTotal", new BigDecimal(strs.get(x+10)));
				
				list.add(params);
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 10;
		}
		return list;
	}
	
	public static List<String> getListPipe(String req) {
		List<String> list = new ArrayList<String>();
		req = req.replaceAll(",", "");
		int start = 0;
		if (req.length() > 0)	{
			for (int x=0; x<req.length();x++) {
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
