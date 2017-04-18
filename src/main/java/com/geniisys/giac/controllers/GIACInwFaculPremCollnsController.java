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

import com.geniisys.common.entity.GIISReinsurer;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACInwFaculPremCollns;
import com.geniisys.giac.service.GIACInwFaculPremCollnsService;
import com.geniisys.giac.service.GIACOrderOfPaymentService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACUserFunctionsService;
import com.geniisys.gipi.service.GIPIInstallmentService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACInwFaculPremCollnsController extends BaseController{
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACInwFaculPremCollnsController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		
		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			String strGaccTranId = request.getParameter("globalGaccTranId") == null ? "0" : request.getParameter("globalGaccTranId");
			Integer gaccTranId= strGaccTranId.trim().equals("") ? 0 : Integer.parseInt(strGaccTranId);
			String gaccBranchCd = request.getParameter("globalGaccBranchCd") == null ? "" :request.getParameter("globalGaccBranchCd");
			String gaccFundCd = request.getParameter("globalGaccFundCd") == null ? "" :request.getParameter("globalGaccFundCd");
			
			log.info("Tran ID   : " + gaccTranId);
			log.info("Branch Cd : " + gaccBranchCd);
			log.info("Fund Cd   : " + gaccFundCd);
			log.info("USER ID   : " + USER.getUserId());
			
			if ("showInwFaculPremCollns".equals(ACTION)) {
				log.info("Getting Inward Facultative records.");
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				
				List<GIACInwFaculPremCollns> giacInwfaculCollns = giacInwFaculPremCollnsService.getGIACInwFaculPremCollns(gaccTranId,USER); //added by steven 09.01.2014
				
				request.setAttribute("gaccTranId", gaccTranId);
				request.setAttribute("taxAllocation", giacParamService.getParamValueV2("TAX_ALLOCATION"));
				String[] rvDomain = {"GIAC_INWFACUL_PREM_COLLNS.TRANSACTION_TYPE"};
				request.setAttribute("transactionTypeList", helper.getList(LOVHelper.RISK_TAG_LISTING,rvDomain));
				request.setAttribute("reinsurerList", new JSONArray((List<GIISReinsurer>) StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.REINSURER_LISTING))));
				request.setAttribute("reinsurerList2", helper.getList(LOVHelper.REINSURER_LISTING2));
				//request.setAttribute("instNo", helper.getList(LOVHelper.INST_NO_LISTING));
				request.setAttribute("giacInwfaculCollns", giacInwfaculCollns);
				request.setAttribute("allowPaytCancRiPol", giacParamService.getParamValueV2("ALLOW_PAYT_OF_CANCELLED_RI_POL"));
				request.setAttribute("premPaytForRiSpecial", giacParamService.getParamValueV2("PREM_PAYT_FOR_RI_SPECIAL"));
				PAGE = "/pages/accounting/officialReceipt/riTrans/inwFaculPremCollns.jsp";
			}else if("showInwFaculPremCollnsTableGrid".equals(ACTION)){
				log.info("Getting Inward Facultative records for table grid.");
				Map <String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIACInwFaculPremCollnsTableGrid");
				params.put("gaccTranId", gaccTranId);
				params.put("userId", USER.getUserId()); //added by steven 09.01.2014
				
				Map <String, Object> premCollections = TableGridUtil.getTableGrid(request, params);
				JSONObject giacInwfaculCollns = new JSONObject(premCollections);
				
				if("1".equals(request.getParameter("ajax"))){
					LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
					GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
					
					request.setAttribute("gaccTranId", gaccTranId);
					request.setAttribute("taxAllocation", giacParamService.getParamValueV2("TAX_ALLOCATION"));
					String[] rvDomain = {"GIAC_INWFACUL_PREM_COLLNS.TRANSACTION_TYPE"};
					request.setAttribute("transactionTypeList", helper.getList(LOVHelper.RISK_TAG_LISTING,rvDomain));
					request.setAttribute("reinsurerList", new JSONArray((List<GIISReinsurer>) StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.REINSURER_LISTING))));
					request.setAttribute("reinsurerList2", helper.getList(LOVHelper.REINSURER_LISTING2));
					//request.setAttribute("instNo", helper.getList(LOVHelper.INST_NO_LISTING));
					request.setAttribute("giacInwfaculCollns", giacInwfaculCollns);
					//request.setAttribute("otherInwPremCollnsList", giacInwFaculPremCollnsService.getOtherInwFaculPremCollns(gaccTranId)); replaced by JSONArray to be able to read object in JSP by MAC 01/18/2013. 
					//request.setAttribute("otherInwPremCollnsList", new JSONArray((List<GIACInwFaculPremCollns>) StringFormatter.replaceQuotesInList(giacInwFaculPremCollnsService.getOtherInwFaculPremCollns(gaccTranId)))); removed by pjsantos 12/12/2016, otherInwPremCollnsList is no longer used in JSP, for optimization GENQA 5891
					request.setAttribute("allowPaytCancRiPol", giacParamService.getParamValueV2("ALLOW_PAYT_OF_CANCELLED_RI_POL"));
					request.setAttribute("premPaytForRiSpecial", giacParamService.getParamValueV2("PREM_PAYT_FOR_RI_SPECIAL"));
					//Deo [01.20.2017]: add start (SR-5909)
					GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT.getBean("giacUserFunctionsService");
					request.setAttribute("hasCCFnc", giacUserFunctionsService.checkIfUserHasFunction("CC", "GIACS008", USER.getUserId()));
					request.setAttribute("hasAOFnc", giacUserFunctionsService.checkIfUserHasFunction("AO", "GIACS008", USER.getUserId()));
					request.setAttribute("chkPremAging", giacParamService.getParamValueV2("CHECK_PREMIUM_AGING"));
					request.setAttribute("chkBillDueDate", giacParamService.getParamValueN("BILL_PREMIUM_OVERDUE"));
					request.setAttribute("giacs008UpdBtn", giacParamService.getParamValueV2("GIACS008_BUT"));
					//Deo [01.20.2017]: add ends (SR-5909)
					PAGE = "/pages/accounting/officialReceipt/riTrans/inwFaculPremCollnsTableGrid.jsp";
				}else{
					message = giacInwfaculCollns.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("openSearchInvoiceModal".equals(ACTION)){
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchInvoiceInwardFacul.jsp";
			}else if ("getInvoiceInwardListing".equals(ACTION)){
				log.info("Getting Invoice Listing records.");
			    //editted by steven 11.07.2013
				//GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("ACTION", "getInvoiceListTableGrid");
				params.put("a180RiCd", request.getParameter("a180RiCd"));
				params.put("b140IssCd", request.getParameter("b140IssCd"));
				params.put("transactionType", request.getParameter("transactionType"));
				params.put("b140PremSeqNoInw", request.getParameter("b140PremSeqNoInw"));
				params.put("userId", USER.getUserId()); //added by steven 09.01.2014
				//log.info("Parameters: "+params);
				/*String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				PaginatedList searchResult = null;
				searchResult = giacInwFaculPremCollnsService.getInvoiceList(params,pageNo);
				request.setAttribute("keyword", keyword);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());*/
				
				/*Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				params.put("currentPage", page);
				params.put("filter", request.getParameter("objFilter"));
				params = giacInwFaculPremCollnsService.getInvoiceListTableGrid(params);*/
				Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(map);
				request.setAttribute("invoiceListTableGrid", json);
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchInvoiceInwardFaculAjaxResult.jsp";
			}else if ("openSearchInstNoModal".equals(ACTION)){
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchInstNoInwardFacul.jsp";
			}else if ("getInstNoInwardListing".equals(ACTION)){
				log.info("Getting Installment Listing records.");
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				
				String keyword = request.getParameter("keyword").replaceFirst("^0+(?!$)", "");
				//for iss_cd + prem_no keyword
				String[] kWordArr = keyword.split("-");
				if(kWordArr.length == 2){
					keyword = "";
					for(int i = 0; i < kWordArr.length; i ++){
						keyword += kWordArr[i].replaceFirst("^0+(?!$)", "");
					}
				}
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("a180RiCd", request.getParameter("a180RiCd"));
				params.put("b140IssCd", request.getParameter("b140IssCd"));
				params.put("transactionType", request.getParameter("transactionType"));
				params.put("b140PremSeqNoInw", request.getParameter("b140PremSeqNoInw"));
				params.put("keyword", keyword);
				log.info("Parameters: "+params);
				
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				PaginatedList searchResult = null;
				searchResult = giacInwFaculPremCollnsService.getInstNoList(params,pageNo);
				request.setAttribute("keyword", request.getParameter("keyword"));
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchInstNoInwardFaculAjaxResult.jsp";
			}else if ("validateInvoice".equals(ACTION)){
				log.info("Validating Invoice.");
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("a180RiCd", request.getParameter("a180RiCd"));
				params.put("b140IssCd", request.getParameter("b140IssCd"));
				params.put("transactionType", request.getParameter("transactionType"));
				params.put("b140PremSeqNoInw", request.getParameter("b140PremSeqNoInw"));
				log.info("Parameters: "+params);
				message = giacInwFaculPremCollnsService.validateInvoice(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateInvoice2".equals(ACTION)){
				log.info("Validating Invoice...2");
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("a180RiCd", request.getParameter("a180RiCd"));
				params.put("b140IssCd", request.getParameter("b140IssCd"));
				params.put("transactionType", request.getParameter("transactionType"));
				params.put("b140PremSeqNoInw", request.getParameter("b140PremSeqNoInw"));
				params.put("userId", USER.getUserId()); //added by steven 09.01.2014
				log.info("Parameters: "+params);
				message = giacInwFaculPremCollnsService.validateInvoice(params);
				if(message == null){
					System.out.println("Params after: " + params);
					Map<String, Object> invoiceMap = new HashMap<String, Object>();
					invoiceMap =  giacInwFaculPremCollnsService.getInvoice(params);
					
					String messageDelimiter = ApplicationWideParameters.RESULT_MESSAGE_DELIMITER;
					message =  ""+messageDelimiter+invoiceMap.get("assdName")+messageDelimiter+invoiceMap.get("assdNo")+messageDelimiter+invoiceMap.get("drvPolicyNo")+messageDelimiter+invoiceMap.get("drvPolicyNo2")+messageDelimiter+invoiceMap.get("instNo");
					System.out.println("MESSAGE: " + message);
				}
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateInstNo".equals(ACTION)){
				log.info("Validating Installment No.");
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("a180RiCd", request.getParameter("a180RiCd"));
				params.put("b140IssCd", request.getParameter("b140IssCd"));
				params.put("transactionType", request.getParameter("transactionType"));
				params.put("b140PremSeqNoInw", request.getParameter("b140PremSeqNoInw"));
				params.put("instNo", request.getParameter("instNo"));
				log.info("Parameters: "+params);
				
				HashMap<String, Object> result = new HashMap<String, Object>();
				result = giacInwFaculPremCollnsService.validateInstNo(params);
				BigDecimal collectionAmt = (BigDecimal) result.get("collectionAmt");
				BigDecimal premiumAmt = (BigDecimal) result.get("premiumAmt");
				BigDecimal premTax = (BigDecimal) result.get("premTax");
				BigDecimal wholdingTax = (BigDecimal) result.get("wholdingTax");
				BigDecimal commAmt = (BigDecimal) result.get("commAmt");
				BigDecimal foreignCurrAmt = (BigDecimal) result.get("foreignCurrAmt");
				BigDecimal taxAmount = (BigDecimal) result.get("taxAmount");
				BigDecimal commVat = (BigDecimal) result.get("commVat");
				String vMsgAlert = (String) result.get("vMsgAlert");
				BigDecimal assdNo = (BigDecimal) result.get("assdNo");
				String assdName = (String) result.get("assdName");
				String drvPolicyNo = (String) result.get("drvPolicyNo");
				BigDecimal convertRate = (BigDecimal) result.get("convertRate");
				BigDecimal currencyCd = (BigDecimal) result.get("currencyCd");
				String currencyDesc = (String) result.get("currencyDesc");
				
				//Deo [01.20.2017]: add start (SR-5909)
				GIPIPolbasicService gipiPolService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				GIPIInstallmentService gipiInstallService = (GIPIInstallmentService) APPLICATION_CONTEXT.getBean("gipiInstallmentService");
				HashMap<String, Object> params2 =  new HashMap<String, Object>();
				params2.put("issCd", request.getParameter("b140IssCd"));
				params2.put("premSeqNo", request.getParameter("b140PremSeqNoInw"));
				params2.put("instNo", request.getParameter("instNo"));
				params2.put("tranDate", request.getParameter("tranDate"));
				String hasClaim = gipiPolService.checkClaim(params2);
				Integer daysOverDue = gipiInstallService.getDaysOverdue(params2);
				//Deo [01.20.2017]: add ends (SR-5909)
				
				String messageDelimiter = ApplicationWideParameters.RESULT_MESSAGE_DELIMITER;
				message = collectionAmt+messageDelimiter+premiumAmt+messageDelimiter+premTax+messageDelimiter+wholdingTax+messageDelimiter+commAmt+messageDelimiter+foreignCurrAmt+messageDelimiter+taxAmount+messageDelimiter+commVat+messageDelimiter+vMsgAlert+
					messageDelimiter+assdNo+messageDelimiter+assdName+messageDelimiter+drvPolicyNo+messageDelimiter+convertRate+messageDelimiter+currencyCd+messageDelimiter+currencyDesc+messageDelimiter+hasClaim+messageDelimiter+daysOverDue; //Deo [01.20.2017]: hasClaim & daysOverDue (SR-5909)
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveInwardFacul".equals(ACTION)){
				log.info("Saving Inward Faculative Prem Collns.");
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				List<GIACInwFaculPremCollns> inwFaculItems = new ArrayList<GIACInwFaculPremCollns>();
				inwFaculItems = giacInwFaculPremCollnsService.prepareInsertInwItems(request, response, USER);
				List<GIACInwFaculPremCollns> inwFaculDelItems = new ArrayList<GIACInwFaculPremCollns>();
				inwFaculDelItems = giacInwFaculPremCollnsService.prepareDelInwItems(request, response, USER);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("inwFaculItems",inwFaculItems);
				params.put("inwFaculDelItems", inwFaculDelItems);
				params.put("gaccTranId", gaccTranId);
				params.put("globalTranSource", request.getParameter("globalTranSource"));
				params.put("globalOrFlag", request.getParameter("globalOrFlag"));
				params.put("globalGaccBranchCd", gaccBranchCd); 
				params.put("globalGaccFundCd", gaccFundCd); 
				params.put("userId", USER.getUserId());
				System.out.println("PARAMS SAVE: " + params.toString());
				message = giacInwFaculPremCollnsService.saveInwardFacul(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveInwardFacul2".equals(ACTION)){
				log.info("Saving Inward Faculative Prem Collns.");
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				JSONObject objParams = new JSONObject(request.getParameter("params"));
				System.out.println("OBJ PARAMS: " + objParams);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("inwFaculDelItems", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delParams")), USER.getUserId(), GIACInwFaculPremCollns.class));
				params.put("inwFaculItems", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setParams")), USER.getUserId(), GIACInwFaculPremCollns.class));
				params.put("gaccTranId", gaccTranId);
				params.put("globalTranSource", request.getParameter("globalTranSource"));
				params.put("globalOrFlag", request.getParameter("globalOrFlag"));
				params.put("globalGaccBranchCd", gaccBranchCd); 
				params.put("globalGaccFundCd", gaccFundCd); 
				params.put("userId", USER.getUserId());
				System.out.println("PARAMS SAVE: " + params.toString());
				message = giacInwFaculPremCollnsService.saveInwardFacul(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getRelatedInwPremColl".equals(ACTION)){
				
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giacInwFaculPremCollnsService.getRelatedInwFaculPremCollns(params);
				JSONObject inwFaculPremCollnsObject = new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params));
				request.setAttribute("gipiRelatedInwFaculPremCollnsTableGrid",inwFaculPremCollnsObject );
				if(request.getParameter("lineCd").equals("SU")){
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedInwFaculPremCollnsTableSu.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedInwFaculPremCollnsTable.jsp";
				}
				
			} else if ("refreshRelatedInwFaculPremColl".equals(ACTION)){
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("issCd",request.getParameter("issCd"));
				params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = giacInwFaculPremCollnsService.getRelatedInwFaculPremCollns(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if ("refreshInvoiceListing".equals(ACTION)){
				//editted by steven 11.06.2013
//				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getInvoiceListTableGrid");
				params.put("a180RiCd", request.getParameter("a180RiCd"));
				params.put("b140IssCd", request.getParameter("b140IssCd"));
				params.put("transactionType", request.getParameter("transactionType"));
				params.put("b140PremSeqNoInw", request.getParameter("b140PremSeqNoInw"));
				params.put("userId", USER.getUserId()); //added by steven 09.01.2014
				/*Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				params.put("currentPage", page);
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("filter", request.getParameter("objFilter"));
				System.out.println("steven test:" + params);
				params = giacInwFaculPremCollnsService.getInvoiceListTableGrid(params);
				JSONObject json = new JSONObject(params);*/
				Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(map);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkPremPaytForRiSpecial".equals(ACTION)){ //added john 11.3.2014
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				message = giacInwFaculPremCollnsService.checkPremPaytForRiSpecial(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkPremPaytForCancelled".equals(ACTION)){ //added john 11.3.2014
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				message = giacInwFaculPremCollnsService.checkPremPaytForCancelled(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateDelete".equals(ACTION)){ //added john 2.24.2015
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				message = giacInwFaculPremCollnsService.validateDelete(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkClaimAndOverDue".equals(ACTION)) { //Deo [01.20.2017]: SR-5909
				GIPIPolbasicService gipiPolService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				GIPIInstallmentService gipiInstallService = (GIPIInstallmentService) APPLICATION_CONTEXT.getBean("gipiInstallmentService");
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("premSeqNo", request.getParameter("premSeqNo"));
				params.put("instNo", request.getParameter("instNo"));
				params.put("tranDate", request.getParameter("tranDate"));
				String hasClaim = gipiPolService.checkClaim(params);
				Integer daysOverDue = gipiInstallService.getDaysOverdue(params);
				String messageDelimiter = ApplicationWideParameters.RESULT_MESSAGE_DELIMITER;
				message = hasClaim+messageDelimiter+daysOverDue;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updateOrDtls".equals(ACTION)) { //Deo [01.20.2017]: SR-5909
				GIACInwFaculPremCollnsService giacInwFaculPremCollnsService = (GIACInwFaculPremCollnsService) APPLICATION_CONTEXT.getBean("giacInwFaculPremCollnsService");
				message = new JSONObject(giacInwFaculPremCollnsService.updateOrDtls(request)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (SQLException e) {
			/*message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";*/
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
		//} catch (ParseException e) {
		//	message = "Date Parse Exception occured...<br />"+e.getCause();
		//	PAGE = "/pages/genericMessage.jsp";
		//	e.printStackTrace();
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}	
	
}
