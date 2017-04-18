/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GIACS017
 * Create Date	:	October 6, 2010
 ***************************************************/
package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
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
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACDirectClaimPayment;
import com.geniisys.giac.service.GIACDirectClaimPaymentService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gicl.entity.GICLAdvice;
import com.geniisys.gicl.entity.GICLClaimLossExpense;
import com.geniisys.gicl.entity.GICLClaims;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACDirectClaimPaymentController extends BaseController{

	private static final long serialVersionUID = 1L;

	/** The log. */
	private static Logger log = Logger.getLogger(GIACDirectClaimPaymentController.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings({"deprecation", "unused"})
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			final String moduleNameParameter = "GIACS017";
			/* default attributes */
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACDirectClaimPaymentService giacDirectClaimPaymentService = (GIACDirectClaimPaymentService) APPLICATION_CONTEXT.getBean(GIACDirectClaimPaymentService.class);
			GIACParameterFacadeService giacParameterFacadeService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean(GIACParameterFacadeService.class);
			LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			
			log.info("action: " + ACTION);
			
			System.out.println("============================================================================================");
			System.out.println("Direct Claim Payments....");
			System.out.println("Action = " + ACTION);
			
			if("showDirectClaimPayments".equals(ACTION)){
				log.info("showDirectClaimPayments");
				Integer gaccTranId = Integer.parseInt( (request.getParameter("gaccTranId").equals(""))? "0" : request.getParameter("gaccTranId"));
				List<GIACDirectClaimPayment> dcps = giacDirectClaimPaymentService.getDirectClaimPaymentByGaccTranId(APPLICATION_CONTEXT,gaccTranId);
				Iterator<GIACDirectClaimPayment> iter = dcps.iterator();
				
				List<GICLClaims> claimList = new ArrayList<GICLClaims>();
				List<GICLAdvice> adviceLst = new ArrayList<GICLAdvice>();
				List<GICLClaimLossExpense> claimLossExpList = new ArrayList<GICLClaimLossExpense>();
				GIACDirectClaimPayment claimPayment = null;
				GICLClaimLossExpense claimLossExp = null;
				GICLClaims claims 	= null;
				GICLAdvice advice	= null;
		
				while(iter.hasNext()){
					claimPayment = iter.next();
					System.out.println("**------");
					claimPayment.displayDetailsInConsole();

					claimLossExp = claimPayment.getGiclClaimLossExpense();
					if(claimLossExp!=null){
						System.out.println(">>> NOT NULL");
					}else{
						System.out.println(">>> NULL");
					}
					claims = claimPayment.getGiclClaims();
					advice = claimPayment.getGiclAdvice();
					advice.getAdviceNo();

					claimList.add(claims);
					adviceLst.add(advice);
					claimLossExpList.add(claimLossExp);
				}
				
				log.info("array lengths (must be similar): " + dcps.size() + " " + adviceLst.size() + " " + claimList.size() + " " + claimLossExpList.size());
				
				request.setAttribute("claimLossExpenses", new JSONArray(claimLossExpList));
				request.setAttribute("advices", new JSONArray(adviceLst));
				request.setAttribute("claims", new JSONArray(claimList));
				request.setAttribute("directClaimPayments", new JSONArray(dcps));
				
				// 	TRANSACTION TYPE - LOV		
				String[] transactionTypeParam = {"GIAC_DIRECT_CLAIM_PAYTS.TRANSACTION_TYPE"};
				request.setAttribute("transactionTypeLOV", helper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, transactionTypeParam));
				
				// ADVICE LINE CD - LOV
				List<LOV> lovList = helper.getList(LOVHelper.ADVICE_LINE_LISTING);
				request.setAttribute("adviceLineLOV", lovList);
				
				// ADVICE ISSUE CODE - LOV 
				String[] issCdParams = { moduleNameParameter };
				request.setAttribute("adviceIssCdLOV1", new JSONArray(helper.getList(LOVHelper.ADVICE_ISSCD_LISTING, issCdParams)));
				request.setAttribute("adviceIssCdLOV2", new JSONArray(helper.getList(LOVHelper.ADVICE_ISSCD_LISTING2, issCdParams)));

				request.setAttribute("varIssCd", giacParameterFacadeService.getParamValueV2("RI_ISS_CD"));
				request.setAttribute("varCurrencyCd", giacParameterFacadeService.getParamValueN("CURRENCY_CD"));
				
				request.setAttribute("currencyCodesLOV", helper.getList(LOVHelper.CURRENCY_CODES));
				PAGE = "/pages/accounting/officialReceipt/directTrans/directClaimPayments.jsp";
			}/*else if("filterAdviceSequence".equals(ACTION)){
				log.info("filtering advice sequence");
				String transType = request.getParameter("transType");
				String[] args = {moduleNameParameter, request.getParameter("adviceLineCd"), request.getParameter("adviceIssCd"), request.getParameter("adviceYear")};

				if(transType.equals("1")){
					request.setAttribute("adviceSequenceJsonObj", new JSONArray(helper.getList(LOVHelper.ADVICE_SEQ_LISTING, args)));
				}else if(transType.equals("2")){
					request.setAttribute("adviceSequenceJsonObj", new JSONArray(helper.getList(LOVHelper.ADVICE_SEQ_LISTING2, args)));
				}
				message = "SUCCESS";
				PAGE = "/pages/accounting/officialReceipt/directTrans/dynamicDropdown/adviceSequenceByYear.jsp";
			}*/else if(("filterPayeeClass").equals(ACTION)){
				log.info("filtering payee class");

				String transType = 	request.getParameter("transType");
				String lineCd = 	request.getParameter("lineCd");
				String adviceId = 	request.getParameter("adviceId");
				String claimId = 	request.getParameter("claimId");

				if(lineCd == null || lineCd.isEmpty()){
					lineCd = "AH";
				}
				
				String[] args = {lineCd,adviceId,claimId}; // error here
				
				if(transType.equals("1")){
					request.setAttribute("payeeClassJsonObj", new JSONArray(helper.getList(LOVHelper.CLAIM_LOSS_LISTING, args)));
				}else if(transType.equals("2")){
					request.setAttribute("payeeClassJsonObj", new JSONArray(helper.getList(LOVHelper.CLAIM_LOSS_LISTING2, args)));
				}
				
				GICLClaims claims = giacDirectClaimPaymentService.getClaimDetails(Integer.parseInt(claimId));
				if(claims != null){
					String claimNumber =	claims.getLineCode() + "-" + claims.getSublineCd() + "-" + 
											claims.getIssCd() + "-" + 
											StringFormatter.zeroPad(claims.getClaimYy(), 2) + "-" + 
											StringFormatter.zeroPad(claims.getClaimSequenceNo(), 7);
					
					String policyNumber = 	claims.getLineCode() + "-" + claims.getSublineCd() + "-" + 
											claims.getIssCd() + "-" + 
											StringFormatter.zeroPad(claims.getClaimYy(),2) + "-" + 
											StringFormatter.zeroPad(claims.getPolicySequenceNo(),7) + "-" + 
											StringFormatter.zeroPad(claims.getRenewNo(),2);
					
					request.setAttribute("policyNumber", policyNumber);
					request.setAttribute("claimNumber", claimNumber);
					request.setAttribute("assuredName", claims.getAssuredName());
				}else{
					System.out.println(".##..claimsizNULL");
				}
				message = "SUCCESS";
				PAGE = "/pages/accounting/officialReceipt/directTrans/dynamicDropdown/payeeClassByAdviceSequence.jsp";
				
			}else if("computeAdviceAmounts".equals(ACTION)){
				log.info("Computing inputVat, withholdingTax and netDisbursement amounts");
				
				Integer vCheck			= Integer.parseInt(request.getParameter("vCheck")); // IN OUT
				Integer transactionType = Integer.parseInt(request.getParameter("transactionType")); 	// IN
				Integer gaccTransId		= Integer.parseInt(request.getParameter("gaccTranId"));			// IN
				Integer claimId			= Integer.parseInt(request.getParameter("claimId"));			// IN
				Integer claimLossId		= Integer.parseInt(request.getParameter("claimLossId"));		// IN
				Integer adviceId		= Integer.parseInt(request.getParameter("adviceId"));			// IN
				
				// Row display amts
				BigDecimal inputVatAmount = 
					new BigDecimal(request.getParameter("inputVatAmount")!=null  ? request.getParameter("inputVatAmount") : "0"); // may be null
				BigDecimal withholdingTaxAmount = 
					new BigDecimal(request.getParameter("withholdingTaxAmount")!=null ? request.getParameter("withholdingTaxAmount") : "0"); 
				BigDecimal netDisbursementAmount = 
					new BigDecimal(request.getParameter("netDisbursementAmount")!=null ? request.getParameter("netDisbursementAmount") : "0");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("vCheck", vCheck);
				params.put("claimId", claimId);
				params.put("adviceId", adviceId);
				params.put("gaccTransId", gaccTransId);
				params.put("claimLossId", claimLossId);
				params.put("inputVatAmount", inputVatAmount);
				params.put("transactionType", transactionType);
				params.put("withholdingTaxAmount", withholdingTaxAmount);
				params.put("netDisbursementAmount", netDisbursementAmount);
				params.put("appUser", USER.getUserId()); // andrew - 03.14.2011 - for application user;
				
				params = giacDirectClaimPaymentService.computeAdviceDefaultAmount(params);
				
				if(request.getParameter("toObject").equals("Y")) {
					message = new JSONObject(params).toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("inputVatAmount", (BigDecimal)params.get("inputVatAmount"));
					request.setAttribute("withholdingTaxAmount", (BigDecimal)params.get("withholdingTaxAmount"));
					request.setAttribute("netDisbursementAmount", (BigDecimal)params.get("netDisbursementAmount"));
					request.setAttribute("totalNetDisbursementAmount", (BigDecimal)params.get("totalNetDisbursementAmount"));
					request.setAttribute("totalInputVatAmount", (BigDecimal)params.get("sumInputVatAmount"));
					request.setAttribute("totalWithholdingTaxAmount", (BigDecimal)params.get("totalWithholdingTaxAmount"));
					PAGE = "/pages/accounting/officialReceipt/directTrans/dynamicDropdown/adviceDisbursementAmountValues.jsp";
				}
			}else if("openSearchAdviceModalBox".equals(ACTION)){
				log.info("Opening Search Advice Modal Box");
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchAdviceNoDcp.jsp";
			}else if("getAdviceSequenceListing".equals(ACTION)){
				log.info("Get Advice Sequence Search Result Listing - Modal Box");
				String keyword = request.getParameter("keyword");
				keyword.trim();
				//List<GIACDirectClaimPayment> existingDcps = giacDirectClaimPaymentService.prepareDirectClaimPaymentJSON(new JSONArray(request.getParameter("dcps")), USER.getUserId());
				String existingDcps =  request.getParameter("dcps");
				
				if(existingDcps ==null){
					System.out.println("DCP from screen IS NULL~~");
				}else{
					System.out.println("DCP from screen NOT NULL~~");
				}
				
				if(keyword == null){
					keyword = new String("");
				}
				
				String strPageNo = request.getParameter("pageNo");
				if(strPageNo == null){
					strPageNo = new String("1");
				}
				
				Integer pageNo = Integer.parseInt(strPageNo);
				PaginatedList searchResult = null;
				searchResult = giacDirectClaimPaymentService.getAdviceSequenceListing("GIACS017", keyword.trim(), pageNo);

				request.setAttribute("keyword", keyword);
				request.setAttribute("pageNo", searchResult.getPageIndex());
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				JSONArray searchResultJSON  = new JSONArray(searchResult);
				request.setAttribute("searchResultJSON", searchResultJSON);
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchAdviceNoDcpAjaxResult.jsp";
			}else if("preInsertGIACS017".equals(ACTION)){
				/*	String[] claimIds 		= request.getParameterValues("dcpClaimId");
					String[] adviceIds 		= request.getParameterValues("dcpAdviceSequenceNumber");
					String[] adviceNumbers 	= request.getParameterValues("dcpAdviceNumber");
				*/
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveDirectClaimPayments".equals(ACTION)){
				giacDirectClaimPaymentService.saveDirectClaimPayments(request, USER.getUserId());
				//this.displayContentsInSysout(setRow);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("getClaimDetail".equals(ACTION)) {
				Integer claimId = 	Integer.parseInt(request.getParameter("claimId"));
				GICLClaims claims = giacDirectClaimPaymentService.getClaimDetails(claimId);
				String claimNumber = "";
				String policyNumber = "";
				if(claims != null){
					claimNumber =	claims.getLineCode() + "-" + claims.getSublineCd() + "-" + 
											claims.getIssCd() + "-" + 
											StringFormatter.zeroPad(claims.getClaimYy(), 2) + "-" + 
											StringFormatter.zeroPad(claims.getClaimSequenceNo(), 7);
					
					policyNumber = 	claims.getLineCode() + "-" + claims.getSublineCd() + "-" + 
											claims.getIssCd() + "-" + 
											StringFormatter.zeroPad(claims.getClaimYy(),2) + "-" + 
											StringFormatter.zeroPad(claims.getPolicySequenceNo(),7) + "-" + 
											StringFormatter.zeroPad(claims.getRenewNo(),2);
				}
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimNo", claimNumber);
				params.put("policyNo", policyNumber);
				params.put("assured", claims == null ? "" : claims.getAssuredName());
				message = new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showClaimAdviceModal".equals(ACTION)) {
				giacDirectClaimPaymentService.showClaimAdviceModal(request, USER.getUserId());
				PAGE=request.getParameter("refresh").equals("1") ? "/pages/genericObject.jsp" : "/pages/accounting/officialReceipt/directTrans/directClaimPayts/claimAdviceListing.jsp";
			} else if ("showDirectClaimPayts".equals(ACTION)) {
				// new giacs017
				log.info("showDirectClaimPayments");
				giacDirectClaimPaymentService.newFormInstanceGIACS017(request, giacParameterFacadeService, helper, USER.getUserId());
				PAGE = "/pages/accounting/officialReceipt/directTrans/directClaimPayts/directClaimPayts.jsp";
			} else if ("refreshGDCPTableGrid".equals(ACTION)) {
				System.out.println("Refresg GDCP Table Grid...");
				giacDirectClaimPaymentService.getGICLDirectClaimPaytTG(request);
				PAGE = "/pages/genericObject.jsp";
			} else if ("getDCPDetailsFromAdvice".equals(ACTION)) {
				System.out.println("Retrieving GDCP Details from advice...");
				JSONArray dcpRows = new JSONArray(giacDirectClaimPaymentService.getDCPFromAdvice(request.getParameter("addedAdvice"), USER.getUserId()));
				request.setAttribute("object", dcpRows);
				PAGE = "/pages/genericObject.jsp";
			} else if ("showBatchClaimModal".equals(ACTION)) {
				giacDirectClaimPaymentService.showBatchClaimModal(request, USER.getUserId());
				PAGE=request.getParameter("refresh").equals("1") ? "/pages/genericObject.jsp" : "/pages/accounting/officialReceipt/directTrans/directClaimPayts/batchClaimListing.jsp";
			} else if ("getEnteredAdviceDetails".equals(ACTION)) {
				System.out.println("Getting entered advice details...");
				message = new JSONObject(giacDirectClaimPaymentService.getEnteredAdviceDetails(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getDCPDetailsFromBatch".equals(ACTION)) {
				System.out.println("Retrieving GDCP Details from batch..."+request.getParameter("batchClaims"));
				JSONArray dcpRows = new JSONArray(giacDirectClaimPaymentService.getDCPFromBatch(request.getParameter("batchClaims"), USER.getUserId()));
				request.setAttribute("object", dcpRows);
				PAGE = "/pages/genericObject.jsp";
			} else if ("getListOfPayees".equals(ACTION)) {
				JSONArray listOfPayees = new JSONArray(giacDirectClaimPaymentService.getListOfPayees(request));
				request.setAttribute("object", listOfPayees);
				PAGE = "/pages/genericObject.jsp";
			}
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}