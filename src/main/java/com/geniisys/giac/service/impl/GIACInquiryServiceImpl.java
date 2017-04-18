package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import atg.taglib.json.util.JSONArray;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACInquiryDAO;
import com.geniisys.giac.service.GIACInquiryService;
import com.seer.framework.util.StringFormatter;

public class GIACInquiryServiceImpl implements GIACInquiryService {

	private GIACInquiryDAO giacInquiryDAO;
		
	public GIACInquiryDAO getGiacInquiryDAO() {
		return giacInquiryDAO;
	}

	public void setGiacInquiryDAO(GIACInquiryDAO giacInquiryDAO) {
		this.giacInquiryDAO = giacInquiryDAO;
	}

	@Override
	public JSONObject showTransactionStatus(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getTransactionStatus");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("tranFlagStat", request.getParameter("tranFlagStat"));
		params.put("userId", USER.getUserId());
		Map<String, Object> actgTransactionStatusTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonActgTransactionStatus = new JSONObject(actgTransactionStatusTableGrid);
		request.setAttribute("jsonActgTransactionStatus", jsonActgTransactionStatus);
		return jsonActgTransactionStatus;
	}

	@Override
	public JSONObject showTranStatHist(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getTranStatHist");				
		params.put("tranId", request.getParameter("tranId"));
		Map<String, Object> tranStatHistTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTranStatHist = new JSONObject(tranStatHistTableGrid);
		request.setAttribute("jsonTranStatHist", jsonTranStatHist);
		return jsonTranStatHist;
	}
	

	@Override
	public JSONObject showOrStatus(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getOrStatus");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("statusOrFlag", request.getParameter("statusOrFlag"));
		params.put("userId", USER.getUserId()); /*added by MarkS SR5694 10.26.2016*/
		try {
			if (request.getParameter("branchCd").equals(null)) {
				params.put("branchCd", "%");
			} else {
				params.put("branchCd", request.getParameter("branchCd"));

			}
		} catch (NullPointerException e) {
			params.put("branchCd", "%");
		}
		Map<String, Object> orStatusTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonOrStatus = new JSONObject(orStatusTableGrid);
		request.setAttribute("jsonOrStatus", jsonOrStatus);
		return jsonOrStatus;
	}

	@Override
	public JSONObject showOrHistory(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getOrHistory");
		params.put("tranId", request.getParameter("tranId"));
		Map<String, Object> orHistoryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonOrHistory = new JSONObject(orHistoryTableGrid);
		request.setAttribute("jsonOrHistory", jsonOrHistory);
		return jsonOrHistory;
	}

