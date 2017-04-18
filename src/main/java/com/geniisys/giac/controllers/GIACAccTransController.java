package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
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

import com.geniisys.common.entity.CGRefCodes;
import com.geniisys.common.entity.GIISCurrency;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.common.service.GIISUserIssCdService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.giac.entity.GIACAccTrans;
import com.geniisys.giac.service.GIACAccTransService;
import com.geniisys.giac.service.GIACDCBBankDepService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACAccTransController extends BaseController {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	Logger log = Logger.getLogger(GIACAccTransController.class);

	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try {
			if ("refreshDCBListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", (currentPage == 0) ? 1 : currentPage);
				params.put("filter", request.getParameter("objFilter"));
				params.put("userId", USER.getUserId());
				params = accTransService.getDCBListTableGridMap(params);

				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showDCBListing".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				
				// table grid
				Map<String, Object> tableGridParams = new HashMap<String, Object>();
				tableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				tableGridParams.put("filter", request.getParameter("objFilter"));
				tableGridParams.put("userId", USER.getUserId());
				tableGridParams = accTransService.getDCBListTableGridMap(tableGridParams);
				
				request.setAttribute("dcbListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(tableGridParams)));
				
				PAGE = "/pages/accounting/dcbList/dcbListing.jsp";
			} else if ("editDCBInformation".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				GIACDCBBankDepService dcbBankDepService = (GIACDCBBankDepService) APPLICATION_CONTEXT.getBean("giacDCBBankDepService");
				String strTranId = request.getParameter("gaccTranId") == null ? new String("") : request.getParameter("gaccTranId");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				Integer gaccTranId = 0;
				
				if (!strTranId.isEmpty()) {
					gaccTranId = new Integer(strTranId);
				}
				
				// load dcb info				
				GIACAccTrans accTrans = accTransService.getGiacAcctransDtl(gaccTranId);
				
				// load GICD_SUM block listing
				Map<String, Object> gicdSumTableGridParams = new HashMap<String, Object>();
				gicdSumTableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				gicdSumTableGridParams.put("gibrBranchCd", (accTrans == null) ? null : accTrans.getBranchCd());
				gicdSumTableGridParams.put("gfunFundCd", (accTrans == null) ? null : accTrans.getGfunFundCd());
				gicdSumTableGridParams.put("dcbNo", (accTrans == null) ? null : accTrans.getTranClassNo());
				gicdSumTableGridParams.put("dcbDate",(accTrans == null) ? null : new SimpleDateFormat("MM-dd-yyyy").format(accTrans./*getTranDate*/getDcbDate())); //Deo [09.01.2016]: replace getTranDate with getDcbDate (SR-5631)
				
				gicdSumTableGridParams = accTransService.getGicdSumListTableGridMap(gicdSumTableGridParams);
				
				// load GDBD block listing
				Map<String, Object> gdbdTableGridParams = new HashMap<String, Object>();
				gdbdTableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				gdbdTableGridParams.put("gaccTranId", (accTrans == null) ? null : accTrans.getTranId());
				
				gdbdTableGridParams = dcbBankDepService.getGdbdSumListTableGridMap(gdbdTableGridParams);
				
				if (accTrans == null) {
					request.setAttribute("tranFlagMean", accTransService.getTranFlagMean("O"));
				}
				
				// set attributes
				request.setAttribute("gacc", accTrans);
				request.setAttribute("gicdSumListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gicdSumTableGridParams)));
				request.setAttribute("gdbdListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gdbdTableGridParams)));
				request.setAttribute("defaultCurrency", giacParamService.getParamValueV("DEFAULT_CURRENCY").getParamValueV());
				request.setAttribute("gaccTranId", gaccTranId);
				message = "SUCCESS";
				PAGE = "/pages/accounting/dcb/closeDCB.jsp";
			} else if ("refreshGicdSumListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", (currentPage == 0) ? 1 : currentPage);
				params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("dcbNo", request.getParameter("dcbNo"));
				params.put("dcbDate", request.getParameter("dcbDate"));
				
				params = accTransService.getGicdSumListTableGridMap(params);
				
				JSONObject json = new JSONObject(params);
				//Debug.print(json);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}  else if ("showOtcPage".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Integer gaccTranId = (request.getParameter("gaccTranId") == null) ? null : ((request.getParameter("gaccTranId").isEmpty() || request.getParameter("gaccTranId").equals("null")) ? null : new Integer(request.getParameter("gaccTranId")));
				Integer itemNo = (request.getParameter("itemNo") == null) ? null : (request.getParameter("itemNo").isEmpty() ? null : new Integer(request.getParameter("itemNo")));
				Integer dcbNo = (request.getParameter("dcbNo") == null) ? null : (request.getParameter("dcbNo").isEmpty() ? null : new Integer(request.getParameter("dcbNo")));
				String dspCheckNo = (request.getParameter("dspCheckNo") == null) ? null : (request.getParameter("dspCheckNo").isEmpty() ? null : request.getParameter("dspCheckNo"));
				BigDecimal amount = (request.getParameter("amount") == null) ? null : (request.getParameter("amount").isEmpty() ? null : new BigDecimal(request.getParameter("amount")));
				BigDecimal foreignCurrAmt = (request.getParameter("foreignCurrAmount") == null) ? null : (request.getParameter("foreignCurrAmount").isEmpty() ? null : new BigDecimal(request.getParameter("foreignCurrAmount")));
				String currencyShortName = (request.getParameter("currencyShortName") == null) ? null : (request.getParameter("currencyShortName").isEmpty() ? null : request.getParameter("currencyShortName"));
				BigDecimal currencyRt = (request.getParameter("currencyRt") == null) ? null : (request.getParameter("currencyRt").isEmpty() ? null : new BigDecimal(request.getParameter("currencyRt")));
				Integer depId = (request.getParameter("depId") == null) ? null : (request.getParameter("depId").isEmpty() ? null : new Integer(request.getParameter("depId")));
				
				// GBDS
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("gaccTranId", gaccTranId);
				params.put("itemNo", itemNo);
				params.put("dcbNo", dcbNo);
				params.put("foreignCurrAmt", foreignCurrAmt);
				params.put("dspCheckNo", dspCheckNo);
				params.put("amount", amount);
				params.put("currencyShortName", currencyShortName);
				params.put("currencyRt", currencyRt);
				
				params = accTransService.getOtcListTableGridMap(params, request.getParameter("parameters"));
				
				request.setAttribute("otcListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("itemNo", itemNo);
				request.setAttribute("dcbNo", dcbNo);
				request.setAttribute("depId", depId);
				
				message ="SUCCESS";
				PAGE = "/pages/accounting/dcb/subPages/outOfTownCheckDetail.jsp";
			} else if ("showLocmPage".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Integer gaccTranId = (request.getParameter("gaccTranId") == null) ? null : ((request.getParameter("gaccTranId").isEmpty() || request.getParameter("gaccTranId").equals("null")) ? null : new Integer(request.getParameter("gaccTranId")));
				Integer itemNo = (request.getParameter("itemNo") == null) ? null : (request.getParameter("itemNo").isEmpty() ? null : new Integer(request.getParameter("itemNo")));
				
				// LOCM
				Map<String, Object> locmTableGridParams = new HashMap<String, Object>();
				locmTableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				locmTableGridParams.put("filter", request.getParameter("objFilter"));
				locmTableGridParams.put("gaccTranId", gaccTranId);
				locmTableGridParams.put("itemNo", itemNo);
				locmTableGridParams = accTransService.getLocmListTableGridMap(locmTableGridParams);
				
				request.setAttribute("locmListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(locmTableGridParams)));
				
				message ="SUCCESS";
				PAGE = "/pages/accounting/dcb/subPages/listOfCreditMemo.jsp";
			} else if ("validateGiacs035DCBNo1".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				accTransService.validateGiacs035DCBNo1(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateGiacs035DCBNo2".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				accTransService.validateGiacs035DCBNo2(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkBankInOR".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				message = accTransService.checkBankInOR(params);
				//Debug.print(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showDCBPayModeLOV".equals(ACTION)) {
				
				PAGE = "/pages/accounting/dcb/pop-ups/showDCBPayModeLOV.jsp";
			} else if ("getDCBPayModeListing".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				String keyword = request.getParameter("keyword");
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				Map<String, Object> params = new HashMap<String, Object>();
				
				if (null != request.getParameter("pageNo")) {
					if (!"undefined".equals(request.getParameter("pageNo"))) {
						pageNo = new Integer(request.getParameter("pageNo")) - 1;
					}
				}
				
				params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("dcbNo", (request.getParameter("dcbNo") == null) ? null : (request.getParameter("dcbNo").isEmpty() ? null : new Integer(request.getParameter("dcbNo"))));
				params.put("dcbDate", request.getParameter("dcbDate"));
				params.put("keyword", keyword);
				
				searchResult = accTransService.getDCBPayModeList(pageNo, params);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/dcb/pop-ups/searchDCBPayModeLOVAjaxResult.jsp";
			} else if ("executeGdbdAmtPreTextItem".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				BigDecimal amount = accTransService.executeGdbdAmtPreTextItem(params);
				
				message = (amount == null) ? "" : amount.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getGdbdAmtWhenValidate".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				BigDecimal amount = accTransService.getGdbdAmtWhenValidate(params);

				message = (amount == null) ? "" : amount.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getCurrSnameGicdSumRec".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				BigDecimal amount = accTransService.getCurrSnameGicdSumRec(params);
				
				message = (amount == null) ? "" : amount.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getTotFcAmtForGicdSumRec".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				accTransService.getTotFcAmtForGicdSumRec(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getGcddCollectionAndDeposit".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				accTransService.getGcddCollectionAndDeposit(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showCheckClassList".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				List<CGRefCodes> checkClass = accTransService.getCheckClassList();
				JSONArray json = new JSONArray((List<CGRefCodes>) StringFormatter.replaceQuotesInList(checkClass));
				request.setAttribute("checkClassList", json);
				request.setAttribute("block", request.getParameter("block"));
				PAGE = "/pages/accounting/dcb/pop-ups/checkClassLOVOverlay.jsp";
			} else if ("updateGbdsdInOtc".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Integer depId = (request.getParameter("depId") == null) ? null : (request.getParameter("depId").isEmpty() ? null : new Integer(request.getParameter("depId")));
				accTransService.updateGbdsdInOtc(depId);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getGbdsdLOV".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Integer dcbNo = (request.getParameter("dcbNo") == null) ? null : (request.getParameter("dcbNo").isEmpty() ? null : new Integer(request.getParameter("dcbNo")));
				String dcbDate = (request.getParameter("dcbDate") == null) ? null : (request.getParameter("dcbDate").isEmpty() ? null : request.getParameter("dcbDate"));
				String branchCd = (request.getParameter("branchCd") == null) ? null : (request.getParameter("branchCd").isEmpty() ? null : request.getParameter("branchCd"));
				String payMode = (request.getParameter("payMode") == null) ? null : (request.getParameter("payMode").isEmpty() ? null : request.getParameter("payMode"));
				Map<String, Object> params = new HashMap<String, Object>();
				JSONArray json;
				List<Map<String, Object>> lov;
				
				params.put("dcbNo", dcbNo);
				params.put("dcbDate", dcbDate);
				params.put("branchCd", branchCd);
				params.put("payMode", payMode);
				
				lov = accTransService.getGbdsdLOV(params);
				
				json = new JSONArray((List<GIISCurrency>) StringFormatter.replaceQuotesInList(lov));
				request.setAttribute("gbdsdList", json);
				request.setAttribute("depNo", request.getParameter("depNo"));
				PAGE = "/pages/accounting/dcb/pop-ups/gbdsdLOVOverlay.jsp";
			} else if ("executeGiacs035BankDepReturnBtn".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				accTransService.executeGiacs035BankDepReturnBtn(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveDCBForClosing".equals(ACTION)) {
				GIACDCBBankDepService dcbBankDepService = (GIACDCBBankDepService) APPLICATION_CONTEXT.getBean("giacDCBBankDepService");
				Map<String, Object> params = new HashMap<String, Object>();
				params = dcbBankDepService.saveDCBForClosing(request.getParameter("parameters"), USER.getUserId());
				Debug.print("GIACAccTransController - "+params);
				request.setAttribute("object", new JSONObject(StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/genericObject.jsp";
			} else if("checkDCBforClosing".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", request.getParameter("gaccTranId"));
				params.put("dcbNo", request.getParameter("dcbNo") == "" ? 0 : Integer.parseInt(request.getParameter("dcbNo")));
				params.put("tranYear", request.getParameter("dcbYear") == "" ? 0 : Integer.parseInt(request.getParameter("dcbYear")));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("gicdSumAmt", request.getParameter("gicdSumAmt"));
				params.put("gdbdSumAmt", request.getParameter("gdbdSumAmt"));
				params.put("dcbDate", request.getParameter("dcbDate"));
				params = accTransService.checkDCBForClosing(params);
				request.setAttribute("object", new JSONObject(StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/genericObject.jsp";
			} else if("closeDCBgiacs035".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				String result = "";
				result = accTransService.checkDCBFlag(request.getParameter("closeParams")); //Deo [03.03.2017]: SR-5939
				if (result.equals("Y")) {  //Deo [03.03.2017]: add if (SR-5939)
				result = accTransService.closeDCB(request.getParameter("closeParams"), USER.getUserId());
				}  //Deo [03.03.2017]: close if (SR-5939)
				message = result;
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkUserAccess2".equals(ACTION)) {
				GIISUserFacadeService userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				System.out.println("test checkUserAccess2 - "+request.getParameter("moduleName"));
			    message = userService.checkUserAccess2(request.getParameter("moduleName"), USER.getUserId());
			    PAGE = "/pages/genericMessage.jsp";	
			} else if("checkUserAccessClose".equals(ACTION)) {
				GIISUserIssCdService userIssService = (GIISUserIssCdService) APPLICATION_CONTEXT.getBean("giisUserIssCdService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				message = userIssService.checkUserPerIssCdAcctg2(params);
				PAGE = "/pages/genericMessage.jsp";	
			} else if("updateAccTransFlag".equals(ACTION)) {
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("tranId", "".equals(request.getParameter("tranId")) ? 0 : Integer.parseInt(request.getParameter("tranId")));
				params.put("tranFlag", request.getParameter("tranFlag"));
				accTransService.updateAccTransFlag(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updateDCBCancel".equals(ACTION)){
				GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				accTransService.updateDCBCancel(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("refreshDCB".equals(ACTION)){
				GIACDCBBankDepService bankDepService = (GIACDCBBankDepService) APPLICATION_CONTEXT.getBean("giacDCBBankDepService");
				bankDepService.refreshDCB(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
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

}
