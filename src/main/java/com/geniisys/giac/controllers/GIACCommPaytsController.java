package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
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
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.giac.entity.GIACCommPayts;
import com.geniisys.giac.service.GIACCommPaytsService;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gipi.service.GIPIWCommInvoiceService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACCommPaytsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The log */
	private static Logger log = Logger.getLogger(GIACCommPaytsController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings({ "deprecation" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		PAGE = "/pages/genericMessage.jsp";
		
		Integer gaccTranId = (request.getParameter("gaccTranId") == null || request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals("null")) ? 0 : Integer.parseInt(request.getParameter("gaccTranId"));
		//Integer gaccTranId = 54027;
		
		log.info("Gacc Tran Id: " + gaccTranId);
		
		try {
			if ("showCommPayts".equals(ACTION)) {
				// Service(s)
				
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				GIACModulesService giacModuleService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				
				// Objects
				List<GIACCommPayts> commPaytsList = commPaytsService.getGIACCommPayts(gaccTranId);
				BigDecimal sumCommAmt = new BigDecimal(0);
				BigDecimal sumInpVat = new BigDecimal(0);
				BigDecimal sumWtaxAmt = new BigDecimal(0);
				BigDecimal sumNetCommAmt = new BigDecimal(0);
				
				for (GIACCommPayts commPayts : commPaytsList) {
					if (commPayts.getCommAmt() != null) {
						sumCommAmt = sumCommAmt.add(commPayts.getCommAmt());
					}
					
					if (commPayts.getInputVATAmt() != null) {
						sumInpVat = sumInpVat.add(commPayts.getInputVATAmt());
					}
					
					if (commPayts.getWtaxAmt() != null) {
						sumWtaxAmt = sumWtaxAmt.add(commPayts.getWtaxAmt());
					}
				}
				
				sumNetCommAmt = sumCommAmt.add(sumInpVat.subtract(sumWtaxAmt));
				
				log.info("Sum Comm Amt : " + sumCommAmt);
				log.info("Sum Inp Vat : " + sumInpVat);
				log.info("Sum Wtax Amt : " + sumWtaxAmt);
				log.info("Sum Net Comm Amt : " + sumNetCommAmt);
				
				// other variables
				log.info("Loading GIACS020 details..");
				log.info("Tran Id: " + gaccTranId);
				log.info("User: " + USER.getUserId());
				Map<String, Object> params = commPaytsService.getGiacs020BasicVarValues(gaccTranId, USER.getUserId());
				
				/** set page attributes */
				
				// blocks
				request.setAttribute("commPaytsList", commPaytsList);
				
				// misc
				request.setAttribute("commPaytsListSize", commPaytsList.size());
				
				// module block values
				request.setAttribute("sumCommAmt", sumCommAmt);
				request.setAttribute("sumInpVat", sumInpVat);
				request.setAttribute("sumWtaxAmt", sumWtaxAmt);
				request.setAttribute("controlSumNetCommAmt", sumNetCommAmt);
				request.setAttribute("varCommPayableParam", params.get("commPayableParam"));
				request.setAttribute("varAssdNo", params.get("varAssdNo"));
				request.setAttribute("varIntmNo", params.get("varIntmNo"));
				request.setAttribute("varItemNo", params.get("varItemNo"));
				request.setAttribute("varItemNo2", params.get("varItemNo2"));
				request.setAttribute("varItemNo3", params.get("varItemNo3"));
				request.setAttribute("varLineCd", params.get("varLineCd"));
				request.setAttribute("varModuleId", params.get("varModuleId"));
				request.setAttribute("varGenType", params.get("varGenType"));
				request.setAttribute("varSlTypeCd1", params.get("varSlTypeCd1"));
				request.setAttribute("varSlTypeCd2", params.get("varSlTypeCd2"));
				request.setAttribute("varSlTypeCd3", params.get("varSlTypeCd3"));
				request.setAttribute("varInputVATParam", params.get("varInputVATParam"));
				request.setAttribute("tranSourceCommTag", params.get("tranSourceCommTag"));
				request.setAttribute("issCdLOV", params.get("issCdLOV"));
				request.setAttribute("tranTypeLOV", params.get("tranTypeLOV"));
				request.setAttribute("isUserValid", params.get("isUserExist")); // used to check if the current user has the authority to approve a JV (emman 06.14.2011 - from VALIDATE_USER function in GIACS020)
				
				Map<String, Object> userParams = new HashMap<String, Object>(); 
				userParams.put("user", USER.getUserId());
				userParams.put("moduleName", "GIACS020");
				userParams.put("funcCode", "AU");
				String accessAU = giacModuleService.validateUserFunc3(userParams);                
				userParams.put("funcCode", "MC");
				String accessMC = giacModuleService.validateUserFunc3(userParams);
				request.setAttribute("noPremPayt", giacParamService.getParamValueV2("NO_PREM_PAYT"));
				request.setAttribute("accessAU", accessAU);
				request.setAttribute("accessMC", accessMC);

				PAGE = "/pages/accounting/officialReceipt/subPages/directTransCommPayts.jsp";
			} else if ("getGipiCommInvoice".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				String issCd = request.getParameter("issCd");
				String premSeqNo = request.getParameter("premSeqNo");
				String intmNo = request.getParameter("intmNo");
				String convertRate = request.getParameter("convertRate");
				String currencyCd = request.getParameter("currencyCd");
				String iCommAmt = request.getParameter("iCommAmt");
				String iWtax = request.getParameter("iWtax");
				String currDesc = request.getParameter("currDesc");
				String defFgnCurr = request.getParameter("defFgnCurr");
				
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("issCd", issCd);
				params.put("premSeqNo", premSeqNo);
				params.put("intmNo", intmNo);
				params.put("convertRate", convertRate);
				params.put("currencyCd", currencyCd);
				params.put("iCommAmt", iCommAmt);
				params.put("iWtax", iWtax);
				params.put("currDesc", currDesc);
				params.put("defFgnCurr", defFgnCurr);
				
				/*
				Map<String, Object> test = request.getParameterMap();
				Iterator iter = test.entrySet().iterator();
				
				log.info("test..");
				while(iter.hasNext()) {
					Map.Entry<String, Object> entry = (Map.Entry<String, Object>)iter.next();
					log.info(entry.getKey() + ": " + entry.getValue() == null ? null : entry.getValue().toString());
				}*/
				
				params = commPaytsService.getGIPICommInvoice(params);
				System.out.println("GIACCommPaytsController getGipiCommInvoice: "+params);
				/*Iterator<String> i = params.keySet().iterator();
				message = "";
				
				while (i.hasNext()) {
					Object item = i.next().toString();
					message = message.concat(item+"="+params.get(item));
					
					if (i.hasNext()) {
						message = message.concat("&");
					}
				}*/
				//request.setAttribute("params", params);
				//PAGE = "/pages/accounting/officialReceipt/subPages/ajaxCommPaytsUpdateFields.jsp";
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if ("showBillNoDetails".equals(ACTION)) {
				
				PAGE = "/pages/pop-ups/showCommPaytsBillNoDetails.jsp";
			} else if ("getBillNoListing".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Integer tranType = ("".equals(request.getParameter("tranType").trim())) ? new Integer(0) : new Integer(request.getParameter("tranType"));
				String issCd = request.getParameter("issCd");
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
				
				searchResult = commPaytsService.getBillNoList(pageNo, tranType, issCd, gaccTranId, keyword);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/pop-ups/searchCommPaytsBillNoAjaxResult.jsp";
			} else if ("showGcopInvDetails".equals(ACTION)) {
				
				PAGE = "/pages/pop-ups/showGcopInvDetails.jsp";
			} else if ("getGcopInvListing".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				params.put("notIn", params.get("notIn").toString().equals("--") ? null : params.get("notIn"));
				log.info("Tran Type: " + params.get("tranType"));
				log.info("Iss Cd: " + params.get("issCd"));
				log.info("Prem Seq No: " + params.get("premSeqNo"));
				log.info("Intm No: " + params.get("intmNo"));
				log.info("Intm Name: " + params.get("intmName"));
				log.info("Var V From Sums: " + params.get("varVFromSums"));
				log.info("Keyword: " + params.get("keyword"));
				log.info("notIn: " + params.get("notIn"));	// shan 09.18.2014
				log.info("onLOV: " + params.get("onLOV"));	// shan 10.16.2014
				
				searchResult = commPaytsService.getGcopInv(pageNo, params);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/pop-ups/searchGcopInvAjaxResult.jsp";
			} else if ("validatePremSeqNo".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				String premSeqNo = request.getParameter("premSeqNo");
				String issCd = request.getParameter("issCd");
				
				message = commPaytsService.chkModifiedComm(premSeqNo, issCd);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getIntermediary".equals(ACTION)) {
			/*	GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				
				String tranType = request.getParameter("tranType");
				String issCd = request.getParameter("issCd");
				String premSeqNo = request.getParameter("premSeqNo");
				List<GIISIntermediary> intmList = intermediaryService.getGIPICommInvoiceIntmList(tranType, issCd, premSeqNo, "");
				String intmNo = new String("");
				String intmName = new String("");
				
				System.out.println("Tran Type: " + tranType);
				System.out.println("Iss Cd: " + issCd);
				System.out.println("Prem Seq No: " + premSeqNo);
				System.out.println("Intm Name: " + request.getParameter("intmName"));
				System.out.println("Size of List: " + ((intmList == null) ? "0" : intmList.size()));*/
				
				/*if (intmList != null) {
					if (intmList.size() > 0) {
						intmNo = intmList.get(0).getIntmNo().toString();
						intmName = intmList.get(0).getIntmName();
						
					}
				}*/ 
				// removed to accomodate multiple intermediaries with commission - irwin 8.2.2012
				
				//String intmNo = "";
			//	String intmName = "";
				Map<String, Object> result = new  HashMap<String, Object>();
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params  = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				List<Map<String, Object>> gcopInvList = commPaytsService.getGcopInvList(params);
				
				for (Map<String, Object> map : gcopInvList) {
					System.out.println(map.get("commAmt"));
					result.put("intmNo", map.get("intmNo"));
					result.put("intmName", map.get("intmName"));
					
					//added by jeffdojello 12.06.2013
					result.put("billNo",map.get("billNo"));  
					result.put("issCd",map.get("issCd"));  
					result.put("premSeqNo",map.get("premSeqNo"));  
					result.put("commAmt",map.get("commAmt"));  
					result.put("invatAmt",map.get("invatAmt"));  
					result.put("wtax",map.get("wtax"));  
					result.put("ncommAmt",map.get("ncommAmt"));  
					result.put("chkTagEnable",map.get("chkTagEnable"));  
					//------------------------------//
				}
				
				
				
				result.put("size", (gcopInvList == null) ? "0" : gcopInvList.size());
				//message = "intmNo=" + intmNo + "&" + "intmName=" + intmName;
				//message = QueryParamGenerator.generateQueryParams(result);
				request.setAttribute("object", new JSONObject(StringFormatter.replaceQuotesInMap(result)));
				log.info("getIntermediary param: " + result);
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateGIACS020IntmNo".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = new HashMap<String, Object>();
				String val;
				String[] fields = {"intmNo", "gaccTranId", "tranType", "issCd", "premSeqNo", "commTag", "defCommTagDisplayed",
						"commAmt", "wtaxAmt", "inputVATAmt", "defCommTag", "convertRate", "currencyCd", "currDesc",
						"foreignCurrAmt", "defWtaxAmt", "drvCommAmt", "defCommAmt", "defInputVAT",
						"dspPolicyId", "dspIntmName", "dspAssdNo", "dspAssdName", "dspLineCd", "varVATRt", "varClrRec",		
						"varVPolFlag", "varHasPremium", "varCPremiumAmt", "varInvPremAmt", "varOtherCharges",
						"varNotarialFee", "varPdPremAmt", "varPctPrem", "varCgDummy", "varCommPayableParam", "varMaxInputVAT", 		
						"varLastWtax", "varInvoiceButt", "varPrevCommAmt", "varPrevWtaxAmt", "varPrevInputVat", 		
						"varPTranType", "varPTranId", "varRCommAmt", "varICommAmt", "varPCommAmt", "varRWtax", 			
						"varFdrvCommAmt", "varDefFgnCurr", "varIWtax", "varPWtax", "varVarTranType", "varInputVATParam",
						"varCFireNow", "controlVCommAmt", "controlSumInpVAT", "controlVInputVAT", "controlSumCommAmt", 	
						"controlSumWtaxAmt", "controlVWtaxAmt", "controlSumNetCommAmt", "policyStatus", "gipiInvoiceExist",
						"invCommFullyPaid", "validCommAmt", "policyFullyPaid", "invalidTranType1or2", "invalidTranType3or4",
						"noTranType", "pdPrem", "policyOverride", "psPdPremAmt", "psTotPremAmt", "message", 
						"billGaccTranId"};	// added by shan 10.02.2014
				
				log.info("The values for intm no. validation:");
				for (int i = 0; i < fields.length; i++) {
					val = request.getParameter(fields[i]);
					//set to null first if no value
					if (val != null) {
						if ("".equals(val.trim())) {
							val = null;
						}
					}
					params.put(fields[i], val);
					log.info(fields[i]+": " + params.get(fields[i]));
				}
				
				params = commPaytsService.validateGIACS020IntmNo(params);
				// edited by d.alcantara, 12-28-2011, pass parameters as json
				/*System.out.println("After validation values..");
				message = new String("");
				for (int i = 0; i < fields.length; i++) {
					val =  (String) params.get(fields[i]);
					//set to blank string first if null
					if (val == null) {
						val = new String("");
					}
					
					System.out.println("validateGIACS020IntmNo output - "+fields[i]+": " + val);
					message = message + fields[i]+ "=" + val + "&";
				}*/
				
				/*message = message + "policyStatus=" + params.get("policyStatus") + "&pdPrem=" + params.get("pdPrem") +
							"&gipiInvoiceExist=" + params.get("gipiInvoiceExist") + "&invCommFullyPaid=" +
							params.get("invCommFullyPaid") + "&validCommAmt=" + params.get("validCommAmt") +
							"&policyFullyPaid=" + params.get("policyFullyPaid") + "&invalidTranType1or2=" +
							params.get("invalidTranType1or2") + "&invalidTranType3or4=" + params.get("invalidTranType3or4") +
							"&noTranType=" + params.get("noTranType") + "&policyOverride=" + params.get("policyOverride") +
							"&psPdPremAmt=" + params.get("psPdPremAmt") + "&psTotPremAmt=" + params.get("psTotPremAmt") + 
							"&message=" + params.get("message");*/
				//message = QueryParamGenerator.generateQueryParams(params);
				//log.info("validateGIACS020IntmNo::: "+message);
				
				// added to allow tagging if NO_PREM_PAYT = N and user has AU function under GIACS020 : shan 09.11.2014 
				GIPIWCommInvoiceService commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				GIACModulesService giacModuleService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				String noPremPayt = commInvoiceService.getAccountingParameter("NO_PREM_PAYT");
				Map<String, Object> userParams = new HashMap<String, Object>(); 
				userParams.put("user", USER.getUserId());
				userParams.put("moduleName", "GIACS020");
				userParams.put("funcCode", "AU");
				String accessAU = giacModuleService.validateUserFunc3(userParams);
				userParams.put("funcCode", "MC");
				String accessMC = giacModuleService.validateUserFunc3(userParams);
				
				params.put("noPremPayt", noPremPayt);
				params.put("accessAU", accessAU);				
				params.put("accessMC", accessMC);
				// end 09.11.2014
				request.setAttribute("object", new JSONObject(StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs020Param2MgmtComp".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				params = commPaytsService.commPaytsParam2MgmtComp(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				log.info(message);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giacs020IntmNoPostText".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				params = commPaytsService.commPaytsIntmNoPostText(params);				
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				log.info(message);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getCommPaytsDefPremPct".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				params = commPaytsService.getCommPaytsDefPremPct(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				log.info(message);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giacs020CompSummary".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				params = commPaytsService.commPaytsCompSummary(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				log.info(message);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("preInsertGIACS020CommPayts".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				params = commPaytsService.preInsertGiacs020CommPayts(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				log.info(message);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGIACCommPayts".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");;
				List<GIACCommPayts> giacCommPayts = this.prepareGIACCommPaytsRecords(request, response);
				List<GIACCommPayts> delGiacCommPayts = this.prepareDeletedGIACCommPaytsRecords(request, response);
				Map<String, Object> params = new HashMap<String, Object>();
				
				log.info("global gacc tran id: " + request.getParameter("giacs020GaccTranId"));
				log.info("global tran source: " + request.getParameter("giacs020TranSource"));
				log.info("global gacc fund cd: " + request.getParameter("giacs020FundCd"));
				log.info("global gacc branch cd: " + request.getParameter("giacs020BranchCd"));
				log.info("global or flag: " + request.getParameter("giacs020OrFlag"));
				
				log.info("varModuleName: " + request.getParameter("varModuleName"));
				
				params.put("appUser", USER.getUserId());
				params.put("globalTranSource", request.getParameter("giacs020TranSource"));
				params.put("globalOrFlag", request.getParameter("giacs020OrFlag"));
				params.put("gaccBranchCd", request.getParameter("giacs020BranchCd"));
				params.put("gaccFundCd", request.getParameter("giacs020FundCd"));
				params.put("gaccTranId", request.getParameter("giacs020GaccTranId"));
				params.put("varModuleName", request.getParameter("varModuleName"));
				params.put("varModuleId", request.getParameter("varModuleId"));
				params.put("varGenType", request.getParameter("varGenType"));
				params.put("varCommTakeUp", request.getParameter("varCommTakeUp"));
				params.put("varVItemNum", request.getParameter("varVItemNum"));
				params.put("varVBillNo", request.getParameter("varVBillNo"));
				params.put("varVIssueCd", request.getParameter("varVIssueCd"));
				params.put("varSlTypeCd1", request.getParameter("varSlTypeCd1"));
				params.put("varSlTypeCd2", request.getParameter("varSlTypeCd2"));
				params.put("varSlTypeCd3", request.getParameter("varSlTypeCd3"));
				
				params = commPaytsService.saveGIACCommPayts(giacCommPayts, delGiacCommPayts, params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkGcopInvChkTag".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				params = commPaytsService.checkGcopInvChkTag(params);
				
				// added to allow tagging if NO_PREM_PAYT = N and user has AU function under GIACS020 : shan 09.11.2014 
				GIPIWCommInvoiceService commInvoiceService = (GIPIWCommInvoiceService) APPLICATION_CONTEXT.getBean("gipiWCommInvoiceService");
				GIACModulesService giacModuleService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				String noPremPayt = commInvoiceService.getAccountingParameter("NO_PREM_PAYT");
				Map<String, Object> userParams = new HashMap<String, Object>(); 
				userParams.put("user", USER.getUserId());
				userParams.put("moduleName", "GIACS020");
				userParams.put("funcCode", "AU");
				String accessAU = giacModuleService.validateUserFunc3(userParams);				
				userParams.put("funcCode", "MC");
				String accessMC = giacModuleService.validateUserFunc3(userParams);
				
				params.put("noPremPayt", noPremPayt);
				params.put("accessAU", accessAU);
				params.put("accessMC", accessMC);
				// end 09.11.2014
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				log.info(message);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("executeGIACS020DeleteRecord".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				Integer premSeqNo = params.get("premSeqNo") == null ? null : Integer.parseInt(params.get("premSeqNo").toString());
				Integer intmNo = params.get("intmNo") == null ? null : Integer.parseInt(params.get("intmNo").toString());
				BigDecimal commAmt = params.get("commAmt") == null ? null : new BigDecimal(params.get("commAmt").toString());
				
				params.put("premSeqNo", premSeqNo);
				params.put("intmNo", intmNo);
				params.put("commAmt", commAmt);
				
				message = commPaytsService.executeGIACS020DeleteRecord(params);
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("showModifiedCommissions".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/modifiedCommisions/modifiedCommissions.jsp";
			}else if ("checkRelCommWUnprintedOr".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				message = commPaytsService.checkRelCommWUnprintedOr(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getGcopInvDetails".equals(ACTION)) {	// shan 10.24.2014
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				
				params.put("notIn", params.get("notIn").toString().equals("--") ? null : params.get("notIn"));
				log.info("Tran Type: " + params.get("tranType"));
				log.info("Iss Cd: " + params.get("issCd"));
				log.info("Prem Seq No: " + params.get("premSeqNo"));
				log.info("Intm No: " + params.get("intmNo"));
				log.info("Intm Name: " + params.get("intmName"));
				log.info("Var V From Sums: " + params.get("varVFromSums"));
				log.info("Keyword: " + params.get("keyword"));
				log.info("notIn: " + params.get("notIn"));
				log.info("onLOV: " + params.get("onLOV"));
				log.info("getNoPremPayt: " + params.get("getNoPremPayt"));
				
				List<Map<String, Object>> searchResult = commPaytsService.getGcopInvDetails(params);
				JSONObject json = new JSONObject();
				if (searchResult.size() == 1){
					json.put("message", "SUCCESS");
					json.put("row", searchResult);
				}else if (searchResult.size() > 1){
					json.put("message", "showLOV");
				}else{
					json.put("message", "noRecord");
				}
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("param2FullPremPayt".equals(ACTION)) {
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				params = commPaytsService.getParam2FullPremPayt(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				log.info(message);
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIACS020BillNo".equals(ACTION)){	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				message = commPaytsService.validateGIACS020BillNo(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkingIfPaidOrUnpaid".equals(ACTION)) { //SR20909 :: john 11.9.2015
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				commPaytsService.checkingIfPaidOrUnpaid(request, USER.getUserId());
				//message = "SUCCESS"; //Commented out and replaced by code below - Jerome Bautista 03.04.2016 SR 21279
				message = commPaytsService.checkingIfPaidOrUnpaid(request, USER.getUserId()).toString(); 
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkCommPaytStatus".equals(ACTION)){
				GIACCommPaytsService commPaytsService = (GIACCommPaytsService) APPLICATION_CONTEXT.getBean("giacCommPaytsService");
				commPaytsService.checkCommPaytStatus(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

	private List<GIACCommPayts> prepareGIACCommPaytsRecords(HttpServletRequest request, 
			HttpServletResponse response) throws ServletException {
		List<GIACCommPayts> commPaytsList = null;
		Integer count = request.getParameterValues("gcopChanged") == null ? 0 : request.getParameterValues("gcopChanged").length;
		
		if (count == 0) {
			return null;
		}
		
		String[] fields = {"gcopChanged", "gcopGaccTranId", "gcopTranType", "gcopIssCd", "gcopPremSeqNo", "gcopIntmNo",
							"gcopCommAmt", "gcopInputVATAmt", "gcopWtaxAmt", "gcopPrintTag",
							"gcopDefCommTag", "gcopParticulars", "gcopCurrencyCd", "gcopConvertRate",
							"gcopForeignCurrAmt", "gcopParentIntmNo", "gcopCommTag", "gcopRecordNo", "gcopDisbComm", "gcopRecordSeqNo"}; //robert SR 19752 07.28.15 
		
		String[][] values = new String[count][fields.length];
		
		commPaytsList =  new ArrayList<GIACCommPayts>();
		
		log.info("Preparing giac comm payts records for saving...");
		for (int i = 0; i < fields.length; i++) {
			String[] val = request.getParameterValues(fields[i]);
			for (int j = 0; j < val.length; j++) {
				log.info("value: " + val[j]);
				values[j][i] = val[j];
			}
		}
		
		for (int i = 0; i < count; i++) {
			if ("N".equals(values[i][0])) {
				continue;
			}
			
			GIACCommPayts commPayts = new GIACCommPayts();
			
			commPayts.setGaccTranId(Integer.parseInt(values[i][1]));
			commPayts.setTranType(Integer.parseInt(values[i][2]));
			commPayts.setIssCd(values[i][3]);
			commPayts.setPremSeqNo(Integer.parseInt(values[i][4]));
			commPayts.setIntmNo(Integer.parseInt(values[i][5]));
			commPayts.setCommAmt(new BigDecimal(values[i][6].toString().trim().replaceAll(",", ""))); // andrew - 05.10.2011 - added toString and replaceAll
			commPayts.setInputVATAmt(new BigDecimal(values[i][7].toString().trim().replaceAll(",", "")));
			commPayts.setWtaxAmt(new BigDecimal(values[i][8].toString().trim().replaceAll(",", "")));
			commPayts.setPrintTag(values[i][9]);
			commPayts.setDefCommTag(values[i][10]);
			commPayts.setParticulars(values[i][11]);
			commPayts.setCurrencyCd(("".equals(values[i][12].trim())) ? null : Integer.parseInt(values[i][12]));
			commPayts.setConvertRate(("".equals(values[i][13].trim())) ? null : new BigDecimal(values[i][13].toString().trim().replaceAll(",", "")));
			commPayts.setForeignCurrAmt(("".equals(values[i][14].trim())) ? null : new BigDecimal(values[i][14].toString().trim().replaceAll(",", "")));
			commPayts.setParentIntmNo(Integer.parseInt(values[i][15]));
			commPayts.setCommTag(values[i][16]);
			commPayts.setRecordNo(Integer.parseInt(values[i][17]));
			commPayts.setDisbComm(("".equals(values[i][18].trim())) ? null : new BigDecimal(values[i][18].toString().trim().replaceAll(",", "")));
			commPayts.setRecordSeqNo((values[i][19] == null || "".equals(values[i][19].trim())) ? null : Integer.parseInt(values[i][19]) ); //robert SR 19752 07.28.15 
			commPaytsList.add(commPayts);
		}
		
		return commPaytsList;
	}
	
	private List<GIACCommPayts> prepareDeletedGIACCommPaytsRecords(HttpServletRequest request, 
			HttpServletResponse response) throws ServletException {
		List<GIACCommPayts> commPaytsList = null;
		Integer count = request.getParameterValues("deletedGcopGaccTranId") == null ? 0 : request.getParameterValues("deletedGcopGaccTranId").length;
		
		if (count == 0) {
			return null;
		}
		
		String[] fields = {"deletedGcopGaccTranId", "deletedGcopIntmNo", "deletedGcopIssCd", "deletedGcopPremSeqNo", "deletedCommTag", "deletedRecordNo", "deletedRecordSeqNo"}; //robert SR 19752 07.28.15 
		
		String[][] values = new String[count][fields.length];
		
		commPaytsList =  new ArrayList<GIACCommPayts>();
		
		log.info("Preparing giac comm payts records for deletion...");
		for (int i = 0; i < fields.length; i++) {
			String[] val = request.getParameterValues(fields[i]);
			for (int j = 0; j < val.length; j++) {
				values[j][i] = val[j];
			}
		}
		
		for (int i = 0; i < count; i++) {
			GIACCommPayts commPayts = new GIACCommPayts();
			
			log.info("amf " + i + ": " + values[i][0]);
			commPayts.setGaccTranId(Integer.parseInt(values[i][0]));
			commPayts.setIntmNo(Integer.parseInt(values[i][1]));
			commPayts.setIssCd(values[i][2]);
			commPayts.setPremSeqNo(Integer.parseInt(values[i][3]));
			commPayts.setCommTag(values[i][4]); //robert SR 19752 07.28.15 
			commPayts.setRecordNo(Integer.parseInt(values[i][5])); //robert SR 19752 07.28.15 
			commPayts.setRecordSeqNo(Integer.parseInt(values[i][6])); //robert SR 19752 07.28.15 
			commPaytsList.add(commPayts);
		}
		
		return commPaytsList;
	}
}