	//lara
	@Override
	public JSONObject showDVStatus(HttpServletRequest request, GIISUser uSER)throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDVStatus");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("dvFlag", request.getParameter("dvFlag"));
		Map<String, Object> dvStatusTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonDVStatus = new JSONObject(dvStatusTableGrid);
		request.setAttribute("jsonDVStatus", jsonDVStatus);
		return jsonDVStatus;
	}

	@Override
	public JSONObject showStatusHistory(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGIAC237StatusHistory");
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		Map<String, Object> statusHistoryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonStatusHistory = new JSONObject(statusHistoryTableGrid);
		return jsonStatusHistory;
	}

	@Override
	public JSONObject showPaymentRequestStatus(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPaymentRequestStatus");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("statusFlag", request.getParameter("statusFlag"));
		try {
			if (request.getParameter("branchCd").equals(null)) {
				params.put("branchCd", "%");
			} else {
				params.put("branchCd", request.getParameter("branchCd"));

			}
		} catch (NullPointerException e) {
			params.put("branchCd", "%");
		}
		Map<String, Object> paymentRequestStatusTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPaymentRequestStatus = new JSONObject(paymentRequestStatusTableGrid);
		request.setAttribute("jsonPaymentRequestStatus", jsonPaymentRequestStatus);
		return jsonPaymentRequestStatus;
	}

	@Override
	public JSONObject showPaymentRequestHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPaymentRequestHistory");
		params.put("tranId", request.getParameter("tranId"));
		Map<String, Object> paymentRequestHistoryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPaymentRequestHistory = new JSONObject(paymentRequestHistoryTableGrid);
		request.setAttribute("jsonPaymentRequestHistory", jsonPaymentRequestHistory);
		return jsonPaymentRequestHistory;
	}

	@Override
	public JSONObject showCheckReleaseInfo(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("pageSize", 7); //SR19642 Lara 07102015
		params.put("userId", USER.getUserId()); //carlo SR 23905 02-27-2017
		try {
			if (request.getParameter("branchCd").equals(null)) {
				params.put("branchCd", "%");
			} else {
				params.put("branchCd", request.getParameter("branchCd"));

			}
		} catch (NullPointerException e) {
			params.put("branchCd", "%");
		}
		
		try {
			if (request.getParameter("statusFilter").equals("U")) {
				params.put("ACTION", "getCheckReleaseInfoU");
			} else if (request.getParameter("statusFilter").equals("R")) {
				params.put("ACTION", "getCheckReleaseInfoR");
			} else {
				params.put("ACTION", "getCheckReleaseInfo");
			}
		} catch (NullPointerException e) {
			params.put("ACTION", "getCheckReleaseInfo");
		}
		
		Map<String, Object> checkReleaseInfoTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCheckReleaseInfo = new JSONObject(checkReleaseInfoTableGrid);
		request.setAttribute("jsonCheckReleaseInfo", jsonCheckReleaseInfo);
		return jsonCheckReleaseInfo;
	}

	@Override
	public JSONObject showGLAccountTransaction(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		String orderBy = (request.getParameter("multiSort") == null || request.getParameter("multiSort") == "") ? "" : "ORDER BY "+request.getParameter("multiSort");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGLAcctTransactionList");
		params.put("glAcctId", request.getParameter("glAcctId"));
		params.put("glAcctType", request.getParameter("glAcctType"));
		params.put("glAcctCat", request.getParameter("glAcctCat"));
		params.put("glCtrlAcct", request.getParameter("glCtrlAcct"));
		params.put("gfunFundCd", request.getParameter("gfunFundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("dtBasis", request.getParameter("dtBasis"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("tranOpenFlg", request.getParameter("tranOpenFlg"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		
		if (request.getParameter("sortColumn") == "" || request.getParameter("sortColumn") == null){
			params.put("orderBy", orderBy);
			System.out.println(params.get("orderBy"));
		}
		Map<String, Object> glAcctTransactionTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGlAcctTransaction = new JSONObject(glAcctTransactionTableGrid);
		request.setAttribute("glAcctTransTableGrid", jsonGlAcctTransaction);
		return jsonGlAcctTransaction;
	}


	@Override
	public JSONObject getSlSummary(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getSLSummary");
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("slCd", request.getParameter("slCd"));
		//params.put("slName", request.getParameter("slName"));
		params.put("debitAmt", request.getParameter("debitAmt"));
		params.put("creditAmt", request.getParameter("creditAmt"));
		System.out.println("GIACS230 SL Params: "+params.toString());
		Map<String, Object> glAcctTransactionTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGlAcctTransaction = new JSONObject(glAcctTransactionTableGrid);
		request.setAttribute("slSummaryTableGrid", jsonGlAcctTransaction);
		return jsonGlAcctTransaction;
	}
	
	@Override
	public JSONObject showPDCPayments(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGIACS092PDCPayments");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("checkFlag", request.getParameter("checkFlag"));
		Map<String, Object> pdcPaymentsTG = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPDCPayments = new JSONObject(pdcPaymentsTG);
		return jsonPDCPayments;
	}

	@Override
	public JSONObject showGIACS092Details(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGIACS092Details");
		params.put("pdcId", Integer.parseInt(request.getParameter("pdcId")));
		Map<String, Object> tg = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(tg);
		return json;
	}

	@Override
	public JSONObject showGIACS092Replacement(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGIACS092Replacement");
		params.put("pdcId", Integer.parseInt(request.getParameter("pdcId")));
		Map<String, Object> tg = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(tg);
		return json;
	}

	@Override
	public JSONObject showBillPayment(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS211GiacDirectPremCollns");
		Map<String, Object> giacDirectPremCollnsTg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGiacDirectPremCollnsTg = new JSONObject(giacDirectPremCollnsTg);
		return jsonGiacDirectPremCollnsTg;
	}

	@Override
	public JSONObject getGIACS211GipiInvoice(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("moduleId",request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		// start - andrew - 08042015 - SR 19643 
		params.put("assdNo", request.getParameter("assdNo"));
		params.put("policyId", request.getParameter("policyId"));
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params.put("packBillIssCd", request.getParameter("packBillIssCd"));
		params.put("packBillPremSeqNo", request.getParameter("packBillPremSeqNo"));
		params.put("dueDate", request.getParameter("dueDate"));
		params.put("inceptDate", request.getParameter("inceptDate"));
		params.put("expiryDate", request.getParameter("expiryDate"));
		params.put("issueDate", request.getParameter("issueDate"));
		params.put("findText", request.getParameter("findText"));
		// end - andrew - 08042015 - SR 19643
		Map<String, Object> gipiInvoiceTg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGipiInvoice = new JSONObject(gipiInvoiceTg);
		return jsonGipiInvoice;
	}

	@Override
	public JSONObject getGIACS211GiacDirectPremCollns(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("currencyCd",request.getParameter("currencyCd"));
		params.put("currencyRt",request.getParameter("currencyRt"));
		params.put("polFlag",request.getParameter("polFlag"));
		params.put("totalAmtDue",request.getParameter("totalAmtDue"));
		Map<String, Object> giacDirectPremCollnsTg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGiacDirectPremCollnsTg = new JSONObject(giacDirectPremCollnsTg);
		return jsonGiacDirectPremCollnsTg;
	}

	@Override
	public JSONObject showPremiumOverlay(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS211PremiumInfo");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("toForeign", request.getParameter("toForeign"));
		Map<String, Object> premiumMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPremium = new JSONObject(premiumMap);
		return jsonPremium;
	}

	@Override
	public JSONObject showTaxesOverlay(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS211TaxesInfo");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("currencyRt", request.getParameter("currencyRt"));
		params.put("toForeign", request.getParameter("toForeign"));
		Map<String, Object> taxesMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTaxes = new JSONObject(taxesMap);
		return jsonTaxes;
	}

	@Override
	public JSONObject showPDCPaymentsOverlay(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS211PDCPaymentsInfo");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("toForeign", request.getParameter("toForeign"));
		Map<String, Object> pdcPaymentsMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPDCPayments = new JSONObject(pdcPaymentsMap);
		return jsonPDCPayments;
	}

	@Override
	public JSONObject showBalancesOverlay(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS211BalancesInfo");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("toForeign", request.getParameter("toForeign"));
		Map<String, Object> balancesMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBalances = new JSONObject(balancesMap);
		return jsonBalances;
	}

	@Override
	public JSONObject getBillsByAssdAndAgeDetails(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		String orderBy = (request.getParameter("multiSort") == null || request.getParameter("multiSort") == "") ? "" : "ORDER BY " + request.getParameter("multiSort");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("columnNo", request.getParameter("columnNo"));
		params.put("userId", USER.getUserId());
		
		try {
			if (request.getParameter("branchCd").equals(null)) {
				params.put("branchCd", "%");
			} else {
				params.put("branchCd", request.getParameter("branchCd"));

			}
		} catch (NullPointerException e) {
			params.put("branchCd", "%");
		}
		
		if (request.getParameter("sortColumn") == "" || request.getParameter("sortColumn") == null){
			params.put("orderBy", orderBy);
			System.out.println(params.get("orderBy"));
		}
		
		params.put("ACTION", "getBillsByAssdAndAgeDetails");
		
		Map<String, Object> billsByAssdAndAgeTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBillsByAssdAndAge = new JSONObject(billsByAssdAndAgeTableGrid);
		request.setAttribute("jsonBillsByAssdAndAge", jsonBillsByAssdAndAge);
		return jsonBillsByAssdAndAge;
	}

	@Override
	public JSONObject showAgingListAllPopUp(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("ACTION", "showAgingListAllPopUp");
		Map<String, Object> showAgingListAllPopUpTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonShowAgingListAllPopUp = new JSONObject(showAgingListAllPopUpTableGrid);
		request.setAttribute("jsonShowAgingListAllPopUp", jsonShowAgingListAllPopUp);
		return jsonShowAgingListAllPopUp;
	}

	@Override
	public JSONObject getBillsUnderAgeLevel(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		String orderBy = (request.getParameter("multiSort") == null || request.getParameter("multiSort") == "") ? "" : "ORDER BY " + request.getParameter("multiSort");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("selectedBranchCd"));
		params.put("agingId", Integer.parseInt(request.getParameter("selectedAgingId")));
		params.put("assdNo", Integer.parseInt(request.getParameter("assdNo")));
		
		if (request.getParameter("sortColumn") == "" || request.getParameter("sortColumn") == null){
			params.put("orderBy", orderBy);
			System.out.println(params.get("orderBy"));
		}
		
		params.put("ACTION", "getBillsUnderAgeLevel");
		Map<String, Object> getBillsUnderAgeLevelTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGetBillsUnderAgeLevel = new JSONObject(getBillsUnderAgeLevelTableGrid);
		request.setAttribute("jsonGetBillsUnderAgeLevel", jsonGetBillsUnderAgeLevel);
		return jsonGetBillsUnderAgeLevel;
	}

	@Override
	public JSONObject getBillsForGivenAssdDtls(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("agingId", Integer.parseInt(request.getParameter("agingId")));
		params.put("assdNo", Integer.parseInt(request.getParameter("assdNo")));
		
		params.put("ACTION", "getBillsForGivenAssdDtls");
		Map<String, Object> getBillsForGivenAssdDtlsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBillsForGivenAssdDtls = new JSONObject(getBillsForGivenAssdDtlsTableGrid);
		request.setAttribute("jsonBillsForGivenAssdDtls", jsonBillsForGivenAssdDtls);
		return jsonBillsForGivenAssdDtls;
	}

	@Override
	public JSONObject getBillsAssdAndAgeLevel(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		String orderBy = (request.getParameter("multiSort") == null || request.getParameter("multiSort") == "") ? "" : "ORDER BY " + request.getParameter("multiSort");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("selectedBranchCd", request.getParameter("selectedBranchCd"));
		params.put("selectedAgingId", Integer.parseInt(request.getParameter("selectedAgingId")));
		params.put("assdNo", Integer.parseInt(request.getParameter("assdNo")));
		
		if (request.getParameter("sortColumn") == "" || request.getParameter("sortColumn") == null){
			params.put("orderBy", orderBy);
			System.out.println(params.get("orderBy"));
		}
		
		params.put("ACTION", "getBillsAssdAndAgeLevel");
		Map<String, Object> getBillsAssdAndAgeLevelTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBillsAssdAndAgeLevel = new JSONObject(getBillsAssdAndAgeLevelTableGrid);
		request.setAttribute("jsonBillsAssdAndAgeLevel", jsonBillsAssdAndAgeLevel);
		return jsonBillsAssdAndAgeLevel;
	}

	@Override
	public JSONObject getBillsForAnAssdDtls(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		String orderBy = (request.getParameter("multiSort") == null || request.getParameter("multiSort") == "") ? "" : "ORDER BY " + request.getParameter("multiSort");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("assdNo", Integer.parseInt(request.getParameter("assdNo")));
		params.put("agingId", request.getParameter("agingId"));
		params.put("branchCd", request.getParameter("branchCd"));
		
		if (request.getParameter("sortColumn") == "" || request.getParameter("sortColumn") == null){
			params.put("orderBy", orderBy);
			System.out.println(params.get("orderBy"));
		}
		
		params.put("ACTION", "getBillsForAnAssdDtls");
		Map<String, Object> getBillsForAnAssdDtlsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBillsForAnAssdDtls = new JSONObject(getBillsForAnAssdDtlsTableGrid);
		request.setAttribute("jsonBillsForAnAssdDtls", jsonBillsForAnAssdDtls);
		return jsonBillsForAnAssdDtls;
	}

	@Override
	public JSONObject showAssuredListAllPopUp(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		String orderBy = (request.getParameter("multiSort") == null || request.getParameter("multiSort") == "") ? "" : "ORDER BY " + request.getParameter("multiSort");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("assdNo", request.getParameter("assdNo"));
		
		if (request.getParameter("sortColumn") == "" || request.getParameter("sortColumn") == null){
			params.put("orderBy", orderBy);
			System.out.println(params.get("orderBy"));
		}
		
		params.put("ACTION", "showAssuredListAllPopUp");
		Map<String, Object> showAssuredListAllPopUpTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonShowAssuredListAllPopUp = new JSONObject(showAssuredListAllPopUpTableGrid);
		request.setAttribute("jsonShowAssuredListAllPopUp", jsonShowAssuredListAllPopUp);
		return jsonShowAssuredListAllPopUp;
	}
	
	public String giacs070WhenNewFormInstance() throws SQLException{
		return this.giacInquiryDAO.giacs070WhenNewFormInstance();
	}
	
	public JSONObject viewJournalEntries(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gfunFundCd", request.getParameter("gfunFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("userId", USER.getUserId());
		params.put("ACTION", "viewJournalEntries");
		System.out.println("======= "+params.toString());
		
		Map<String, Object> viewJournalEntries = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonViewJournalEntries = new JSONObject(viewJournalEntries);
		request.setAttribute("jsonViewJournalEntries", jsonViewJournalEntries);
		return jsonViewJournalEntries;
	}
	
	public Integer getOpInfoGiacs070(Integer tranId) throws SQLException{
		return this.giacInquiryDAO.getOpInfoGiacs070(tranId);
	}
	
	public String chkPaytReqDtl(Integer tranId) throws SQLException{
		Integer ret = this.giacInquiryDAO.chkPaytReqDtl(tranId);
		String callingForm = "";
		if (ret.equals(1)){
			callingForm = "DETAILS";
		}else{
			callingForm = "DISB_REQ";
		}
		return callingForm;
	}

	public JSONObject getDvInfoGiacs070(Integer tranId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", tranId);		
		params = this.giacInquiryDAO.getDvInfoGiacs070(params);
		
		return new JSONObject(params);
	}
	
	
	@Override
	public JSONObject showCommissionInquiry(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params	= new HashMap<String, Object>();
		params.put("ACTION", "getGiacs221CommPaytsRecords");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		if ("1".equals(request.getParameter("refresh"))) {
			params.put("commissionAmtL", new BigDecimal(request.getParameter("commissionAmtL")));
		}
		Map<String, Object> comInquiryMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonComInquiry = new JSONObject(comInquiryMap);
		return jsonComInquiry;
	}

	@Override
	public JSONObject showGiacs221History(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params	= new HashMap<String, Object>();
		params.put("ACTION", "getGiacs221HistoryRecords");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("currencyCond", request.getParameter("currencyCond"));
		Map<String, Object> recordMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRecord = new JSONObject(recordMap);
		return jsonRecord;
	}

	@Override
	public JSONObject showGiacs221Detail(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params	= new HashMap<String, Object>();
		params.put("ACTION", "getGiacs221DetailRecords");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		Map<String, Object> recordMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRecord = new JSONObject(recordMap);
		return jsonRecord;
	}

	@Override
	public JSONObject showGiacs221CommBreakdown(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params	= new HashMap<String, Object>();
		params.put("ACTION", "getGiacs221CommBreakdownRecords");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("currencyCond", request.getParameter("currencyCond"));
		Map<String, Object> recordMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRecord = new JSONObject(recordMap);
		return jsonRecord;
	}

	@Override
	public JSONObject showGiacs221ParentComm(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params	= new HashMap<String, Object>();
		params.put("ACTION", "getGiacs221ParentCommRecords");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		Map<String, Object> recordMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRecord = new JSONObject(recordMap);
		return jsonRecord;
	}

	@Override
	public JSONObject showBillPerPolicy(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showBillPerPolicy");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("premOsCheck", request.getParameter("premOsCheck"));
		params.put("premAndCommOsCheck", request.getParameter("premAndCommOsCheck"));
		Map<String, Object> tbgBillPerPolicy = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTbgBillPerPolicy = new JSONObject(tbgBillPerPolicy);
		request.setAttribute("jsonTbgBillPerPolicy", jsonTbgBillPerPolicy);
		return jsonTbgBillPerPolicy;
	}

	@Override
	public JSONObject showPremPayments(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showPremPayments");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		Map<String, Object> premPaymentsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPremPayments = new JSONObject(premPaymentsTableGrid);
		return jsonPremPayments;
	}

	@Override
	public JSONObject showCommPayments(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showCommPayments");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("intmNo", request.getParameter("intmNo"));	// shan 11.24.2014
		Map<String, Object> commPaymentsTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCommPayments = new JSONObject(commPaymentsTableGrid);
		return jsonCommPayments;
	}

	@Override
	public JSONObject getBillsPerIntm(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBillsPerIntm");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		
		Map<String, Object> billsPerIntmTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(billsPerIntmTG);
	}

	@Override
	public JSONObject showGIACS240(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCheckPaidPerPayee");
		params.put("fromDate", request.getParameter("fromDate") == null || request.getParameter("fromDate") == "" ? null : sdf.parse(request.getParameter("fromDate")));
		params.put("toDate", request.getParameter("toDate") == null || request.getParameter("fromDate") == "" ? null : sdf.parse(request.getParameter("toDate")));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeNo", request.getParameter("payeeNo") == null ? null : Integer.parseInt(request.getParameter("payeeNo")));
		
		Map<String, Object> chkPdPerPayeeList = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(chkPdPerPayeeList);
	}

	@Override
	public String validateFundCdGiacs240(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		return this.getGiacInquiryDAO().validateFundCdGiacs240(params);
	}

	@Override
	public String validateBranchCdGiacs240(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		return this.getGiacInquiryDAO().validateBranchCdGiacs240(params);
	}

	@Override
	public String validatePayeeClassCdGiacs240(HttpServletRequest request)
			throws SQLException {
		String payeeClassCd = request.getParameter("payeeClassCd");
		return this.getGiacInquiryDAO().validatePayeeClassCdGiacs240(payeeClassCd);
	}

	@Override
	public String validatePayeeNoGiacs240(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("payeeNo", request.getParameter("payeeNo") == null ? null : new BigDecimal(request.getParameter("payeeNo")));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		JSONObject result = new JSONObject(this.getGiacInquiryDAO().validatePayeeNoGiacs240(params));
		return result.toString();
	}

	@Override
	public JSONObject getChecksPaidPerDept(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getChecksPaidPerDeptList");
		params.put("userId", USER.getUserId());
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("oucId", request.getParameter("oucId") == null ? null : Integer.parseInt(request.getParameter("oucId")));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		Map<String, Object> checksPaidPerDeptTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonChecksPaidPerDept = new JSONObject(checksPaidPerDeptTbg);
		request.setAttribute("jsonChecksPaidPerDept", jsonChecksPaidPerDept);
		return jsonChecksPaidPerDept;
	}

	@Override
	public Map<String, Object> getDvAmount(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getDvAmount");
		params.put("userId", USER.getUserId());
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("oucId", request.getParameter("oucId") == null ? null : Integer.parseInt(request.getParameter("oucId")));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params = this.giacInquiryDAO.getDvAmount(params);
		List<?> list = (List<?>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("dv", new JSONArray(list));
		return params;
	}

	@Override 
	public JSONObject getGIACS211PolicyLov(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("moduleId",request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		// start - andrew - 08042015 - SR 19643
		params.put("lineCd",request.getParameter("lineCd"));
		params.put("sublineCd",request.getParameter("sublineCd"));
		params.put("issCd",request.getParameter("issCd"));
		params.put("issueYy",request.getParameter("issueYy"));
		params.put("polSeqNo",request.getParameter("polSeqNo"));
		params.put("renewNo",request.getParameter("renewNo"));
		params.put("endtIssCd",request.getParameter("endtIssCd"));
		params.put("endtYy",request.getParameter("endtYy"));
		params.put("endtSeqNo",request.getParameter("endtSeqNo"));
		params.put("endtType",request.getParameter("endtType"));
		params.put("refPolNo",request.getParameter("refPolNo"));
		params.put("assdNo",request.getParameter("assdNo"));
		params.put("intmNo",request.getParameter("intmNo"));
		params.put("packPolicyId",request.getParameter("packPolicyId"));
		params.put("dueDate", request.getParameter("dueDate"));
		params.put("inceptDate", request.getParameter("inceptDate"));
		params.put("expiryDate", request.getParameter("expiryDate"));
		params.put("issueDate", request.getParameter("issueDate"));
		params.put("billIssCd", request.getParameter("billIssCd"));
		params.put("findText",request.getParameter("findText"));
		// end - andrew - 08042015 - SR 19643		
		Map<String, Object> gipiInvoiceTg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGipiInvoice = new JSONObject(gipiInvoiceTg);
		return jsonGipiInvoice;
	} // Dren 06292015 : SR 0004613 - Added LOV for policy no.

	 // andrew - 07242015 - SR 19643
	@Override
	public JSONObject getGIACS211PackPolicyLov(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("moduleId",request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		params.put("packLineCd",request.getParameter("packLineCd"));
		params.put("packSublineCd",request.getParameter("packSublineCd"));
		params.put("packIssCd",request.getParameter("packIssCd"));
		params.put("packIssueYy",request.getParameter("packIssueYy"));
		params.put("packPolSeqNo",request.getParameter("packPolSeqNo"));
		params.put("packRenewNo",request.getParameter("packRenewNo"));
		params.put("packEndtIssCd",request.getParameter("packEndtIssCd"));
		params.put("packEndtYy",request.getParameter("packEndtYy"));
		params.put("packEndtSeqNo",request.getParameter("packEndtSeqNo"));
		params.put("packEndtType",request.getParameter("packEndtType"));
		params.put("assdNo",request.getParameter("assdNo"));
		params.put("intmNo",request.getParameter("intmNo"));
		params.put("policyId",request.getParameter("policyId"));
		params.put("packBillIssCd",request.getParameter("packBillIssCd"));
		params.put("packBillPremSeqNo",request.getParameter("packBillPremSeqNo"));
		params.put("dueDate", request.getParameter("dueDate"));
		params.put("inceptDate", request.getParameter("inceptDate"));
		params.put("expiryDate", request.getParameter("expiryDate"));
		params.put("issueDate", request.getParameter("issueDate"));
		params.put("billIssCd", request.getParameter("billIssCd"));
		params.put("findText",request.getParameter("findText"));
		Map<String, Object> gipiInvoiceTg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGipiInvoice = new JSONObject(gipiInvoiceTg);
		return jsonGipiInvoice;
	}

	// andrew - 07242015 - SR 19643
	@Override
	public JSONObject getGiacs211BillDetails(HttpServletRequest request,
			GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo",request.getParameter("premSeqNo"));
		
		Map<String, Object> gipiInvoiceTg = giacInquiryDAO.getGiacs211BillDetails(params); 
		JSONObject jsonGipiInvoice = new JSONObject(gipiInvoiceTg);
		return jsonGipiInvoice;
	}
	
}
