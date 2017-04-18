/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.common.entity.GIISParameter;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISIntermediaryService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.JSONArrayList;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACAccTrans;
import com.geniisys.giac.entity.GIACBranch;
import com.geniisys.giac.entity.GIACCollectionDtl;
import com.geniisys.giac.entity.GIACCollnBatch;
import com.geniisys.giac.entity.GIACDCBUser;
import com.geniisys.giac.entity.GIACOrRel;
import com.geniisys.giac.entity.GIACOrderOfPayment;
import com.geniisys.giac.entity.GIACTranMm;
import com.geniisys.giac.service.GIACAccTransService;
import com.geniisys.giac.service.GIACApdcPaytDtlService;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.giac.service.GIACCollectionDtlService;
import com.geniisys.giac.service.GIACCollnBatchService;
import com.geniisys.giac.service.GIACDCBUserService;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giac.service.GIACOrderOfPaymentService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACTranMmService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIACOrderOfPaymentController.
 */
public class GIACOrderOfPaymentController extends BaseController{
	
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACOrderOfPaymentController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		
		try {
			/*default attributes*/
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			Integer gaccTranId=0;
			//String 	gaccBranchCd 	= new String("");
			//String 	gfunFundCd 		= new String("");
			
			//gaccTranId = 53480;
			//gfunFundCd = "AUI";
			//gaccBranchCd = "HO";
			
			GIISParameterFacadeService paramService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
			GIACOrderOfPaymentService giacOrderOfPaymentService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
			if ("createORInformation".equals(ACTION)){
				/* Define Services needed */
				GIACBranchService branchDetailService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				GIACCollnBatchService dcbDetailService = (GIACCollnBatchService) APPLICATION_CONTEXT.getBean("giacCollnService");
				GIISIntermediaryService payorDetailService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				GIACDCBUserService cashierDetailService = (GIACDCBUserService) APPLICATION_CONTEXT.getBean("giacDCBUserService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIISUserFacadeService checkUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				GIACTranMmService giacTranMmService = (GIACTranMmService) APPLICATION_CONTEXT.getBean("giacTranMmService");
				GIACApdcPaytDtlService apdcDtlService = (GIACApdcPaytDtlService) APPLICATION_CONTEXT.getBean("giacApdcPaytDtlService");
				GIACDCBUserService dcbUserServ = (GIACDCBUserService) APPLICATION_CONTEXT.getBean("giacDCBUserService"); // added by Kris 01.30.2013
				
				String pBranchCd = "".equals(request.getParameter("branchCd")) ? USER.getIssCd() : request.getParameter("branchCd");
								
				request.setAttribute("gaccTranId", "0");
				String collnSourceName = giacParamService.getParamValueV2("COLLN_SOURCE_NAME");
				request.setAttribute("collnSourceName", collnSourceName);
				
				String fundCd = giacParamService.getParamValueV2("FUND_CD");
				request.setAttribute("fundCd", fundCd);
				
				Integer orAnteDateParam = giacParamService.getParamValueN("OR_ANTE_DATE_PARAM");
				request.setAttribute("orAnteDate", orAnteDateParam);
				
				request.setAttribute("uploadImplemSw", giacParamService.getParamValueV2("UPLOAD_IMPLEMENTATION_SW"));
				request.setAttribute("staleMgrChk", giacParamService.getParamValueN("STALE_MGR_CHK"));
				request.setAttribute("staleCheck", giacParamService.getParamValueN("STALE_CHECK"));
				request.setAttribute("staleDays", giacParamService.getParamValueN("STALE_DAYS"));
				request.setAttribute("acceptPDC", giacParamService.getParamValueV2("ACCEPT_PDC"));
				request.setAttribute("showCommSlip", giacParamService.getParamValueV2("SHOW_COMM_SLIP"));
				request.setAttribute("defaultOrGrossTag", giacParamService.getParamValueV2("DEFAULT_OR_GROSS_TAG"));
				request.setAttribute("defaultCheckClass", giacParamService.getParamValueV2("DEFAULT_CHECK_CLASS"));
				
				List<Map<String, Object>> creditMemoDtlsJSON = orderPaymentDetailService.getCreditMemoDtls(fundCd);
				StringFormatter.replaceQuotesInListOfMap(creditMemoDtlsJSON);
				request.setAttribute("creditMemoDtlsJSON", new JSONArray(creditMemoDtlsJSON));
				System.out.println("CREDIT MEMO FOUND: " + creditMemoDtlsJSON.size());
				
				String grpIsscd = checkUserService.getGroupIssCd(USER.getUserId());
				request.setAttribute("grpIssCd",  grpIsscd);
				
				String orTag = orderPaymentDetailService.getOrTag(null);
				request.setAttribute("orTag", orTag);
				System.out.println("test pBranchDetails -- "+pBranchCd);
				GIACBranch  branchDetails = null;
				if(pBranchCd.equals("")) {
					branchDetails = branchDetailService.getBranchDetails();
				} else {
					branchDetails = branchDetailService.getBranchDetails2(pBranchCd);
				}
				request.setAttribute("branchDetails", branchDetails);	
				System.out.println("Test Branch Cd - " + pBranchCd);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", fundCd);
				params.put("branchCd", pBranchCd);
				params.put("userId", USER.getUserId());
				params.put("bankCd", null);
				params.put("bankAcctCd", null);
				params.put("bankName", null);
				params.put("bankAcctNo", null);
				params.put("message", null);
				
				// added by Kris 01.30.2013: to get the effectivity date and expiry date of DCB user
				GIACDCBUser dcbUserInfo = dcbUserServ.getValidUSerInfo(branchDetails.getGfunFundCd(), branchDetails.getBranchCd(), USER.getUserId()); 
				request.setAttribute("dcbUserInfo", dcbUserInfo);
				// end
				
				Map<String, Object>  branchDefault = branchDetailService.getDefBranchBankDtls(params);
				//added condition for null bankName by robert 10.08.2014
				request.setAttribute("bankName", branchDefault.get("bankName") == null ? null : StringFormatter.replaceQuotes(branchDefault.get("bankName").toString())); //marco - 09.09.2014 - replaceQuotes 
				request.setAttribute("bankCd", branchDefault.get("bankCd"));
				request.setAttribute("bankAcctCd", branchDefault.get("bankAcctCd"));
				
				DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				System.out.println("TRANDATE: " + request.getParameter("tranDate") + " fundCD: " + branchDetails.getGfunFundCd() + " branchCd: " + branchDetails.getBranchCd());
				GIACCollnBatch dcbDetail = dcbDetailService.getDCBNo(branchDetails.getGfunFundCd(), branchDetails.getBranchCd(), sdf.parse(request.getParameter("tranDate")));
				GIACCollnBatch dcbNewDetail = dcbDetailService.getNewDCBNo(branchDetails.getGfunFundCd(), branchDetails.getBranchCd(), sdf.parse(request.getParameter("tranDate")));
				if ((dcbDetail == null)){
					request.setAttribute("dcbDetail", 0);
					System.out.println("dcbDetail: 0");
				}else{
					request.setAttribute("dcbDetail", dcbDetail.getDcbNo());
					System.out.println("dcbDetail: else" + dcbDetail.getDcbNo());
				}
				if((dcbNewDetail.getDcbNo() == null)){
					request.setAttribute("newDCBNo", 0);
					System.out.println("newDCBNo: 0");
				}else{
					request.setAttribute("newDCBNo", dcbNewDetail.getDcbNo() + 1);
					System.out.println("newDCBNo: " + dcbNewDetail.getDcbNo() + 1);
				}
				GIACDCBUser cashierDetail = cashierDetailService.getDCBCashierCd(branchDetails.getGfunFundCd(), branchDetails.getBranchCd(), USER.getUserId());
				request.setAttribute("cashierCd", cashierDetail.getCashierCd());
				
				//PaginatedList payorDetails = payorDetailService.getPayorLOV(pageNo, keyword);
				//List<GIISIntermediary> payorDetails = payorDetailService.getPayorLOV();
				//request.setAttribute("payorDetails", payorDetails);
				
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				
				List<LOV> defaultCurrency = helper.getList(LOVHelper.DEFAULT_CURRENCY);
				if(!defaultCurrency.isEmpty()){
					request.setAttribute("defaultCurrency", defaultCurrency.get(0).getCode());
				}else{
					request.setAttribute("defaultCurrency", "");
				}
				//System.out.println("DEFAULT CURRENCY: " + defaultCurrency.get(0).getCode() + " length: " + defaultCurrency.size());
						
				List<GIISIntermediary> intmDetails = payorDetailService.getAllGIISIntermediary();
				request.setAttribute("intmDetails", intmDetails);
							
				//LOVHelper payModeLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				List<LOV> payModeCodes = helper.getList(LOVHelper.PAY_MODE_LISTING);
				request.setAttribute("payModeCodes", payModeCodes);
				
				//LOVHelper checkClassdeLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				List<LOV> checkClassDetails = helper.getList(LOVHelper.CHECK_CLASS_LISTING);
				request.setAttribute("checkClassDetails", checkClassDetails);
				
				//LOVHelper bankDetailLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				List<LOV> bankDetails = helper.getList(LOVHelper.BANK_LISTING);
				request.setAttribute("bankDetails", bankDetails);
				
				//LOVHelper currencyLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				List<LOV> currencyDetails = helper.getList(LOVHelper.CURRENCY_CODES);
				request.setAttribute("currencyDetails", currencyDetails);
				
				//LOVHelper dcbBankLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				List<LOV> dcbBankDetails = helper.getList(LOVHelper.DCB_BANK_LISTING);
				request.setAttribute("dcbBankDetails", dcbBankDetails);
				
				//LOVHelper dcbBankAcctNoLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				List<LOV> dcbBankAcctNoDetails = helper.getList(LOVHelper.DCB_BANK_ACCTNO_LISTING);
				request.setAttribute("dcbBankAcctNoDetails", dcbBankAcctNoDetails);
				
				GIISParameter param = paramService.getParamValueV("IMPLEMENTATION_SW");
				request.setAttribute("implSwParameter", param.getParamValueV());
				//added based on c.s. enhancement
				request.setAttribute("apdcSw", apdcDtlService.getApdcSw(gaccTranId));
				
				Map<String, Object> closedTransParams = new HashMap<String, Object>();
				
				// added by Kris 01.30.2012:
				closedTransParams.put("fundCd", branchDetails.getGfunFundCd());
				closedTransParams.put("branchCd", branchDetails.getBranchCd());
				// end
				
				List<GIACTranMm> closedTrans = giacTranMmService.getClosedTransactionMonthYear(closedTransParams);
				StringFormatter.replaceQuotesInList(closedTrans);
				request.setAttribute("closedTranJSON", new JSONArray(closedTrans));
				Debug.print("Closed Trans Details: " + new JSONArray(closedTrans));
				
				request.setAttribute("tranFlag", "");
				request.setAttribute("orFlag", "N"); //added by christian 08.30.2012
				
				log.info("COLLN_SOURCE_NAME : " + collnSourceName);
				log.info("FUND_CD : " + fundCd);
				log.info("Group IssCd: " + grpIsscd);
				log.info("Or Tag: " + orTag);
				
				PAGE = "/pages/accounting/officialReceipt/generateOfficialReceipt.jsp";
				message = "SUCCESS";
			} else if ("editORInformation".equals(ACTION)) {
				GIACBranchService branchDetailService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				GIISIntermediaryService payorDetailService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIISUserFacadeService checkUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				GIACCollectionDtlService collnDtlSvc = (GIACCollectionDtlService) APPLICATION_CONTEXT.getBean("giacCollectionDtlService");
				GIISParameter param = paramService.getParamValueV("IMPLEMENTATION_SW");
				GIACAccTransService giacAccTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				String collnSourceName = giacParamService.getParamValueV2("COLLN_SOURCE_NAME");
				GIACApdcPaytDtlService apdcDtlService = (GIACApdcPaytDtlService) APPLICATION_CONTEXT.getBean("giacApdcPaytDtlService");
				
				gaccTranId = (request.getParameter("gaccTranID") == null || request.getParameter("gaccTranID").equals("") || request.getParameter("gaccTranID").equals("null")) ? 0 : Integer.parseInt(request.getParameter("gaccTranID"));
				String fundCd = giacParamService.getParamValueV2("FUND_CD");
				String grpIssCd = checkUserService.getGroupIssCd(USER.getUserId());
				GIACOrderOfPayment giacOrderOfPayt = orderPaymentDetailService.getGIACOrDtl(gaccTranId);
				
				//john 10.20.2014
				GIACOrRel giacOrRel = orderPaymentDetailService.getGiacOrRel(gaccTranId);
				if(giacOrRel != null){
					if(("R").equals(giacOrderOfPayt.getOrFlag())){ //Added by Jerome Bautista 11.27.2015 SR 21016
						/*request.setAttribute("giacOrRelOldPrefSuf", giacOrRel.getOldOrPrefSuf());
						request.setAttribute("giacOrRelOldOrNo", giacOrRel.getOldOrNo());*/
						request.setAttribute("giacOrRelNewPrefSuf", giacOrRel.getNewOrPrefSuf());
						request.setAttribute("giacOrRelNewOrNo", giacOrRel.getNewOrNo());
					}else{
						request.setAttribute("giacOrRelOldPrefSuf", giacOrRel.getOldOrPrefSuf());
						request.setAttribute("giacOrRelOldOrNo", giacOrRel.getOldOrNo());
						/*request.setAttribute("giacOrRelNewPrefSuf", giacOrRel.getNewOrPrefSuf());
						request.setAttribute("giacOrRelNewOrNo", giacOrRel.getNewOrNo());*/
					}
				}
				
				String pBranchCd = request.getParameter("branchCd");
				
				/*ADDED BY TONIO 03/10/2011 TO GET DEFAULT BANK DETAILS*/
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", fundCd);
				//params.put("branchCd", "HO"); //marco - 07.16.2013 - @UCPB SR# 13668 :(
				params.put("branchCd", pBranchCd);
				params.put("bankCd", null);
				params.put("bankAcctCd", null);
				params.put("bankName", null);
				params.put("bankAcctNo", null);
				params.put("message", null);
				params.put("userId", USER.getUserId());
				
				Map<String, Object>  branchDefault = branchDetailService.getDefBranchBankDtls(params);
				request.setAttribute("bankName", StringFormatter.replaceQuotes((String) branchDefault.get("bankName")));//replaced by john 10.13.2014
				//request.setAttribute("bankName", StringFormatter.replaceQuotes(branchDefault.get("bankName").toString())); //marco - 09.09.2014 - replaceQuotes
				request.setAttribute("bankCd", branchDefault.get("bankCd"));
				request.setAttribute("bankAcctCd", branchDefault.get("bankAcctCd"));
				/*************************************************************/
				
				/*ADDED BY TONIO 03/30/2011 TO GET Credit Memo details*/
				List<Map<String, Object>> creditMemoDtlsJSON = orderPaymentDetailService.getCreditMemoDtls(fundCd);
				StringFormatter.replaceQuotesInListOfMap(creditMemoDtlsJSON);
				request.setAttribute("creditMemoDtlsJSON", new JSONArray(creditMemoDtlsJSON));
				/*************************************************************/

				System.out.println("gaccTranID: " + gaccTranId);
				request.setAttribute("gaccTranId", gaccTranId);
				String orFlag = null; //Deo [01.12.2017]: SR-22498
				String orTag = null; //Deo [02.10.2017]: SR-5932
				String tranFlagState = giacAccTransService.getTranFlag(gaccTranId); //Deo [02.10.2017]: SR-5932

				if(giacOrderOfPayt != null){ //added by steven;para mahandle siya kapag null ung object.
					request.setAttribute("dcbDetail", giacOrderOfPayt.getDcbNo());
					request.setAttribute("cashierCd", giacOrderOfPayt.getCashierCd());
					request.setAttribute("orPrefSuf", giacOrderOfPayt.getOrPrefSuf());
					request.setAttribute("orNo", giacOrderOfPayt.getOrNo());
					request.setAttribute("remitDate", giacOrderOfPayt.getRemitDate());
					request.setAttribute("orDtlDate", giacOrderOfPayt.getOrDate());
					request.setAttribute("orFlag", giacOrderOfPayt.getOrFlag());
					request.setAttribute("orTag", giacOrderOfPayt.getOrTag());
					request.setAttribute("opTag", giacOrderOfPayt.getOpTag());
					request.setAttribute("orFlagRV", orderPaymentDetailService.getRVMeaning("GIAC_ORDER_OF_PAYTS.OP_FLAG", giacOrderOfPayt.getOrFlag()));
					request.setAttribute("provReceiptNo", giacOrderOfPayt.getProvReceiptNo());
					request.setAttribute("payor", StringFormatter.replaceQuotes(giacOrderOfPayt.getPayor()));//reymon 04042013
					request.setAttribute("intmNo", giacOrderOfPayt.getIntmNo());
					request.setAttribute("address1", StringFormatter.replaceQuotes(giacOrderOfPayt.getAddress1()));//reymon 04042013
					request.setAttribute("address2", StringFormatter.replaceQuotes(giacOrderOfPayt.getAddress2()));//reymon 04042013
					request.setAttribute("address3", StringFormatter.replaceQuotes(giacOrderOfPayt.getAddress3()));//reymon 04042013
					request.setAttribute("tin", giacOrderOfPayt.getTinNo());
					request.setAttribute("particulars", StringFormatter.replaceQuotes(giacOrderOfPayt.getParticulars()));//reymon 04042013
					request.setAttribute("withPdc", giacOrderOfPayt.getWithPdc());
					request.setAttribute("grossTag", giacOrderOfPayt.getGrossTag());
					request.setAttribute("uploadTag", giacOrderOfPayt.getUploadTag());
					request.setAttribute("riCommTag", giacOrderOfPayt.getRiCommTag());
					orFlag = giacOrderOfPayt.getOrFlag(); //Deo [01.12.2017]: SR-22498
					orTag = giacOrderOfPayt.getOrTag(); //Deo [02.10.2017]: SR-5932
				}
				
				orTag = orTag == null ? "" : orTag; //benjo 02.28.2017 SR-23923 
				
				List<GIACCollectionDtl> collnDtls = collnDtlSvc.getGIACCollnDtl(gaccTranId);
				request.setAttribute("collnDtls", StringFormatter.escapeHTMLInList2(collnDtls)); //added StringFormatter.escapeHTMLInList2 by robert 10.09.2013
				
				request.setAttribute("implSwParameter", param.getParamValueV());
				request.setAttribute("fundCd", fundCd);
				request.setAttribute("grpIssCd",  grpIssCd);
				request.setAttribute("collnSourceName", collnSourceName);		
				
				request.setAttribute("orAnteDate", giacParamService.getParamValueN("OR_ANTE_DATE_PARAM"));
				request.setAttribute("uploadImplemSw", giacParamService.getParamValueV2("UPLOAD_IMPLEMENTATION_SW"));
				request.setAttribute("staleMgrChk", giacParamService.getParamValueN("STALE_MGR_CHK"));
				request.setAttribute("staleCheck", giacParamService.getParamValueN("STALE_CHECK"));
				request.setAttribute("staleDays", giacParamService.getParamValueN("STALE_DAYS"));
 				request.setAttribute("acceptPDC", giacParamService.getParamValueV2("ACCEPT_PDC"));
				request.setAttribute("checkCommPayts", giacParamService.getParamValueV2("CHECK_COMM_PAYTS"));
				request.setAttribute("showCommSlip", giacParamService.getParamValueV2("SHOW_COMM_SLIP"));
				request.setAttribute("defaultCheckClass", giacParamService.getParamValueV2("DEFAULT_CHECK_CLASS"));
				
				//marco - 09.08.2014
				GIACDCBUserService dcbUserServ = (GIACDCBUserService) APPLICATION_CONTEXT.getBean("giacDCBUserService");
				GIACDCBUser dcbUserInfo = dcbUserServ.getValidUSerInfo(fundCd, pBranchCd, USER.getUserId()); 
				request.setAttribute("dcbUserInfo", dcbUserInfo);
				
				//marco - 09.11.2014
				request.setAttribute("editAPDCOR", giacParamService.getParamValueV2("EDIT_APDC_OR"));
				request.setAttribute("withAPDC", giacOrderOfPaymentService.checkAPDCPaytDtl(gaccTranId));
 				
				/* benjo 11.08.2016 SR-5802 */
				GIACModulesService giacModulesService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				Map<String, Object> asParams = new HashMap<String, Object>();
				asParams.put("user", USER.getUserId());
				asParams.put("funcCode", "AS");
				asParams.put("moduleName", "GIACS001");
				request.setAttribute("allowSpoil", giacModulesService.validateUserFunc3(asParams));
				request.setAttribute("apdcSW", giacParamService.getParamValueV2("APDC_SW"));
				/* end SR-5802 */
				
				//GIACBranch  branchDetails = branchDetailService.getBranchDetails();
				GIACBranch  branchDetails = branchDetailService.getBranchDetails2(pBranchCd);
				request.setAttribute("branchDetails", branchDetails);				
				
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				
				List<LOV> defaultCurrency = helper.getList(LOVHelper.DEFAULT_CURRENCY);
				if(!defaultCurrency.isEmpty()){
					request.setAttribute("defaultCurrency", defaultCurrency.get(0).getCode());
				}else{
					request.setAttribute("defaultCurrency", "");
				}
				//request.setAttribute("defaultCurrency", defaultCurrency.get(0).getCode());
				//System.out.println("DEFAULT CURRENCY: " + defaultCurrency.get(0).getCode() + " length: " + defaultCurrency.size());
				
				List<GIISIntermediary> intmDetails = payorDetailService.getAllGIISIntermediary();
				request.setAttribute("intmDetails", intmDetails);
							
				List<LOV> payModeCodes = helper.getList(LOVHelper.PAY_MODE_LISTING);
				request.setAttribute("payModeCodes", payModeCodes);
				
				List<LOV> checkClassDetails = helper.getList(LOVHelper.CHECK_CLASS_LISTING);
				request.setAttribute("checkClassDetails", checkClassDetails);
				
				List<LOV> bankDetails = helper.getList(LOVHelper.BANK_LISTING);
				request.setAttribute("bankDetails", bankDetails);
				
				List<LOV> currencyDetails = helper.getList(LOVHelper.CURRENCY_CODES);
				request.setAttribute("currencyDetails", currencyDetails);
				
				List<LOV> dcbBankDetails = helper.getList(LOVHelper.DCB_BANK_LISTING);
				if ((orFlag.equals("P") //Deo [01.12.2017]: add start (SR-22498)
						&& !(tranFlagState.equals("O") && orTag.equals("*"))) //Deo [02.10.2017]: SR-5932
						|| orFlag.equals("C")) {
					request.setAttribute("dcbBankDetails", bankDetails);
				} else { //Deo [01.12.2017]: add ends (SR-22498)
					request.setAttribute("dcbBankDetails", dcbBankDetails);
				}
				
				if ((orFlag.equals("P") //Deo [01.12.2017]: add start (SR-22498)
						&& !(tranFlagState.equals("O") && orTag.equals("*"))) //Deo [02.10.2017]: SR-5932
						|| orFlag.equals("C")) {
					List<LOV> dcbBankAcctNoDetails = helper.getList(LOVHelper.BANK_ACCT_LISTING);
					request.setAttribute("dcbBankAcctNoDetails", dcbBankAcctNoDetails);
				} else { //Deo [01.12.2017]: add ends (SR-22498)
					List<LOV> dcbBankAcctNoDetails = helper.getList(LOVHelper.DCB_BANK_ACCTNO_LISTING);
					request.setAttribute("dcbBankAcctNoDetails", dcbBankAcctNoDetails);
				}
				//added based on c.s. enhancement
				request.setAttribute("apdcSw", apdcDtlService.getApdcSw(gaccTranId));
				
				String tranFlag = giacAccTransService.getTranFlag(gaccTranId);
				request.setAttribute("tranFlag", tranFlag);
				
				//request.setAttribute("gacc", giacAccTransService.getGiacAcctransDtl(gaccTranId));
				
				GIACAccTrans  gacc = giacAccTransService.getGiacAcctransDtl(gaccTranId);
				request.setAttribute("gacc", gacc);
				
				log.info("COLLN_SOURCE_NAME : " + collnSourceName);
				log.info("FUND_CD : " + fundCd);
				log.info("Group IssCd: " + grpIssCd);
				if(giacOrderOfPayt != null){ //added by steven;para mahandle siya kapag null ung object.
					log.info("Or Tag: " + giacOrderOfPayt.getOrTag());
				}
				PAGE = "/pages/accounting/officialReceipt/generateOfficialReceipt.jsp";
				message = "SUCCESS";
			} else if ("showORDetails".equals(ACTION)) {
				// assigning temp value para di mag create ng OR everytime magtetest yung mga sumunod na modules 
				gaccTranId = request.getParameter("gaccTranId") == "" ? 0 : Integer.parseInt(request.getParameter("gaccTranId"));
				System.out.println("gaccTranId before: " + request.getParameter("gaccTranId"));
				gaccTranId = gaccTranId == 0 ? 54577 : Integer.parseInt(request.getParameter("gaccTranId")); //45371 orig 54519, new 54577
				System.out.println("tranID temp: " + gaccTranId);
				/* Define Services needed */
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				GIACCollectionDtlService collectionDetailService = (GIACCollectionDtlService) APPLICATION_CONTEXT.getBean("giacCollectionDtlService");
				GIISUserFacadeService checkUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				GIACAccTransService giacAccTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				
				//public GIISParameter getParamValueV(String paramName) throws SQLException;
				GIACOrderOfPayment orderOfPayment = orderPaymentDetailService.getGIACOrderOfPaymentDtl(gaccTranId);
				GIACCollectionDtl collectionDetail = collectionDetailService.getGIACCollectionDtl(gaccTranId);
				GIACAccTrans giacAcctDetail = giacAccTransService.getValidationDetail(gaccTranId);
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				//global variables
				//request.setAttribute("gaccTranId", gaccTranId);
				//request.setAttribute("gaccBranchCd", gaccBranchCd);
				//request.setAttribute("gaccFundCd", gfunFundCd);
				
				//blocks/objects
				String[] param = {gaccTranId.toString()};
				List<LOV> currDtls = helper.getList(LOVHelper.TRANS_BASIC_CURR_DTLS, param);
				//System.out.println("curr shorname:" + currDtls.get(0).getShortName());
				request.setAttribute("currDtls", currDtls);
				request.setAttribute("orderOfPayment", StringFormatter.escapeHTMLInObject2(orderOfPayment));//reymon 04082013
				request.setAttribute("collectionDtl", collectionDetail);
				
				//values for module variables
				request.setAttribute("ctrlCompany", paramService.getParamValueV2("COMPANY_SHORT_NAME"));	
				request.setAttribute("vFlag", giacAcctDetail == null ? "" : giacAcctDetail.getTranFlag());
				
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");

				request.setAttribute("tranDate", giacAcctDetail == null ? null : sdf.format(giacAcctDetail.getTranDate()));
				request.setAttribute("gfunFundCd",giacAcctDetail == null ? null : giacAcctDetail.getGfunFundCd());
				
				//LOV's and other items
				request.setAttribute("meanOpFlag", orderPaymentDetailService.getRVMeaning("GIAC_ORDER_OF_PAYTS.OP_FLAG",(orderOfPayment == null? null : orderOfPayment.getOpFlag())));
				request.setAttribute("meanORFlag", orderPaymentDetailService.getRVMeaning("GIAC_ORDER_OF_PAYTS.OR_FLAG",(orderOfPayment == null ? null : orderOfPayment.getOrFlag())));
				request.setAttribute("riCommTag", orderOfPayment == null? null : orderOfPayment.getRiCommTag());
				//request.setAttribute("defModAccessTag", checkUserService.checkUserAccess("GIACS007")); //Commented out and replaced by code below - Jerome Bautista 12.01.2015 SR 21079
				request.setAttribute("defModAccessTag", checkUserService.checkUserAccess2("GIACS007", USER.getUserId()));

				PAGE = "/pages/accounting/officialReceipt/transBasicInformation.jsp";
				
				message = "SUCCESS";
			} else if ("saveORInformation".equals(ACTION)) {
				/* Define Services needed */
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				String appUser = USER.getUserId();
				
				System.out.println("SAVE OR USER: " + appUser);
				
				GIACCollnBatch giacCollnBatchDtl = parseGIACCollnBatch(request.getParameter("giacCollnBatchDtl"), appUser);
				GIACAccTrans giacAcctransDtl = parseGiacAcctrans(request.getParameter("giacAcctrans"), appUser);
 				GIACOrderOfPayment giacOrderOfPaymentDtl = parseGIACOrderOfPayment(request.getParameter("orderOfPaymentDtl"), appUser);
				List<GIACCollectionDtl> giacCollectionDtl = parseGIACCollectionDtl(request.getParameter("giacCollectionDetail"), appUser);
				
				System.out.println(request.getParameter("gaccTranId"));
				gaccTranId = Integer.parseInt(request.getParameter("gaccTranId"));
				String[] itemNoList = request.getParameter("itemNoList").split(",");
				String[] pdcItemIdList = request.getParameter("pdcItemIdList").split(","); //added john 12.10.2014
				
				Map<String, Object> acctEntriesDtl = new HashMap<String, Object>();
				acctEntriesDtl.put("branchCd", request.getParameter("branchCd"));
				acctEntriesDtl.put("fundCd", request.getParameter("fundCd"));
				acctEntriesDtl.put("moduleName", request.getParameter("moduleName"));
				acctEntriesDtl.put("slCd", null);
				acctEntriesDtl.put("slTypeCd", null);
				acctEntriesDtl.put("userId", USER.getUserId());
				
				//Put all Maps in a single Map
				Map<String, Object> allParam = new HashMap<String, Object>();
				allParam.put("giacCollnBatchDtl", giacCollnBatchDtl);
				allParam.put("giacAcctransDtl", giacAcctransDtl);
				allParam.put("giacOrderOfPaymentDtl", giacOrderOfPaymentDtl);
				allParam.put("giacCollectionDtl", giacCollectionDtl);
				allParam.put("itemNoList", itemNoList);
				allParam.put("acctEntriesDtl", acctEntriesDtl);
				allParam.put("giacOrRel", JSONUtil.prepareObjectFromJSON(new JSONObject(request.getParameter("giacOrRel")), appUser, GIACOrRel.class));
				allParam.put("cancelledOrPrefSuf", request.getParameter("cancelledOrPrefSuf"));
				allParam.put("pdcItemIdList", pdcItemIdList); //added john 12.10.2014
				
				message =  orderPaymentDetailService.saveORInformation(allParam, gaccTranId).toString();
				PAGE = "/pages/genericMessage.jsp";
				
			} else if ("validateCancelledORInput".equals(ACTION)) {
				/* Define Services needed */
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				
				GIACOrderOfPayment cancelledORDtls = orderPaymentDetailService.validateCancelledORInput(request.getParameter("canPrefSuf"), Integer.parseInt(request.getParameter("canORNo")));
				if (cancelledORDtls != null){
					request.setAttribute("payor", cancelledORDtls.getPayor() == null ? "-" : cancelledORDtls.getPayor());
					request.setAttribute("address1", cancelledORDtls.getAddress1() == null ? " " : cancelledORDtls.getAddress1());
					request.setAttribute("address2", cancelledORDtls.getAddress2() == null ? " " : cancelledORDtls.getAddress2());
					request.setAttribute("address3", cancelledORDtls.getAddress3() == null ? " " : cancelledORDtls.getAddress3());
					request.setAttribute("orDate", cancelledORDtls.getOrDate() == null ? "-" : cancelledORDtls.getOrDate());
					request.setAttribute("orTag", cancelledORDtls.getOrTag() == null ? "-" : cancelledORDtls.getOrTag());
					request.setAttribute("particulars", cancelledORDtls.getParticulars() == null ? "-" : cancelledORDtls.getParticulars());		
					request.setAttribute("tinNo", cancelledORDtls.getTinNo() == null ? " " : cancelledORDtls.getTinNo());	
					request.setAttribute("gaccTranId", cancelledORDtls.getGaccTranId() == null ? " " : cancelledORDtls.getGaccTranId());	

				}	
				PAGE = "/pages/accounting/officialReceipt/subPages/ajaxORUpdateFields.jsp";
				
			}else if("openSearchPayorModal".equals(ACTION)){
				
				PAGE = "/pages/pop-ups/searchPayor.jsp";
				
			}else if("getSearchResult".equals(ACTION)){
				/* Define Services needed */
				GIISIntermediaryService payorDetailService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				
				/*String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}*/ // commented by: Nica 06.14.2013

				PaginatedList searchResult = null;
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}else {
					pageNo = 1;
				}
				//try {
				//searchResult = payorDetailService.getPayorLOV(pageNo, keyword);//giisAssuredService.getAssuredList(pageNo, keyword);
				searchResult = payorDetailService.getPayorLOV2(request, pageNo); // Nica 06.14.2013 - AC-SPECS-2012-155
				request.setAttribute("searchResult", StringFormatter.replaceQuotesInList(searchResult));
				request.setAttribute("pageNo", pageNo+1); //searchResult.getPageIndex()
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				System.out.println("NO OF PAGES: " + searchResult.getNoOfPages());
				
				PAGE = "/pages/pop-ups/searchPayorAjaxResult.jsp";
				//} catch (Exception e) {
				//	e.printStackTrace();
				//	log.debug(Arrays.toString(e.getStackTrace()));
				//}
				/*if (null != request.getParameter("isFromAssuredListingMenu")) {
					PAGE = "/pages/common/subPages/assured/assuredListingTable.jsp";
				} else {
					PAGE = "/pages/pop-ups/searchAssuredAjaxResult.jsp";
				}*/

			} /*
				<< The old OR Listing >>
				else if("showORListing".equals(ACTION)){
				String fundCd = request.getParameter("selFundCd") == null ? "" : request.getParameter("selFundCd");
				String branchCd = request.getParameter("selBranch") == null ? "" : request.getParameter("selBranch");
				log.info("showORListing: " + fundCd + " - " + branchCd);
				request.setAttribute("acFundCd", fundCd);
				request.setAttribute("acBranch", branchCd);
				PAGE = "/pages/accounting/orList/orListing.jsp";
			} */
			else if("showORListing".equals(ACTION)){
				//services
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIISUserFacadeService checkUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				String fundCd = request.getParameter("selFundCd") == null ? "" : request.getParameter("selFundCd");
				String branchCd = request.getParameter("selBranch") == null ? "" : request.getParameter("selBranch");
				
				// added cancel OR tag to check if Cancelled OR's should be displayed (only when OR Listing, cancelled OR's are not displayed in Cancel OR Listing) - emman 05.19.2011
				String cancelORTag = request.getParameter("cancelOR") == null ? "N" : (request.getParameter("cancelOR").isEmpty() ? "N" : request.getParameter("cancelOR"));
				log.info("showORListing: " + fundCd + " - " + branchCd);
				request.setAttribute("acFundCd", fundCd);
				request.setAttribute("acBranch", branchCd);
				
				// for the table grid
				Map<String, Object> tableGridParams = new HashMap<String, Object>();
				String acFundCd = fundCd.isEmpty() ? giacParamService.getParamValueV2("FUND_CD") : fundCd;				
				String grpIssCd = branchCd.isEmpty() ? checkUserService.getGroupIssCd(USER.getUserId()) : branchCd;
				tableGridParams.put("fund_cd", acFundCd);
				tableGridParams.put("branch_cd", grpIssCd);
				tableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				tableGridParams.put("filter", request.getParameter("objFilter"));
				tableGridParams.put("user_id", USER.getUserId());
				tableGridParams.put("cancel_or", cancelORTag);
				tableGridParams.put("orTag", request.getParameter("orTag")); // M - manual; G - generated; null - both
				tableGridParams.put("orStatus", "N"); //marco - 09.09.2014
				
				tableGridParams = orderPaymentDetailService.getORListTableGridMap(tableGridParams);
				request.setAttribute("orListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(tableGridParams)));
				
				PAGE = "/pages/accounting/orList/orListing.jsp";
			} else if ("refreshORListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIISUserFacadeService checkUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				String fundCd = request.getParameter("acFundCd").isEmpty() ? giacParamService.getParamValueV2("FUND_CD") : request.getParameter("acFundCd");				
				String grpIssCd = request.getParameter("acBranch").isEmpty() ? checkUserService.getGroupIssCd(USER.getUserId()) : request.getParameter("acBranch");
				
				String cancelORTag = request.getParameter("cancelOR") == null ? "N" : (request.getParameter("cancelOR").isEmpty() ? "N" : request.getParameter("cancelOR"));
				
				params.put("fund_cd", fundCd);
				params.put("branch_cd", grpIssCd);
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("user_id", USER.getUserId());
				params.put("cancel_or", cancelORTag);
				params.put("orStatus", request.getParameter("orStatus")); //marco - 09.09.2014
				System.out.println("Refresh OR Listing filter: "+params);
				params = orderPaymentDetailService.getORListTableGridMap(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if("getORListing".equals(ACTION)){
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				JSONArrayList searchResult;
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
								
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				GIISUserFacadeService checkUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				String fundCd = request.getParameter("acFundCd") == "" ? giacParamService.getParamValueV2("FUND_CD") : request.getParameter("acFundCd");				
				String grpIssCd = request.getParameter("acBranch") == "" ? checkUserService.getGroupIssCd(USER.getUserId()) : request.getParameter("acBranchCd");
				System.out.println("getORListing: " + fundCd + " - " + grpIssCd);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("keyword", keyword.toUpperCase());
				params.put("fund_cd", fundCd);
				params.put("branch_cd", grpIssCd);
				searchResult = orderPaymentDetailService.getORList(pageNo, params);
				/*request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());*/
				JSONObject obj = new JSONObject(searchResult);
				message = obj.toString();
				if (null != request.getParameter("isFromORListingMenu")) {
				//	PAGE = "/pages/accounting/orList/orListingTable.jsp";
					PAGE = "/pages/genericMessage.jsp";
				} else {
				//	PAGE = "/pages/pop-ups/searchAssuredAjaxResult.jsp";
				}
			}else if ("checkDCB".equals(ACTION)){
				Integer dcbDetailNo = 0;
				Integer newDCBNo = 0;
				GIACCollnBatchService dcbDetailService = (GIACCollnBatchService) APPLICATION_CONTEXT.getBean("giacCollnService");
				GIACBranchService branchDetailService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				
				DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				GIACBranch  branchDetails = branchDetailService.getBranchDetails2(request.getParameter("branchCd"));
				GIACCollnBatch dcbDetail = dcbDetailService.getDCBNo(branchDetails.getGfunFundCd(), branchDetails.getBranchCd(), sdf.parse(request.getParameter("tranDate")));
				GIACCollnBatch dcbNewDetail = dcbDetailService.getNewDCBNo(branchDetails.getGfunFundCd(), branchDetails.getBranchCd(), sdf.parse(request.getParameter("tranDate")));
				log.info("CHECK DCB === fundCd: " + branchDetails.getGfunFundCd() + " branchCd: " + branchDetails.getBranchCd() + " tranDate: " + sdf.parse(request.getParameter("tranDate")));
				if ((dcbDetail == null)){
					dcbDetailNo = 0;
				}else{
					dcbDetailNo = dcbDetail.getDcbNo();
				}
				if((dcbNewDetail.getDcbNo() == null)){
					newDCBNo = 0;
				}else{
					newDCBNo = dcbNewDetail.getDcbNo() + 1;
				}
				
				StringBuilder sb = new StringBuilder();
				sb.append("dcbDetailNo=" + dcbDetailNo);
				sb.append("&newDCBNo=" + newDCBNo);
				
				message = sb.toString();
				PAGE = "/pages/genericMessage.jsp";
				
			}else if ("spoilOr".equals(ACTION)) {
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("butLabel", request.getParameter("butLabel"));
				params.put("orFlag", request.getParameter("orFlag"));
				params.put("orTag", request.getParameter("orTag"));
				params.put("orPrefSuf", request.getParameter("orPrefSuf"));
				params.put("orNo", request.getParameter("orNo").equals("") ? null : Long.parseLong(request.getParameter("orNo")));
				params.put("gibrFundCd", request.getParameter("gibrFundCd"));
				params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
				params.put("orDate", request.getParameter("orDate"));
				params.put("dcbNo", Integer.parseInt(request.getParameter("dcbNo")));
				params.put("message", "");
				params.put("callingForm", request.getParameter("callingForm"));
				params.put("moduleName", request.getParameter("moduleName"));
				params.put("orCancellation", request.getParameter("orCancellation"));
				params.put("payor", request.getParameter("payor"));
				params.put("collectionAmt", new BigDecimal(request.getParameter("collectionAmt")));
				params.put("cashierCd", Integer.parseInt(request.getParameter("cashierCd")));
				params.put("grossAmt", new BigDecimal(request.getParameter("grossAmt")));
				params.put("grossTag", request.getParameter("grossTag"));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("appUser", USER.getUserId());
				
				Debug.print("PARAMS From SPOIL OR: " + params);
				orderPaymentDetailService.spoilOR(params);
				Debug.print("PARAMS From After: " + params);
				StringBuilder sb = new StringBuilder();
				sb.append("orFlag=" + params.get("orFlag"));
				sb.append("&orPrefSuf=" + params.get("orPrefSuf"));
				sb.append("&orNo=" + params.get("orNo"));
				sb.append("&message=" + params.get("message"));
				
				message = sb.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getCreditMemoDtls".equals(ACTION)) {
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				String fundCd = request.getParameter("fundCd");
				List<Map<String, Object>> creditMemoDtlsJSON = orderPaymentDetailService.getCreditMemoDtls(fundCd);
				StringFormatter.replaceQuotesInListOfMap(creditMemoDtlsJSON);
				request.setAttribute("creditMemoDtls", creditMemoDtlsJSON);
				request.setAttribute("creditMemoDtlsJSON", new JSONArray(creditMemoDtlsJSON));
				System.out.println("CREDIT MEMO FOUND: " + creditMemoDtlsJSON.size());
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/showCreditMemo.jsp";
			}else if ("validateOr".equals(ACTION)){
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("orPref", request.getParameter("orPref"));
				params.put("orNo", request.getParameter("orNo"));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				
				String msg = orderPaymentDetailService.validateOr(params);
				System.out.println("Validate OR Message: " + msg);
				message = msg;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("retrieveORParams".equals(ACTION)) {
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				GIACAccTransService giacAccTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				//marco - 05.03.2013 - conditions
				gaccTranId = (request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals("null") || request.getParameter("gaccTranId") == null) ? 0 : Integer.parseInt(request.getParameter("gaccTranId"));
				System.out.println("Retrieving OR Information... "+gaccTranId);
				
				GIACOrderOfPayment giacOrderOfPayt = orderPaymentDetailService.getGIACOrDtl(gaccTranId);
				if (giacOrderOfPayt != null){ //added by steven 04.08.2013  para di mag-eerror kung null siya. 
					params.putAll(FormInputUtil.formMapFromEntity(giacOrderOfPayt));
					params.put("orFlagRV", orderPaymentDetailService.getRVMeaning("GIAC_ORDER_OF_PAYTS.OP_FLAG", giacOrderOfPayt.getOrFlag()));
				}
				params.put("tranFlag", giacAccTransService.getTranFlag(gaccTranId));
				System.out.println("Retrieved OR Params: "+params);
				message = new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkCommPayts".equals(ACTION)){
				GIACOrderOfPaymentService orderPaymentDetailService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				orderPaymentDetailService.checkCommPayts(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showBatchORPrinting".equals(ACTION)){
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("ora2010Sw", paramService.getParamValueV2("ORA2010_SW"));
				request.setAttribute("oneORSequence", giacParamService.getParamValueV2("ONE_OR_SEQUENCE"));
				request.setAttribute("vatNonVatSeries", giacParamService.getParamValueV2("VAT_NONVAT_SERIES"));
				request.setAttribute("editORNo", giacParamService.getParamValueV2("EDIT_OR_NO"));
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/batchORPrinting/batchORPrinting.jsp";
			}else if("getBatchORList".equals(ACTION)){
				JSONObject json = giacOrderOfPaymentService.getBatchORList(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDefaultOrValues".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacOrderOfPaymentService.getDefaultORValues(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			}else if("checkOR".equals(ACTION)){
				message = giacOrderOfPaymentService.checkOR(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkAllORs".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacOrderOfPaymentService.checkAllORs(request)));
				PAGE = "/pages/genericObject.jsp";
			}else if("uncheckAllORs".equals(ACTION)){
				giacOrderOfPaymentService.uncheckAllORs();
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGenerateTag".equals(ACTION)){
				giacOrderOfPaymentService.saveGenerateFlag(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateOrNumbers".equals(ACTION)){
				giacOrderOfPaymentService.generateOrNumbers(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBatchORReportParams".equals(ACTION)){
				request.setAttribute("object", new JSONArray(giacOrderOfPaymentService.getBatchORReportParams(request)));
				PAGE = "/pages/genericObject.jsp";
			}else if("processPrintedBatchOR".equals(ACTION)){
				giacOrderOfPaymentService.processPrintedBatchOR(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLastORNoOverlay".equals(ACTION)){
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/batchORPrinting/popups/enterLastPrintedOR.jsp";
			}else if("checkLastPrintedOR".equals(ACTION)){
				System.out.println("CONTROLLER: " + giacOrderOfPaymentService.checkLastPrintedOR(request));
				request.setAttribute("object", giacOrderOfPaymentService.checkLastPrintedOR(request));
				PAGE = "/pages/genericObject.jsp";
			}else if("spoilBatchOR".equals(ACTION)){
				giacOrderOfPaymentService.spoilBatchOR(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("spoilSelectedOR".equals(ACTION)){
				giacOrderOfPaymentService.spoilSelectedOR(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBatchCommSlipParams".equals(ACTION)){
				request.setAttribute("object", new JSONObject(giacOrderOfPaymentService.getBatchCommSlipParams()));
				PAGE = "/pages/genericObject.jsp";
			}else if("showGiacs213".equals(ACTION)){
				JSONObject jsonVehicleList = giacOrderOfPaymentService.getGiacs213VehicleListing(request, USER.getUserId());
				
				if ("1".equals(request.getParameter("refresh"))){
					message = jsonVehicleList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonVehicleList", jsonVehicleList);
					PAGE = "/pages/accounting/officialReceipt/directTrans/inquiryScreen/plateNoInquiry.jsp";
				}				
			}else if("countVehiclesInsured".equals(ACTION)){
				Integer assdNo = request.getParameter("assdNo") == "" || request.getParameter("assdNo") == null ? null : Integer.parseInt(request.getParameter("assdNo"));
				message = giacOrderOfPaymentService.countVehiclesInsured(assdNo).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGiacs214".equals(ACTION)){
				JSONObject jsonPolbasicList = giacOrderOfPaymentService.getGiacs214PolbasicListing(request, USER.getUserId());
				
				if ("1".equals(request.getParameter("refresh"))){
					message = jsonPolbasicList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					JSONObject jsonInvoiceList = giacOrderOfPaymentService.getGiacs214InvoiceListing(request);
					JSONObject jsonAgingSoaDetails = giacOrderOfPaymentService.getGiacs214AgingSoaDetails(request);
					
					request.setAttribute("jsonPolbasicList", jsonPolbasicList);
					request.setAttribute("jsonInvoiceList", jsonInvoiceList);
					request.setAttribute("jsonAgingSoaDetails", jsonAgingSoaDetails);
					PAGE = "/pages/accounting/officialReceipt/directTrans/inquiryScreen/policyEndtForGivenAssd.jsp";
				}				
			}else if("getGiacs214InvoiceList".equals(ACTION)){
				JSONObject jsonInvoiceList = giacOrderOfPaymentService.getGiacs214InvoiceListing(request);
				message = jsonInvoiceList.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGiacs214AgingSoaDetails".equals(ACTION)){
				JSONObject jsonAgingSoaDetails = giacOrderOfPaymentService.getGiacs214AgingSoaDetails(request);
				message = jsonAgingSoaDetails.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getCnclCollnBreakDown".equals(ACTION)){ //john 10.15.2014
				JSONArray jsonCollnBreakdown = new JSONArray(giacOrderOfPaymentService.getCnclCollnBreakDown(request));
				request.setAttribute("object", jsonCollnBreakdown);
				PAGE = "/pages/genericObject.jsp";
			}else if("checkRecordStatus".equals(ACTION)){
				giacOrderOfPaymentService.checkRecordStatus(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e){
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
			System.out.println("SUCCESS");
		}
	}
	
	/**
	 * Parses the GIACAcctrans.
	 * 
	 * @param arg the arg
	 * @return the GIACAcctrans
	 */
	private GIACAccTrans parseGiacAcctrans(String arg, String appUser){
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss a");//new SimpleDateFormat("mm-dd-yyyy hh:mm:ss a"); replaced by: Nica 12.18.2012
		GIACAccTrans giacCollBatch = new GIACAccTrans();
		List<String> strs = getListPipe(arg);
		for(int x = 0; x < strs.size(); x++){
			try {
				giacCollBatch = new GIACAccTrans(
						Integer.valueOf(strs.get(x)).intValue(),
						strs.get(x+1),
						strs.get(x+2),
						sdf.parse(strs.get(x+3)),
						strs.get(x+4),
						strs.get(x+5).equals("null") ? null : strs.get(x+5),
						Integer.valueOf(strs.get(x+6)).intValue(),
						strs.get(x+7),
						Integer.valueOf(strs.get(x+8)).intValue(),
						Integer.valueOf(strs.get(x+9)).intValue(),
						Integer.valueOf(strs.get(x+10)).intValue()
				);
				giacCollBatch.setAppUser(appUser);
				System.out.println("TRANCLASS: " + strs.get(x+5));
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 10;
		}
		return giacCollBatch;
	}
	
	/**
	 * Parses the GIACCollnBatch.
	 * 
	 * @param arg the arg
	 * @return the GIACCollnBatch
	 */
	private GIACCollnBatch parseGIACCollnBatch(String arg, String appUser){
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss a");
		GIACCollnBatch giacCollBatch = new GIACCollnBatch();
		List<String> strs = getListPipe(arg);
		for(int x = 0; x < strs.size(); x++){
			
			try {
				giacCollBatch = new GIACCollnBatch(
						Integer.valueOf(strs.get(x)).intValue(),
						Integer.valueOf(strs.get(x+1)).intValue(),
						strs.get(x+2),
						strs.get(x+3),
						sdf.parse(strs.get(x+4)),
						strs.get(x+5),
						strs.get(x+6)
				);
				giacCollBatch.setAppUser(appUser);
				
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 6;
		}
		return giacCollBatch;
	}
	
	/**
	 * Parses the GIACOrderOfPayment.
	 * 
	 * @param arg the arg
	 * @return the GIACOrderOfPayment
	 */
	private GIACOrderOfPayment parseGIACOrderOfPayment(String arg, String appUser){
		System.out.println("APPUSER IS : " + appUser);
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss a");
		DateFormat sdf2 = new SimpleDateFormat("MM-dd-yyyy");
		GIACOrderOfPayment giacOrderOfPayment = new GIACOrderOfPayment();
		List<String> strs = getListPipe(arg);
		Integer intmno = null;
		Date remitDate = null;
		Integer currCd = null; //added by robert 04.09.2013
		for(int x = 0; x < strs.size(); x++){	
			try {
				if (strs.get(x+18).equals("null")){
					intmno = null;
				}else{
					intmno = Integer.parseInt(strs.get(x+18));
				}
				if (strs.get(x+21).equals("null")){
					remitDate = null;
				}else{
					remitDate = sdf2.parse(strs.get(x+21));
				}
				if (strs.get(x+17).equals("null")){ //added by robert 04.09.2013
					currCd = null;
				}else{
					currCd = Integer.parseInt(strs.get(x+17));
				}
				System.out.println("TEST PAYOR 3: "+StringFormatter.unescapeHtmlJava(strs.get(x+3)));
				giacOrderOfPayment = new GIACOrderOfPayment(
						Integer.valueOf(strs.get(x)).intValue(),
						strs.get(x+1),
						strs.get(x+2),
						StringFormatter.unescapeHtmlJava(strs.get(x+3)),
						StringFormatter.unescapeHtmlJava(strs.get(x+4)),
						StringFormatter.unescapeHtmlJava(strs.get(x+5)),
						StringFormatter.unescapeHtmlJava(strs.get(x+6)),
						StringFormatter.unescapeHtmlJava(strs.get(x+7)),
						strs.get(x+8),
						sdf.parse(strs.get(x+9)),
						Integer.valueOf(strs.get(x+10)).intValue(),
						//new BigDecimal(Integer.valueOf(strs.get(x+11)).intValue()),
						new BigDecimal(strs.get(x+11)),
						Integer.valueOf(strs.get(x+12)).intValue(),
						strs.get(x+13),
						new BigDecimal(strs.get(x+14)),
						strs.get(x+15),
						strs.get(x+16),
						//Integer.valueOf(strs.get(x+17)).intValue(), //replaced by robert 04.09.2013
						currCd, 
						intmno,
						strs.get(x+19),
						strs.get(x+20),
						remitDate,
						strs.get(x+22),
						strs.get(x+23).equals("") ? null : Long.parseLong(strs.get(x+23)) ,
						strs.get(x+24)
				);
				giacOrderOfPayment.setRiCommTag(strs.get(x+25)); // added by: Nica 06.14.2013 AC-SPECS-2012-155
				giacOrderOfPayment.setUserId(appUser);
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 25;
		}
		return giacOrderOfPayment;
	}
	
	private List<GIACCollectionDtl> parseGIACCollectionDtl(String arg, String appUser){
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		List<GIACCollectionDtl> list = new ArrayList<GIACCollectionDtl>();
		List<String> strs = getListPipe(arg);
		for(int x = 0; x < strs.size(); x++){	
			//System.out.println("CAUSE: " + strs.get(x+11));
			GIACCollectionDtl coll = null;
			try {
				//System.out.println("GIACCOLLECTIONDTL AMOUNT: ITEMNO: " + Integer.valueOf(strs.get(x+1)).intValue() + " AMOUNT: " + new BigDecimal(strs.get(x+5)));
				coll = new GIACCollectionDtl(
						Integer.valueOf(strs.get(x)).intValue(),
						Integer.valueOf(strs.get(x+1)).intValue(),
						Integer.valueOf(strs.get(x+2)).intValue(),
						new BigDecimal(strs.get(x+3)),
						strs.get(x+4),
						new BigDecimal(strs.get(x+5)),		
						strs.get(x+6).equals("-") ? null : sdf.parse(strs.get(x+6)),
						strs.get(x+7),
						strs.get(x+8),
						strs.get(x+9),
						strs.get(x+10).equals("-") ? null : strs.get(x+10),
						new BigDecimal(strs.get(x+11)),
						new BigDecimal(strs.get(x+12)),
						new BigDecimal(strs.get(x+13)),
						new BigDecimal(strs.get(x+14)),
						new BigDecimal(strs.get(x+15)),
						new BigDecimal(strs.get(x+16)),
						new BigDecimal(strs.get(x+17)),
						strs.get(x+18),
						strs.get(x+19)
				);
				coll.setCmTranId(strs.get(x+20).equals("") ? null : Integer.valueOf(strs.get(x+20)).intValue());
				coll.setItemId(strs.get(x+21).equals("") ? null : Integer.valueOf(strs.get(x+21)).intValue());
				coll.setAppUser(appUser);
				System.out.println("Test Nica TranId: "+coll.getCmTranId());
				list.add(coll);
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
			x = x + 21;
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
		//for (String str: list){
		//	log.info("List Elem:"+ str);
		//};
		log.info("List : " + list.toString());
		return list;
	}
}
