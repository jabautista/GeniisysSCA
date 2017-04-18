package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACBankDepSlipsService;
import com.geniisys.giac.service.GIACDCBBankDepService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACBankDepSlipsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());

		try {
			if ("saveGbdsBlock".equals(ACTION)) {
				GIACBankDepSlipsService gbdsService = (GIACBankDepSlipsService) APPLICATION_CONTEXT.getBean("giacBankDepSlipsService");
				System.out.println("Emman - parameters: " + request.getParameter("parameters"));
				message = gbdsService.saveGbdsBlock(request.getParameter("parameters"), USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showCashDepositPage".equals(ACTION)) {
				//GIACAccTransService accTransService = (GIACAccTransService) APPLICATION_CONTEXT.getBean("giacAccTransService");
				GIACBankDepSlipsService gbdsService = (GIACBankDepSlipsService) APPLICATION_CONTEXT.getBean("giacBankDepSlipsService");
				
				/*Integer gaccTranId = (request.getParameter("gaccTranId") == null) ? null : ((request.getParameter("gaccTranId").isEmpty() || request.getParameter("gaccTranId").equals("null")) ? null : new Integer(request.getParameter("gaccTranId")));
				Integer itemNo = (request.getParameter("itemNo") == null) ? null : (request.getParameter("itemNo").isEmpty() ? null : new Integer(request.getParameter("itemNo")));
				
				// GBDS2
				Map<String, Object> gbds2TableGridParams = new HashMap<String, Object>();
				gbds2TableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				gbds2TableGridParams.put("filter", request.getParameter("objFilter"));
				gbds2TableGridParams.put("gaccTranId", gaccTranId);
				gbds2TableGridParams.put("itemNo", itemNo);
				gbds2TableGridParams = gbdsService.getGbdsListTableGridMap(gbds2TableGridParams, request.getParameter("parameters"));
				
				// Initial GCDD
				Map<String, Object> gcddTableGridParams = new HashMap<String, Object>();
				gcddTableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				gcddTableGridParams.put("filter", request.getParameter("objFilter"));
				gcddTableGridParams.put("gaccTranId", gaccTranId);
				gcddTableGridParams.put("itemNo", itemNo);
				
				gcddTableGridParams = gbdsService.getGcddListTableGridMap(gcddTableGridParams, request.getParameter("parameters"));*/
				
				JSONObject gbds2TableGridParams = gbdsService.getGiacBankDepSlips(request);
				JSONObject gcddTableGridParams = gbdsService.getGiacCashDepDtl(request);
				
				request.setAttribute("gbds2ListTableGrid", gbds2TableGridParams);
				request.setAttribute("gcddListTableGrid", gcddTableGridParams);
				request.setAttribute("selectedGdbdIndex", request.getParameter("selectedGdbdIndex"));
				request.setAttribute("gaccTranId", request.getParameter("gaccTranId"));
				request.setAttribute("itemNo", request.getParameter("itemNo"));
				
				
				if(request.getParameter("refresh") == null) {
					message = "SUCCESS";
					PAGE = "/pages/accounting/dcb/subPages/cashDepositOverlay.jsp";
				} else {
					message = gbds2TableGridParams.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				//PAGE = "/pages/accounting/dcb/subPages/cashDeposits.jsp";
			} if("showCashDepositPageTbg1".equals(ACTION)){ //added lara 01.30.2014
				GIACBankDepSlipsService gbdsService = (GIACBankDepSlipsService) APPLICATION_CONTEXT.getBean("giacBankDepSlipsService");
				JSONObject gbds2TableGridParams = gbdsService.getGiacBankDepSlips(request);
				message = gbds2TableGridParams.toString();
				PAGE = "/pages/genericMessage.jsp";
				
			} else if ("refreshCashDepositListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				GIACBankDepSlipsService gbdsService = (GIACBankDepSlipsService) APPLICATION_CONTEXT.getBean("giacBankDepSlipsService");
				
				Integer gaccTranId = (request.getParameter("gaccTranId") == null) ? null : ((request.getParameter("gaccTranId").isEmpty() || request.getParameter("gaccTranId").equals("null")) ? null : new Integer(request.getParameter("gaccTranId")));
				Integer itemNo = (request.getParameter("itemNo") == null) ? null : (request.getParameter("itemNo").isEmpty() ? null : new Integer(request.getParameter("itemNo")));
				Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				
				params.put("currentPage", (currentPage == 0) ? 1 : currentPage);
				params.put("gaccTranId", gaccTranId);
				params.put("itemNo", itemNo);
				
				params = gbdsService.getGbdsListTableGridMap(params, null);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("refreshGcddListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				GIACBankDepSlipsService gbdsService = (GIACBankDepSlipsService) APPLICATION_CONTEXT.getBean("giacBankDepSlipsService");
				Integer gaccTranId = (request.getParameter("gaccTranId") == null) ? null : ((request.getParameter("gaccTranId").isEmpty() || request.getParameter("gaccTranId").equals("null")) ? null : new Integer(request.getParameter("gaccTranId")));
				Integer itemNo = (request.getParameter("itemNo") == null) ? null : (request.getParameter("itemNo").isEmpty() ? null : new Integer(request.getParameter("itemNo")));
				Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				
				params.put("currentPage", (currentPage == 0) ? 1 : currentPage);
				params.put("gaccTranId", gaccTranId);
				params.put("itemNo", itemNo);
				
				params = gbdsService.getGcddListTableGridMap(params); //edited by Halley 12.17.13
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showBankDepositPage".equals(ACTION)) {
				GIACBankDepSlipsService gbdsService = (GIACBankDepSlipsService) APPLICATION_CONTEXT.getBean("giacBankDepSlipsService");
				Integer gaccTranId = (request.getParameter("gaccTranId") == null) ? null : ((request.getParameter("gaccTranId").isEmpty() || request.getParameter("gaccTranId").equals("null")) ? null : new Integer(request.getParameter("gaccTranId")));
				Integer itemNo = (request.getParameter("itemNo") == null) ? null : (request.getParameter("itemNo").isEmpty() ? null : new Integer(request.getParameter("itemNo")));
				Integer dcbNo = (request.getParameter("dcbNo") == null) ? null : (request.getParameter("dcbNo").isEmpty() ? null : new Integer(request.getParameter("dcbNo")));
				
				// GBDS
				Map<String, Object> gbdsTableGridParams = new HashMap<String, Object>();
				gbdsTableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				gbdsTableGridParams.put("filter", request.getParameter("objFilter"));
				gbdsTableGridParams.put("gaccTranId", gaccTranId);
				gbdsTableGridParams.put("itemNo", itemNo);
				gbdsTableGridParams = gbdsService.getGbdsListTableGridMap(gbdsTableGridParams, request.getParameter("parameters"));
				
				// Initial GBDSD (no item)
				Map<String, Object> gbdsdTableGridParams = new HashMap<String, Object>();
				gbdsdTableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				gbdsdTableGridParams.put("filter", request.getParameter("objFilter"));
				gbdsdTableGridParams.put("gaccTranId", gaccTranId);
				gbdsdTableGridParams = gbdsService.getGbdsdListTableGridMapByGaccTranId(gbdsdTableGridParams, request.getParameter("parameters"));
				
				request.setAttribute("gbdsListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gbdsTableGridParams)));
				request.setAttribute("gbdsdListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gbdsdTableGridParams)));
				request.setAttribute("gdbdGaccTranId", gaccTranId);
				request.setAttribute("gdbdItemNo", itemNo);
				request.setAttribute("gdbdDcbNo", dcbNo);
				request.setAttribute("selectedGdbdIndex", request.getParameter("selectedGdbdIndex"));
				
				message ="SUCCESS";
				PAGE = "/pages/accounting/dcb/subPages/bankDeposits.jsp";
			} else if ("refreshBankDepositListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				GIACBankDepSlipsService gbdsService = (GIACBankDepSlipsService) APPLICATION_CONTEXT.getBean("giacBankDepSlipsService");
				Integer gaccTranId = (request.getParameter("gaccTranId") == null) ? null : ((request.getParameter("gaccTranId").isEmpty() || request.getParameter("gaccTranId").equals("null")) ? null : new Integer(request.getParameter("gaccTranId")));
				Integer itemNo = (request.getParameter("itemNo") == null) ? null : (request.getParameter("itemNo").isEmpty() ? null : new Integer(request.getParameter("itemNo")));
				Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				
				params.put("currentPage", (currentPage == 0) ? 1 : currentPage);
				params.put("gaccTranId", gaccTranId);
				params.put("itemNo", itemNo);
				
				params = gbdsService.getGbdsListTableGridMap(params, null);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("refreshGdbdListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				GIACDCBBankDepService dcbBankDepService = (GIACDCBBankDepService) APPLICATION_CONTEXT.getBean("giacDCBBankDepService");
				Integer gaccTranId = (request.getParameter("gaccTranId") == null) ? null : ((request.getParameter("gaccTranId").isEmpty() || request.getParameter("gaccTranId").equals("null")) ? null : new Integer(request.getParameter("gaccTranId")));
				Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				params.put("currentPage", (currentPage == 0) ? 1 : currentPage);
				params.put("gaccTranId", gaccTranId);
				
				if (gaccTranId != null) {
					params = dcbBankDepService.getGdbdSumListTableGridMap(params);
				} else {
					params.put("gfunFundCd", request.getParameter("gfunFundCd"));
					params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
					params.put("dcbYear", (request.getParameter("dcbYear") == null) ? null : (request.getParameter("dcbYear").isEmpty() ? null : new Integer(request.getParameter("dcbYear"))));
					params.put("dcbNo", (request.getParameter("dcbNo") == null) ? null : (request.getParameter("dcbNo").isEmpty() ? null : new Integer(request.getParameter("dcbNo"))));
					params.put("dcbDate", request.getParameter("dcbDate"));
					params = dcbBankDepService.populateGDBD(params);
				}
				
				JSONObject json = new JSONObject(params);
				Debug.print(json);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}  else if ("refreshGbdsdListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				GIACBankDepSlipsService gbdsService = (GIACBankDepSlipsService) APPLICATION_CONTEXT.getBean("giacBankDepSlipsService");
				Integer depId = (request.getParameter("depId") == null) ? null : (request.getParameter("depId").isEmpty() ? null : new Integer(request.getParameter("depId")));
				Integer depNo = (request.getParameter("depNo") == null) ? null : (request.getParameter("depNo").isEmpty() ? null : new Integer(request.getParameter("depNo")));
				Integer currentPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				
				params.put("currentPage", (currentPage == 0) ? 1 : currentPage);
				params.put("depId", depId);
				params.put("depNo", depNo);
				
				params = gbdsService.getGbdsdListTableGridMap(params);
				
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGbdsdErrorPage".equals(ACTION)) {
				GIACBankDepSlipsService gbdsService = (GIACBankDepSlipsService) APPLICATION_CONTEXT.getBean("giacBankDepSlipsService");
				Integer itemNo = (request.getParameter("itemNo") == null) ? null : (request.getParameter("itemNo").isEmpty() ? null : new Integer(request.getParameter("itemNo")));
				Integer depId = (request.getParameter("depId") == null) ? null : (request.getParameter("depId").isEmpty() ? null : new Integer(request.getParameter("depId")));
				Integer depNo = (request.getParameter("depNo") == null) ? null : (request.getParameter("depNo").isEmpty() ? null : new Integer(request.getParameter("depNo")));
				String bankCd = (request.getParameter("bankCd") == null) ? null : (request.getParameter("bankCd").isEmpty() ? null : request.getParameter("bankCd"));
				String checkNo = (request.getParameter("checkNo") == null) ? null : (request.getParameter("checkNo").isEmpty() ? null : request.getParameter("checkNo"));
				String orPref = (request.getParameter("orPref") == null) ? null : (request.getParameter("orPref").isEmpty() ? null : request.getParameter("orPref"));
				Integer orNo = (request.getParameter("orNo") == null) ? null : (request.getParameter("orNo").isEmpty() ? null : new Integer(request.getParameter("orNo")));
				String dspCheckNo = (request.getParameter("dspCheckNo") == null) ? null : (request.getParameter("dspCheckNo").isEmpty() ? null : request.getParameter("dspCheckNo"));
				BigDecimal amount = (request.getParameter("amount") == null) ? null : (request.getParameter("amount").isEmpty() ? null : new BigDecimal(request.getParameter("amount")));
				String currencyShortName = (request.getParameter("currencyShortName") == null) ? null : (request.getParameter("currencyShortName").isEmpty() ? null : request.getParameter("currencyShortName"));
				BigDecimal currencyRt = (request.getParameter("currencyRt") == null) ? null : (request.getParameter("currencyRt").isEmpty() ? null : new BigDecimal(request.getParameter("currencyRt")));
				Integer dcbNo = (request.getParameter("dcbNo") == null) ? null : (request.getParameter("dcbNo").isEmpty() ? null : new Integer(request.getParameter("dcbNo")));
				String bookTag = (request.getParameter("bookTag") == null) ? null : (request.getParameter("bookTag").isEmpty() ? null : request.getParameter("bookTag"));
				String remarks = (request.getParameter("remarks") == null) ? null : (request.getParameter("remarks").isEmpty() ? null : request.getParameter("remarks"));
				String recordStatus = (request.getParameter("recordStatus") == null) ? null : (request.getParameter("recordStatus").isEmpty() ? null : request.getParameter("recordStatus"));
				Integer gbdsdIndex = (request.getParameter("gbdsdIndex") == null) ? null : (request.getParameter("gbdsdIndex").isEmpty() ? null : new Integer(request.getParameter("gbdsdIndex")));
				
				// GBDS
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("depId", depId);
				params.put("depNo", depNo);
				params.put("bankCd", bankCd);
				params.put("checkNo", checkNo);
				params.put("orPref", orPref);
				params.put("orNo", orNo);
				params.put("dspCheckNo", dspCheckNo);
				params.put("amount", amount);
				params.put("currencyShortName", currencyShortName);
				params.put("currencyRt", currencyRt);
				params.put("bookTag", bookTag);
				params.put("remarks", remarks);
				params.put("recordStatus", recordStatus);
				
				params = gbdsService.getGbdsdErrorListTableGridMap(params, request.getParameter("parameters"));
				
				request.setAttribute("errorListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				request.setAttribute("itemNo", itemNo);
				request.setAttribute("dcbNo", dcbNo);
				request.setAttribute("gbdsdIndex", gbdsdIndex);
				
				message ="SUCCESS";
				PAGE = "/pages/accounting/dcb/subPages/checkDepositAnalysis.jsp";
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

}
