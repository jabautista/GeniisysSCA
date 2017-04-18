package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACAccTrans;
import com.geniisys.giac.entity.GIACPremDeposit;
import com.geniisys.giac.service.GIACAgingRiSoaDetailsService;
import com.geniisys.giac.service.GIACAgingSoaDetailService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACPremDepositService;
import com.geniisys.giac.service.GIACUserFunctionsService;
import com.seer.framework.util.ApplicationContextReader;

public class GIACPremDepositController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACPremDepositController.class);

	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			/*default attributes*/
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			PAGE = "/pages/genericMessage.jsp";
			String strGaccTranId = request.getParameter("gaccTranId") == null ? "0" : request.getParameter("gaccTranId");
			/*end of default attributes*/
			
			Integer gaccTranId= strGaccTranId.trim().equals("") ? 0 : Integer.parseInt(strGaccTranId);
			String gaccBranchCd = request.getParameter("gaccBranchCd");
			String gfunFundCd = request.getParameter("gaccFundCd");
			String tranSource = request.getParameter("tranSource");
			String orFlag = request.getParameter("orFlag");
			
			log.info("Tran ID : " + gaccTranId);
			log.info("Branch Cd : " + gaccBranchCd);
			log.info("Fund Cd : " + gfunFundCd);
			
			if ("showPremDep".equals(ACTION)) {
				GIACPremDepositService premDepositService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				
				Map<String, Object> params2 = new HashMap<String, Object>();
				List<GIACPremDeposit> premDepositList;// = premDepositService.getGIACPremDeposit(gaccTranId);
				GIACAccTrans accTrans = null;// = premDepositService.getGIACAcctrans(gaccTranId, gfunFundCd, gaccBranchCd);
				List<HashMap<String, Object>> giisCurrencyList = null;
				
				Integer dfltCurrencyCd = giacParamService.getParamValueN("CURRENCY_CD");
				Map<String, Object> dfltCurrencyDtl = premDepositService.getDefaultCurrency(dfltCurrencyCd == null ? 0 : dfltCurrencyCd);
				
				//retrieve records for this module
				params2.put("tranId", gaccTranId);
				params2.put("gfunFundCd", gfunFundCd);
				params2.put("gibrBranchCd", gaccBranchCd);
				
				params2 = premDepositService.getGIACPremDepositModuleRecords(params2);
				
				premDepositList = (List<GIACPremDeposit>) params2.get("GIACPremDepositList");
				for (GIACAccTrans giacAcctrans : (List<GIACAccTrans>) params2.get("GIACAcctrans")) {
					accTrans = giacAcctrans;
				}
				
				giisCurrencyList = (List<HashMap<String, Object>>) params2.get("GIISCurrencyList");
				
				//set policy no for each premium deposit
				for (int i = 0; i < premDepositList.size(); i++) {
					GIACPremDeposit premDep = premDepositList.get(i);
					if (premDep.getLineCd() != null && premDep.getSublineCd() != null && premDep.getIssCd() != null 
							&& premDep.getIssueYy() != null && premDep.getPolSeqNo() != null && premDep.getRenewNo() != null ) {
						premDepositList.get(i).setPolicyNo(premDep.getLineCd() + "-" + premDep.getSublineCd() + "-" + 
								premDep.getIssCd() + "-" + premDep.getIssueYy() + "-" + premDep.getPolSeqNo() + "-" + 
								premDep.getRenewNo());
					}
				}
				
				//global variables
				request.setAttribute("gaccTranId", gaccTranId);
				request.setAttribute("gaccBranchCd", gaccBranchCd);
				request.setAttribute("gaccFundCd", gfunFundCd);
				request.setAttribute("tranSource", tranSource);
				request.setAttribute("orFlag", orFlag);
				
				//blocks/objects
				request.setAttribute("premDepositList", premDepositList);
				request.setAttribute("accTrans", accTrans);
				
				//module/page variables
				request.setAttribute("cgCtrlTotalCollections", premDepositService.getTotalCollections(gaccTranId));
				request.setAttribute("dfltCurrencyCd", dfltCurrencyCd);
				request.setAttribute("dfltCurrencyDesc", dfltCurrencyDtl.get("currencyDesc"));
				request.setAttribute("dfltCurrencyRt", dfltCurrencyDtl.get("currencyRt"));
				request.setAttribute("dfltMainCurrencyCd", dfltCurrencyDtl.get("mainCurrencyCd"));
				request.setAttribute("generationType", params2.get("generationType"));
				
				//misc variables
				request.setAttribute("premDepositListSize", premDepositList == null ? 0 : premDepositList.size());
				request.setAttribute("giisCurrencyList", giisCurrencyList);
			
				//LOV's and other items
				//request.setAttribute("issueSourceList", helper.getList(LOVHelper.BRANCH_SOURCE_LISTING)); //replaced by john 11.7.2014
				String[] argsIssCd = {"GIACS026", USER.getUserId()};
				request.setAttribute("issueSourceList", helper.getList(LOVHelper.ACCTG_ISSUE_CD_LISTING, argsIssCd)); 
				request.setAttribute("transactionTypeList", helper.getList(LOVHelper.TRANSACTION_TYPE));
				
				//PAGE = "/pages/accounting/officialReceipt/subPages/directTransPremiumDeposit.jsp";
				PAGE = "/pages/accounting/officialReceipt/subPages/directTransPremDeposit.jsp";
			} else if ("executeIssCdTrigger".equals(ACTION)) {
				GIACPremDepositService premDepositService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				Map<String, Object> params2 = new HashMap<String, Object>();
				
				params2.put("b140IssCd", request.getParameter("b140IssCd"));
				params2.put("b140PremSeqNo", request.getParameter("b140PremSeqNo"));
				params2.put("instNo", request.getParameter("instNo"));
				params2.put("lineCd", request.getParameter("lineCd"));
				params2.put("sublineCd", request.getParameter("sublineCd"));
				params2.put("issCd", request.getParameter("issCd"));
				params2.put("issueYy", request.getParameter("issueYy"));
				params2.put("polSeqNo", request.getParameter("polSeqNo"));
				params2.put("renewNo", request.getParameter("renewNo"));
				
				params2 = premDepositService.getGIACAgingSOAPolicy(params2);
				
				params2.put("lineCd", params2.get("lineCd") == null ? "" : params2.get("lineCd"));
				params2.put("sublineCd", params2.get("sublineCd") == null ? "" : params2.get("sublineCd"));
				params2.put("issCd", params2.get("issCd") == null ? "" : params2.get("issCd"));
				params2.put("issueYy", params2.get("issueYy") == null ? "" : params2.get("issueYy"));
				params2.put("polSeqNo", params2.get("polSeqNo") == null ? "" : params2.get("polSeqNo"));
				params2.put("renewNo", params2.get("renewNo") == null ? "" : params2.get("renewNo"));
				
				log.info("Iss Cd Trigger:");
				log.info("B140 Iss Cd: " + params2.get("b140IssCd"));
				log.info("b140PremSeqNo: " + params2.get("b140PremSeqNo"));
				log.info("instNo: " + params2.get("instNo"));
				log.info("lineCd: " + params2.get("lineCd"));
				log.info("sublineCd: " + params2.get("sublineCd"));
				log.info("issCd: " + params2.get("issCd"));
				log.info("issueYy: " + params2.get("issueYy"));
				log.info("polSeqNo: " + params2.get("polSeqNo"));
				log.info("renewNo: " + params2.get("renewNo"));
				
				request.setAttribute("params2", params2);
				
				PAGE = "/pages/accounting/officialReceipt/subPages/ajaxPremDepUpdateFields.jsp";
			}  else if ("validateRiCd".equals(ACTION)) {
				GIACPremDepositService premDepositService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				Map<String, Object> params2 = new HashMap<String, Object>();
				
				params2.put("b140PremSeqNo", request.getParameter("b140PremSeqNo"));
				params2.put("assdNo", request.getParameter("assdNo"));
				params2.put("dspA150LineCd", request.getParameter("dspA150LineCd"));
				params2.put("riCd", request.getParameter("riCd"));
				params2.put("riName", request.getParameter("riNameNo"));
				params2.put("instNo", request.getParameter("instNo"));
				params2.put("lineCd", request.getParameter("lineCd"));
				params2.put("sublineCd", request.getParameter("sublineCd"));
				params2.put("issCd", request.getParameter("issCd"));
				params2.put("issueYy", request.getParameter("issueYy"));
				params2.put("polSeqNo", request.getParameter("polSeqNo"));
				params2.put("renewNo", request.getParameter("renewNo"));
				
				params2 = premDepositService.validateRiCd(params2);
				
				params2.put("assdNo", params2.get("assdNo") == null ? new String("") : params2.get("assdNo"));
				params2.put("dspA150LineCd", params2.get("dspA150LineCd") == null ? new String("") : params2.get("dspA150LineCd"));
				params2.put("riCd", params2.get("riCd") == null ? new String("") : params2.get("riCd"));
				params2.put("riName", params2.get("riName") == null ? new String("") : params2.get("riName"));
				params2.put("lineCd", params2.get("lineCd") == null ? new String("") : params2.get("lineCd"));
				params2.put("sublineCd", params2.get("sublineCd") == null ? new String("") : params2.get("sublineCd"));
				params2.put("issCd", params2.get("issCd") == null ? new String("") : params2.get("issCd"));
				params2.put("issueYy", params2.get("issueYy") == null ? new String("") : params2.get("issueYy"));
				params2.put("polSeqNo", params2.get("polSeqNo") == null ? new String("") : params2.get("polSeqNo"));
				params2.put("renewNo", params2.get("renewNo") == null ? new String("") : params2.get("renewNo"));
				params2.put("message", params2.get("message") == null ? new String("") : params2.get("message"));
				
				log.info("Validate Ri Cd:");
				log.info("b140PremSeqNo: " + params2.get("b140PremSeqNo"));
				log.info("instNo: " + params2.get("instNo"));
				log.info("assdNo: " + params2.get("assdNo"));
				log.info("dspA150LineCd: " + params2.get("dspA150LineCd"));
				log.info("riCd: " + params2.get("riCd"));
				log.info("riName: " + params2.get("riName"));
				log.info("lineCd: " + params2.get("lineCd"));
				log.info("sublineCd: " + params2.get("sublineCd"));
				log.info("issCd: " + params2.get("issCd"));
				log.info("issueYy: " + params2.get("issueYy"));
				log.info("polSeqNo: " + params2.get("polSeqNo"));
				log.info("renewNo: " + params2.get("renewNo"));
				log.info("message: " + params2.get("message"));
				
				request.setAttribute("params2", params2);
				
				PAGE = "/pages/accounting/officialReceipt/subPages/ajaxPremDepUpdateFields.jsp";
			}  else if ("validateTranType1".equals(ACTION)) {
				GIACPremDepositService premDepositService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				Map<String, Object> params2 = new HashMap<String, Object>();
				
				params2.put("b140IssCd", request.getParameter("b140IssCd"));
				params2.put("b140PremSeqNo", request.getParameter("b140PremSeqNo"));
				params2.put("instNo", request.getParameter("instNo"));
				params2.put("assdNo", request.getParameter("assdNo"));
				params2.put("drvAssuredName", request.getParameter("drvAssuredName"));
				params2.put("assuredName", request.getParameter("assuredName"));
				params2.put("dspA150LineCd", request.getParameter("dspA150LineCd"));
				params2.put("lineCd", request.getParameter("lineCd"));
				params2.put("sublineCd", request.getParameter("sublineCd"));
				params2.put("issCd", request.getParameter("issCd"));
				params2.put("issueYy", request.getParameter("issueYy"));
				params2.put("polSeqNo", request.getParameter("polSeqNo"));
				params2.put("renewNo", request.getParameter("renewNo"));
				
				params2 = premDepositService.validateTranType1(params2);
				
				params2.put("drvAssuredName", params2.get("drvAssuredName") == null ? new String("") : params2.get("drvAssuredName").toString().replaceAll("&", "&amp;"));
				params2.put("assuredName", params2.get("assuredName") == null ? new String("") : params2.get("assuredName").toString().replaceAll("&", "&amp;"));
				params2.put("dspA150LineCd", params2.get("dspA150LineCd") == null ? new String("") : params2.get("dspA150LineCd"));
				params2.put("lineCd", params2.get("lineCd") == null ? new String("") : params2.get("lineCd"));
				params2.put("sublineCd", params2.get("sublineCd") == null ? new String("") : params2.get("sublineCd"));
				params2.put("issCd", params2.get("issCd") == null ? new String("") : params2.get("issCd"));
				params2.put("issueYy", params2.get("issueYy") == null ? new String("") : params2.get("issueYy"));
				params2.put("polSeqNo", params2.get("polSeqNo") == null ? new String("") : params2.get("polSeqNo"));
				params2.put("renewNo", params2.get("renewNo") == null ? new String("") : params2.get("renewNo"));
				
				log.info("Validate Tran Type 1:");
				log.info("b140IssCd: " + params2.get("b140IssCd"));
				log.info("b140PremSeqNo: " + params2.get("b140PremSeqNo"));
				log.info("instNo: " + params2.get("instNo"));
				log.info("assdNo: " + params2.get("assdNo"));
				log.info("drvAssuredName: " + params2.get("drvAssuredName"));
				log.info("assuredName: " + params2.get("assuredName"));
				log.info("dspA150LineCd: " + params2.get("dspA150LineCd"));
				log.info("lineCd: " + params2.get("lineCd"));
				log.info("sublineCd: " + params2.get("sublineCd"));
				log.info("issCd: " + params2.get("issCd"));
				log.info("issueYy: " + params2.get("issueYy"));
				log.info("polSeqNo: " + params2.get("polSeqNo"));
				log.info("renewNo: " + params2.get("renewNo"));
				
				request.setAttribute("params2", params2);
				
				PAGE = "/pages/accounting/officialReceipt/subPages/ajaxPremDepUpdateFields.jsp";
			}  else if ("getParSeqNo2".equals(ACTION)) {
				GIACPremDepositService premDepositService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				Map<String, Object> params2 = FormInputUtil.getFormInputs(request);
				
				params2 = premDepositService.getParSeqNo2(params2);
				
				log.info("Get Par Seq No:");
				log.info("assdNo: " + params2.get("assdNo"));
				log.info("lineCd: " + params2.get("lineCd"));
				log.info("sublineCd: " + params2.get("sublineCd"));
				log.info("issCd: " + params2.get("issCd"));
				log.info("issueYy: " + params2.get("issueYy"));
				log.info("polSeqNo: " + params2.get("polSeqNo"));
				log.info("renewNo: " + params2.get("renewNo"));
				log.info("parLineCd: " + params2.get("parLineCd"));
				log.info("parIssCd: " + params2.get("parIssCd"));
				log.info("parYy: " + params2.get("parYy"));
				log.info("parSeqNo: " + params2.get("parSeqNo"));
				log.info("quoteSeqNo: " + params2.get("quoteSeqNo"));
				
				message = QueryParamGenerator.generateQueryParams(params2);
				
				PAGE = "/pages/genericMessage.jsp";
				//PAGE = "/pages/accounting/officialReceipt/subPages/ajaxPremDepUpdateFields.jsp";
			}  else if ("showB140IssCdListing".equals(ACTION)) {
								
				PAGE = "/pages/accounting/officialReceipt/pop-ups/showAgingSOADetails.jsp";
			}  else if ("getAgingSOAListing".equals(ACTION)) {
				GIACAgingSoaDetailService agingSoaDetailService = (GIACAgingSoaDetailService) APPLICATION_CONTEXT.getBean("giacAgingSoaDetailService");
				String keyword = request.getParameter("keyword");
				String issCd = request.getParameter("issCd");
				
				if (null==keyword) {
					keyword = "";
				}
				
				if (null!=issCd) {
					if ("".equals(issCd.trim())) {
						issCd = null;
					}
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = agingSoaDetailService.getAgingSoaDetails(keyword, issCd);
				searchResult.gotoPage(pageNo);
				
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchAgingSOADetailsAjaxResult.jsp";
			}  else if ("showRiListing".equals(ACTION)) {
								
				PAGE = "/pages/accounting/officialReceipt/pop-ups/showAgingRiSOADetails.jsp";
			}  else if ("getAgingRiSOAListing".equals(ACTION)) {
				GIACAgingRiSoaDetailsService agingRiSoaDetailService = (GIACAgingRiSoaDetailsService) APPLICATION_CONTEXT.getBean("giacAgingRiSoaDetailsService");
				String keyword = request.getParameter("keyword");
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = agingRiSoaDetailService.getAgingRiSoaDetails(keyword);
				searchResult.gotoPage(pageNo);
				
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchAgingRiSOADetailsAjaxResult.jsp";
			}  else if ("collectionDefaultAmount".equals(ACTION)) {
				GIACPremDepositService premDepositService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				Map<String, Object> params2 = FormInputUtil.getFormInputs(request);
				
				premDepositService.executeCollectionDefaultAmount(params2);
				
				message = QueryParamGenerator.generateQueryParams(params2);
				
				PAGE = "/pages/genericMessage.jsp";
			}	else if ("getParSeqNo".equals(ACTION)) {
				GIACPremDepositService premDepositService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				Map<String, Object> params2 = FormInputUtil.getFormInputs(request);
				
				premDepositService.getParSeqNo(params2);
				
				message = QueryParamGenerator.generateQueryParams(params2);
				
				PAGE = "/pages/genericMessage.jsp";
			}	else if ("validateTranType2".equals(ACTION)) {
				GIACPremDepositService premDepositService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				Map<String, Object> params2 = FormInputUtil.getFormInputs(request);
				
				premDepositService.validateTranType2(params2);
				
				message = QueryParamGenerator.generateQueryParams(params2);
				
				PAGE = "/pages/genericMessage.jsp";
			}	else if ("saveGIACPremDeposit".equals(ACTION)) {
				GIACPremDepositService premDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				List<GIACPremDeposit> giacPremDeps = null;
				List<Map<String, Object>> delGiacPremDeps = null;
				
				String[] itemNos = request.getParameterValues("gipdItemNo");
				String[] delItemNos = request.getParameterValues("deletedGipdItemNo");
				String moduleName = request.getParameter("moduleName") == null ? new String("") : request.getParameter("moduleName");
				String genType = request.getParameter("varItemGenType") == null ? new String("") : request.getParameter("varItemGenType");
				orFlag = request.getParameter("orFlag") == null ? new String("") : request.getParameter("orFlag");
				tranSource = request.getParameter("tranSource") == null ? new String("") : request.getParameter("tranSource");
				
				if (itemNos != null) {
					if (itemNos.length > 0) {
						giacPremDeps = this.prepareGIACPremDepositRecord(request, response, itemNos);
					}
				}
				
				log.info("del Item nos : " + ((delItemNos == null) ? "0" : delItemNos.length));
				if (delItemNos != null) {
					if (delItemNos.length > 0) {
						delGiacPremDeps = new ArrayList<Map<String, Object>>();
						String[] delGaccTranId = request.getParameterValues("deletedGipdGaccTranId");
						String[] delTransactionType = request.getParameterValues("deletedGipdTransactionType");
						for (int i = 0; i < delItemNos.length; i++) {
							Map<String, Object> params2 = new HashMap<String, Object>();
							
							params2.put("gaccTranId", delGaccTranId[i]);
							params2.put("itemNo", delItemNos[i]);
							params2.put("transactionType", delTransactionType[i]);
							
							delGiacPremDeps.add(params2);
						}
					}
				}
				
				log.info("Module name : " + moduleName);
				
				message = premDepService.saveGIACPremDeposit(giacPremDeps, delGiacPremDeps, gaccBranchCd, gfunFundCd, gaccTranId, 
													moduleName, genType, tranSource, orFlag, USER);
			} else if ("openSearchOldItemNo".equals(ACTION)) {
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchOldItemNo.jsp";
			} else if ("getOldItemNoListing".equals(ACTION)) {
				GIACPremDepositService premDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				String keyword = request.getParameter("keyword");
				String tranType = request.getParameter("transactionType");
				String controlModule = request.getParameter("controlModule");
				Integer transactionType = null;
				
				if (null==keyword) {
					keyword = "";
				}
				
				if (tranType == null) {
					transactionType = 0;
				} else if (tranType.isEmpty()) {
					transactionType = 0;
				} else {
					transactionType = Integer.parseInt(tranType);
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = premDepService.getOldItemNoList(transactionType, controlModule, pageNo, keyword, USER.getUserId());
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchOldItemNoAjaxResult.jsp";
			} else if ("getOldItemNoListingFor4".equals(ACTION)) {
				GIACPremDepositService premDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				String keyword = request.getParameter("keyword");
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = premDepService.getOldItemNoListFor4(pageNo, keyword);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchOldItemNoAjaxResult.jsp";
			} else if("checkGipdGipdFkConstraint".equals(ACTION)) {
				GIACPremDepositService premDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				Map<String, Object> params2 = FormInputUtil.getFormInputs(request);
				
				message = premDepService.checkGipdGipdFKConstraint(params2);
					
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showPremDepListing".equals(ACTION)){
				log.info("Loading Premium Deposit Table Grid...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIACPremDepTableGridMap");
				params.put("moduleId", request.getParameter("moduleId") == null ? "GIACS026" : request.getParameter("moduleId"));
				params.put("tranId", request.getParameter("gaccTranId") == null ? "" : request.getParameter("gaccTranId"));
				params.put("gfunFundCd", request.getParameter("gaccFundCd") == null ? "" : request.getParameter("gaccFundCd"));
				params.put("gibrBranchCd", request.getParameter("gaccBranchCd") == null ? "" : request.getParameter("gibrBranchCd"));
				Map<String, Object> premDepTableGrid = TableGridUtil.getTableGrid(request, params);
				/*log.info("a:"+request.getParameter("moduleId"));
				log.info("a:"+request.getParameter("gaccTranId"));
				log.info("a:"+request.getParameter("gaccFundCd"));
				log.info("a:"+request.getParameter("gaccBranchCd"));*/
				JSONObject json = new JSONObject(premDepTableGrid);
				
				GIACPremDepositService premDepositService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				
				Map<String, Object> params2 = new HashMap<String, Object>();
				List<GIACPremDeposit> premDepositList;// = premDepositService.getGIACPremDeposit(gaccTranId);
				GIACAccTrans accTrans = null;// = premDepositService.getGIACAcctrans(gaccTranId, gfunFundCd, gaccBranchCd);
				List<HashMap<String, Object>> giisCurrencyList = null;
				
				Integer dfltCurrencyCd = giacParamService.getParamValueN("CURRENCY_CD");
				Map<String, Object> dfltCurrencyDtl = premDepositService.getDefaultCurrency(dfltCurrencyCd == null ? 0 : dfltCurrencyCd);
				
				//retrieve records for this module
				params2.put("tranId", gaccTranId);
				params2.put("gfunFundCd", gfunFundCd);
				params2.put("gibrBranchCd", gaccBranchCd);
				
				params2 = premDepositService.getGIACPremDepositModuleRecords(params2);
				
				premDepositList = (List<GIACPremDeposit>) params2.get("GIACPremDepositList");
				for (GIACAccTrans giacAcctrans : (List<GIACAccTrans>) params2.get("GIACAcctrans")) {
					accTrans = giacAcctrans;
				}
				
				giisCurrencyList = (List<HashMap<String, Object>>) params2.get("GIISCurrencyList");
				
				//set policy no for each premium deposit
				for (int i = 0; i < premDepositList.size(); i++) {
					GIACPremDeposit premDep = premDepositList.get(i);
					if (premDep.getLineCd() != null && premDep.getSublineCd() != null && premDep.getIssCd() != null 
							&& premDep.getIssueYy() != null && premDep.getPolSeqNo() != null && premDep.getRenewNo() != null ) {
						premDepositList.get(i).setPolicyNo(premDep.getLineCd() + "-" + premDep.getSublineCd() + "-" + 
								premDep.getIssCd() + "-" + premDep.getIssueYy() + "-" + premDep.getPolSeqNo() + "-" + 
								premDep.getRenewNo());
					}
				}
				
				//global variables
				request.setAttribute("gaccTranId", gaccTranId);
				request.setAttribute("gaccBranchCd", gaccBranchCd);
				request.setAttribute("gaccFundCd", gfunFundCd);
				request.setAttribute("tranSource", tranSource);
				request.setAttribute("orFlag", orFlag);
				
				//blocks/objects
				request.setAttribute("premDepositList", premDepositList);
				request.setAttribute("accTrans", accTrans);
				
				//module/page variables
				request.setAttribute("cgCtrlTotalCollections", premDepositService.getTotalCollections(gaccTranId));
				request.setAttribute("dfltCurrencyCd", dfltCurrencyCd);
				request.setAttribute("dfltCurrencyDesc", dfltCurrencyDtl.get("currencyDesc"));
				request.setAttribute("dfltCurrencyRt", dfltCurrencyDtl.get("currencyRt"));
				request.setAttribute("dfltMainCurrencyCd", dfltCurrencyDtl.get("mainCurrencyCd"));
				request.setAttribute("generationType", params2.get("generationType"));
				
				//misc variables
				request.setAttribute("premDepositListSize", premDepositList == null ? 0 : premDepositList.size());
				request.setAttribute("giisCurrencyList", giisCurrencyList);
			
				//LOV's and other items
				//request.setAttribute("issueSourceList", helper.getList(LOVHelper.BRANCH_SOURCE_LISTING)); //replaced by john 11.7.2014
				String[] argsIssCd = {"GIACS026", USER.getUserId()};
				request.setAttribute("issueSourceList", helper.getList(LOVHelper.ACCTG_ISSUE_CD_LISTING, argsIssCd)); 
				request.setAttribute("transactionTypeList", helper.getList(LOVHelper.TRANSACTION_TYPE));
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("gaccTranId", gaccTranId);
					request.setAttribute("gaccBranchCd", gaccBranchCd);
					request.setAttribute("gaccFundCd", gfunFundCd);
					request.setAttribute("tranSource", tranSource);
					request.setAttribute("orFlag", orFlag);
					request.setAttribute("premDepTableGridListing", json);
					
					//marco - 09.26.2014
					GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT.getBean("giacUserFunctionsService");
					Map<String, Object> funcParams =  new HashMap<String, Object>();
					funcParams.put("userId", USER.getUserId());
					funcParams.put("functionCd", "PD");
					funcParams.put("moduleName", "GIACS026");
					request.setAttribute("hasPremDepTran34", giacUserFunctionsService.checkIfUserHasFunction3(funcParams));
					request.setAttribute("requirePremDepIntm", giacParamService.getParamValueV2("REQUIRE_PREM_DEP_INTM"));
					
					PAGE = "/pages/accounting/officialReceipt/subPages/directTransPremDeposit.jsp";
				}
			}else if ("saveGIACPremDep".equals(ACTION)){
				GIACPremDepositService giacPremDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("gaccTranId", request.getParameter("globalGaccTranId"));
				params.put("gaccBranchCd", request.getParameter("globalGaccBranchCd"));
				params.put("gaccFundCd", request.getParameter("globalGaccFundCd"));
				params.put("genType", request.getParameter("genType"));
				params.put("orFlag", request.getParameter("orFlag"));
				params.put("tranSource", request.getParameter("tranSource"));
				message = giacPremDepService.saveGIACPremDep(params, request.getParameter("parameters"),USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}
			//added by kenneth for print premium deposit 06.25.2013
			else if("showPremiumDeposit".equals(ACTION)){
				GIACPremDepositService giacPremDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				Map<String, Object> lastExtractInfo = giacPremDepService.getLastExtractParams(USER.getUserId());
				request.setAttribute("lastExtractInfo", lastExtractInfo);
				PAGE = "/pages/accounting/cashReceipts/reports/premiumDeposit/premiumDeposit.jsp";
			}else if("extractPremiumDeposit".equals(ACTION)){
				GIACPremDepositService giacPremDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				message = giacPremDepService.extractPremDeposit(USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractWidNoReversal".equals(ACTION)){
				GIACPremDepositService giacPremDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				message = giacPremDepService.extractWidNoReversal(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractWidReversal".equals(ACTION)){
				GIACPremDepositService giacPremDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				message = giacPremDepService.extractWidReversal(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkLastExtract".equals(ACTION)){
				GIACPremDepositService giacPremDepService = (GIACPremDepositService) APPLICATION_CONTEXT.getBean("giacPremDepositService");
				JSONObject lastExtract = new JSONObject (giacPremDepService.getLastExtractParams(USER.getUserId()));
				message = lastExtract.toString();
				PAGE = "/pages/genericMessage.jsp";
			}
			//end kenneth for print premium deposit 06.25.2013
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

	private List<GIACPremDeposit> prepareGIACPremDepositRecord(HttpServletRequest request, 
			HttpServletResponse response, String[] itemNos) throws ServletException, ParseException {
		List<GIACPremDeposit> giacPremDeps = new ArrayList<GIACPremDeposit>();
		
		String[] fields = {"GaccTranId", "TransactionType", "CollectionAmt", "DepFlag", "AssdNo",
						   "RiCd", "B140PremSeqNo", "InstNo", "OldTranId", "OldItemNo", "OldTranType",
						   "IssueYy", "PolSeqNo", "RenewNo", "ParSeqNo", "ParYy", "QuoteSeqNo", "CurrencyCd",
						   "ConvertRate", "ForeignCurrAmt", "B140IssCd", "LineCd", "SublineCd", "IssCd",
						   "AssuredName", "Remarks", "CollnDt", "OrPrintTag", "OrTag", "IntmNo", "CommRecNo", "Changed"};
		String[][] values = new String[itemNos.length][fields.length];
		
		for (int i = 0; i < fields.length; i++) {
			log.info("gipd"+fields[i]+":");
			String[] val = request.getParameterValues("gipd"+fields[i]);
			for (int j = 0; j < val.length; j++) {
				values[j][i] = val[j];
			}
		}
		
		for (int i = 0; i < itemNos.length; i++) {
			if (Integer.parseInt(itemNos[i]) <= 0 || values[i][31].equals("N")) {
				continue;
			}
			
			GIACPremDeposit giacPremDep = new GIACPremDeposit();
			
			giacPremDep.setGaccTranId(Integer.parseInt(values[i][0]));
			giacPremDep.setItemNo(Integer.parseInt(itemNos[i]));
			giacPremDep.setTransactionType(Integer.parseInt(values[i][1]));
			giacPremDep.setCollectionAmt(values[i][2].trim().equals("") ? null : new BigDecimal(values[i][2]));
			giacPremDep.setDepFlag(values[i][3]);
			giacPremDep.setAssdNo(values[i][4].trim().equals("") ? null : Integer.parseInt(values[i][4]));
			giacPremDep.setRiCd(values[i][5].trim().equals("") ? null : Integer.parseInt(values[i][5]));
			giacPremDep.setB140PremSeqNo(values[i][6].trim().equals("") ? null : Integer.parseInt(values[i][6]));
			giacPremDep.setInstNo(values[i][7].trim().equals("") ? null : Integer.parseInt(values[i][7]));
			giacPremDep.setOldTranId(values[i][8].trim().equals("") ? null : Integer.parseInt(values[i][8]));
			giacPremDep.setOldItemNo(values[i][9].trim().equals("") ? null : Integer.parseInt(values[i][9]));
			giacPremDep.setOldTranType(values[i][10].trim().equals("") ? null : Integer.parseInt(values[i][10]));
			giacPremDep.setIssueYy(values[i][11].trim().equals("") ? null : Integer.parseInt(values[i][11]));
			giacPremDep.setPolSeqNo(values[i][12].trim().equals("") ? null : Integer.parseInt(values[i][12]));
			giacPremDep.setRenewNo(values[i][13].trim().equals("") ? null : Integer.parseInt(values[i][13]));
			giacPremDep.setParSeqNo(values[i][14].trim().equals("") ? null : Integer.parseInt(values[i][14]));
			giacPremDep.setParYy(values[i][15].trim().equals("") ? null : Integer.parseInt(values[i][15]));
			giacPremDep.setQuoteSeqNo(values[i][16].trim().equals("") ? null : Integer.parseInt(values[i][16]));
			giacPremDep.setCurrencyCd(values[i][17].trim().equals("") ? null : Integer.parseInt(values[i][17]));
			giacPremDep.setConvertRate(values[i][18].trim().equals("") ? null : new BigDecimal(values[i][18]));
			giacPremDep.setForeignCurrAmt(values[i][19].trim().equals("") ? null : new BigDecimal(values[i][19]));
			giacPremDep.setB140IssCd(values[i][20]);
			giacPremDep.setLineCd(values[i][21]);
			giacPremDep.setSublineCd(values[i][22]);
			giacPremDep.setIssCd(values[i][23]);
			giacPremDep.setAssuredName(values[i][24]);
			giacPremDep.setRemarks(values[i][25]);
			giacPremDep.setCollnDt(values[i][26].trim().equals("") ? null : new SimpleDateFormat("MM-dd-yyyy").parse(values[i][26]));
			giacPremDep.setOrPrintTag(values[i][27]);
			giacPremDep.setOrTag(values[i][28]);
			giacPremDep.setIntmNo(values[i][29].trim().equals("") ? null : Integer.parseInt(values[i][29]));
			giacPremDep.setCommRecNo(values[i][30].trim().equals("") ? null : Integer.parseInt(values[i][30]));
			
			giacPremDeps.add(giacPremDep);
		}
		
		return giacPremDeps;
	}
}
