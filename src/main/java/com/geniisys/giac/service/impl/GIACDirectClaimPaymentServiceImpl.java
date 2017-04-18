/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GIACS017
 * Created By 	: 	rencela
 * Create Date	:	Oct 6, 2010
 ***************************************************/
package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACDirectClaimPaymentDAO;
import com.geniisys.giac.entity.GIACDirectClaimPayment;
import com.geniisys.giac.service.GIACDirectClaimPaymentService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gicl.dao.GICLClaimLossExpenseDAO;
import com.geniisys.gicl.entity.GICLAdvice;
import com.geniisys.gicl.entity.GICLClaimLossExpense;
import com.geniisys.gicl.entity.GICLClaims;
import com.seer.framework.util.StringFormatter;

public class GIACDirectClaimPaymentServiceImpl implements GIACDirectClaimPaymentService{

	private GIACDirectClaimPaymentDAO giacDirectClaimPaymentDAO;
	
	private static Logger log = Logger.getLogger(GIACDirectClaimPaymentServiceImpl.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectClaimPaymentService#getClaimDetails(java.lang.Integer)
	 */
	@Override
	public GICLClaims getClaimDetails(Integer claimId) throws SQLException {
		return this.getGiacDirectClaimPaymentDAO().getClaimDetails(claimId);
	}

	/**
	 * @param giacDirectClaimPaymentDAO the giacDirectClaimPaymentDAO to set
	 */
	public void setGiacDirectClaimPaymentDAO(GIACDirectClaimPaymentDAO giacDirectClaimPaymentDAO) {
		this.giacDirectClaimPaymentDAO = giacDirectClaimPaymentDAO;
	}

	/**
	 * @return the giacDirectClaimPaymentDAO
	 */
	public GIACDirectClaimPaymentDAO getGiacDirectClaimPaymentDAO() {
		return giacDirectClaimPaymentDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectClaimPaymentService#computeAdviceDefaultAmount(java.util.Map)
	 */
	@Override
	public Map<String, Object> computeAdviceDefaultAmount(Map<String, Object> params)
			throws SQLException {
		return this.giacDirectClaimPaymentDAO.computeAdviceDefaultAmount(params);
	}

	/* 
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectClaimPaymentService#getAdviceNumberList(java.util.HashMap, java.lang.Integer)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getAdviceSequenceListing(String moduleId, String keyword,
			Integer pageNo) throws SQLException {
		List<GICLAdvice> adviceNumberList = this.getGiacDirectClaimPaymentDAO().getAdviceSequenceListing(moduleId, keyword);
		//adviceNumberList = (List<GICLAdvice>) StringFormatter.replaceQuotesInList(adviceNumberList);
		PaginatedList paginatedList = new PaginatedList(adviceNumberList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectClaimPaymentService#saveDirectClaimPayments(java.util.List)
	 */
	@Override
	public void saveDirectClaimPayments(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		System.out.println("Saving Direct Claim Payments...");
		List<GIACDirectClaimPayment> setRow = this.prepareDirectClaimPaymentJSON(new JSONArray(request.getParameter("setRows")), userId);
		List<GIACDirectClaimPayment> delRow = this.prepareDirectClaimPaymentJSON(new JSONArray(request.getParameter("delRows")), userId);
		System.out.println("setClaims List length: " + setRow.size());
		System.out.println("delClaims List length: " + delRow.size());
		
		params.put("setRows", setRow);
		params.put("delRows", delRow);
		params.put("appUser", userId);
		params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("tranSource", request.getParameter("tranSource"));
		params.put("orFlag", request.getParameter("tranSource"));
		params.put("moduleName", "GIACS017");
		params.put("userId", userId);
		
		this.getGiacDirectClaimPaymentDAO().saveDirectClaimPayments(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectClaimPaymentService#getDirectClaimPaymentByGaccTranId(java.lang.Integer)
	 */
	@Override
	public List<GIACDirectClaimPayment> getDirectClaimPaymentByGaccTranId(
			Integer gaccTranId) throws SQLException {
		return this.getGiacDirectClaimPaymentDAO().getDirectClaimPaymentByGaccTranId(gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectClaimPaymentService#getDirectClaimPaymentByGaccTranId(org.springframework.context.ApplicationContext, java.lang.Integer)
	 */
	@Override
	public List<GIACDirectClaimPayment> getDirectClaimPaymentByGaccTranId(
			ApplicationContext applicationContext, Integer gaccTranId)
			throws SQLException {
		log.info("get direct claim payment by gacc tran id");
		GICLClaimLossExpenseDAO claimLossExpenseDAO = applicationContext.getBean(GICLClaimLossExpenseDAO.class);
		List<GIACDirectClaimPayment> dcpList = this.getGiacDirectClaimPaymentDAO().getDirectClaimPaymentByGaccTranId(gaccTranId);
		Iterator<GIACDirectClaimPayment> iter = dcpList.iterator();
		
		GIACDirectClaimPayment payment = null;
		GICLClaimLossExpense claimLossExpense = null;
		Integer transType = null;
		String lineCd = null;
		Integer adviceId = null;
		Integer claimId = null;
		Integer claimLossId = null;
		
		while(iter.hasNext()){
			payment = iter.next();
			payment.displayDetailsInConsole();
			adviceId = payment.getAdviceId();
			transType = payment.getTransactionType();
			claimId = payment.getClaimId();
			claimLossId = payment.getClaimLossId();
			lineCd = payment.getGiclAdvice().getLineCode();
			// the following statement returns NULL due to ORA
			claimLossExpense = claimLossExpenseDAO.getClaimLossExpenseByTransType(transType, lineCd, adviceId, claimId, claimLossId);		
			
			payment.setGiclClaimLossExpense(claimLossExpense);
		}
		return dcpList;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectClaimPaymentService#dcpPostFormsCommit(java.util.Map)
	 */
	@Override
	public Map<String, Object> dcpPostFormsCommit(Map<String, Object> params)
			throws SQLException {
		return this.giacDirectClaimPaymentDAO.dcpPostFormsCommit(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectClaimPaymentService#prepareDirectClaimPaymentJSON(org.json.JSONArray, java.lang.String)
	 */
	@Override
	public List<GIACDirectClaimPayment> prepareDirectClaimPaymentJSON(
			JSONArray rows, String userId) throws JSONException {
		List<GIACDirectClaimPayment> list = new ArrayList<GIACDirectClaimPayment>();
		GIACDirectClaimPayment dcp = null;
		
		log.info("preparing Direct Claim Payment objects");
		
		for(int index = 0; index < rows.length(); index++){
			dcp = new GIACDirectClaimPayment();
			if(!rows.getJSONObject(index).isNull("adviceId")){
				dcp.setAdviceId(rows.getJSONObject(index).isNull("adviceId") ? null : rows.getJSONObject(index).getInt("adviceId"));			
				dcp.setAdviceSequenceNumber(rows.getJSONObject(index).isNull("adviceId") ? null : rows.getJSONObject(index).getString("adviceId"));
			}else if(!rows.getJSONObject(index).isNull("adviceSequence")){
				dcp.setAdviceId(rows.getJSONObject(index).isNull("adviceSequence") ? null : rows.getJSONObject(index).getInt("adviceSequence"));			
				dcp.setAdviceSequenceNumber(rows.getJSONObject(index).isNull("adviceSequence") ? null : rows.getJSONObject(index).getString("adviceSequence"));
			}
			dcp.setClaimId(rows.getJSONObject(index).isNull("claimId") ? null : rows.getJSONObject(index).getInt("claimId"));
			dcp.setClaimLossId(rows.getJSONObject(index).isNull("claimLossId") ? null : rows.getJSONObject(index).getInt("claimLossId"));
			dcp.setConvertRate(rows.getJSONObject(index).isNull("convertRate") ? null :new BigDecimal(rows.getJSONObject(index).getString("convertRate")));
			dcp.setCpiBranchCd(rows.getJSONObject(index).isNull("cpiBranchId") ? null : rows.getJSONObject(index).getString("cpiBranchId"));
			dcp.setCpiRecNo(rows.getJSONObject(index).isNull("cpiRecNo") ? null : rows.getJSONObject(index).getInt("cpiRecNo"));
			dcp.setCurrencyCode(rows.getJSONObject(index).isNull("currencyCode") ? null : rows.getJSONObject(index).getInt("currencyCode"));
			dcp.setDisbursementAmount(rows.getJSONObject(index).isNull("disbursementAmount") ? null :new BigDecimal(rows.getJSONObject(index).getString("disbursementAmount")));
			dcp.setForeignCurrencyAmount(rows.getJSONObject(index).isNull("foreignCurrencyAmount") ? null : new BigDecimal(rows.getJSONObject(index).getString("foreignCurrencyAmount")));
			dcp.setGaccTranId(rows.getJSONObject(index).isNull("gaccTranId") ? null : rows.getJSONObject(index).getInt("gaccTranId"));
			dcp.setInputVatAmount(rows.getJSONObject(index).isNull("inputVatAmount") ? null :new BigDecimal(rows.getJSONObject(index).getString("inputVatAmount")));
			dcp.setNetDisbursementAmount(rows.getJSONObject(index).isNull("netDisbursementAmount") ? null :new BigDecimal(rows.getJSONObject(index).getString("netDisbursementAmount")));
			dcp.setOriginalCurrencyCode(rows.getJSONObject(index).isNull("origCurrencyCode") ? null : rows.getJSONObject(index).getInt("origCurrencyCode"));
			dcp.setOriginalCurrencyRate(rows.getJSONObject(index).isNull("origCurrencyRate") ? null :new BigDecimal(rows.getJSONObject(index).getString("origCurrencyRate")));
			dcp.setOrPrintTag(rows.getJSONObject(index).isNull("orPrintTag") ? null : rows.getJSONObject(index).getString("orPrintTag"));
			dcp.setPayeeCd(rows.getJSONObject(index).isNull("payeeCd") ? null : rows.getJSONObject(index).getInt("payeeCd"));
			dcp.setPayeeClassCd(rows.getJSONObject(index).isNull("payeeClassCd") ? null : rows.getJSONObject(index).getString("payeeClassCd"));
			dcp.setPayeeType(rows.getJSONObject(index).isNull("payeeType") ? null : rows.getJSONObject(index).getString("payeeType"));
			dcp.setRemarks(rows.getJSONObject(index).isNull("remarks") ? null : rows.getJSONObject(index).getString("remarks"));
			dcp.setTransactionType(rows.getJSONObject(index).isNull("transactionType") ? null : rows.getJSONObject(index).getInt("transactionType"));
			dcp.setWithholdingTaxAmount(rows.getJSONObject(index).isNull("withholdingTaxAmount") ? null :new BigDecimal(rows.getJSONObject(index).getString("withholdingTaxAmount")));
			dcp.setLastUpdate(new Date());
			dcp.setUserId(userId);
			list.add((GIACDirectClaimPayment) StringFormatter.replaceQuoteTagIntoQuotesInObject(dcp));
		}
		return list;
	}

	@Override
	public void showClaimAdviceModal(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS017ClaimAdviceTableGrid");
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("adviceYear", request.getParameter("adviceYear"));
		params.put("adviceSeqNo", request.getParameter("adviseSeqNo"));
		params.put("riIssCd", request.getParameter("riIssCd"));
		params.put("tranType", Integer.parseInt(request.getParameter("tranType")));
		params.put("moduleId", "GIACS017");
		//added by reymon 02242013
		if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")){
			params.put("notIn",request.getParameter("notIn"));
		}
		if (request.getParameter("notIn2") != null && !request.getParameter("notIn2").equals("")){
			params.put("notIn2",request.getParameter("notIn2"));
		}
		System.out.println("Show claim advice modal... "+params);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString();
		request.setAttribute("claimAdviceTG", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public void newFormInstanceGIACS017(HttpServletRequest request,
			GIACParameterFacadeService giacParameterService, LOVHelper helper, String userId)
			throws SQLException, JSONException {
		System.out.println("show direct claim payments - giacs017");
		Integer gaccTranId = Integer.parseInt( (request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals("null"))? "0" : request.getParameter("gaccTranId"));
		
		this.getGICLDirectClaimPaytTG(request);
		request.setAttribute("gdcpSum", new JSONObject(this.getGiacDirectClaimPaymentDAO().getGDCPAmountSum(gaccTranId)).toString());
		// TRANSACTION TYPE - LOV		
		String[] transactionTypeParam = {"GIAC_DIRECT_CLAIM_PAYTS.TRANSACTION_TYPE"};
		request.setAttribute("transactionTypeLOV", helper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, transactionTypeParam));
		// CURRENCY LOV
		request.setAttribute("currencyCodesLOV", helper.getList(LOVHelper.CURRENCY_CODES));
		
		Map<String, Object> varMap = new HashMap<String, Object>();
		varMap.put("varIssCd", giacParameterService.getParamValueV2("RI_ISS_CD"));
		varMap.put("varCurrencyCd", giacParameterService.getParamValueN("CURRENCY_CD"));
		request.setAttribute("vars", new JSONObject(varMap).toString());
		
	}

	@Override
	public void getGICLDirectClaimPaytTG(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacDirectClaimPaytsTableGrid");
		//marco - 05.03.2013 - added equals("null") condition
		params.put("gaccTranId", Integer.parseInt( (request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals("null"))? "0" : request.getParameter("gaccTranId")));
		params.put("moduleId", "GIACS017");
		System.out.println("getGICLDirectClaimPaytTG params: "+params);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString();
		request.setAttribute("gdcpTG", grid);
		request.setAttribute("object", grid);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDCPFromAdvice(String param,
			String userId) throws SQLException, JSONException {
		List<Map<String, Object>> dcpRows = new ArrayList<Map<String,Object>>();
		JSONArray advRows = new JSONArray(param);
		Map<String, Object> adv = null;
		Map<String, Object> dcp = null;
		JSONObject obj = null;
		for(int index=0; index<advRows.length(); index++) {
			adv = new HashMap<String, Object>();
			dcp = new HashMap<String, Object>();
			obj = advRows.getJSONObject(index);
			
			adv.put("gaccTranId", obj.isNull("gaccTranId") ? null : obj.getInt("gaccTranId"));
			adv.put("tranType", obj.isNull("transactionType") ? null : obj.getInt("transactionType"));
			adv.put("lineCd", obj.isNull("lineCd") ? null : obj.getString("lineCd"));
			adv.put("issCd", obj.isNull("issCd") ? null : obj.getString("issCd"));
			adv.put("adviceYear", obj.isNull("adviceYear") ? null : obj.getInt("adviceYear"));
			adv.put("adviceSeqNo", obj.isNull("adviceSeqNo") ? null : obj.getInt("adviceSeqNo"));
			adv.put("payeeCd", obj.isNull("payeeCd") ? null : obj.getInt("payeeCd"));
			adv.put("claimId", obj.isNull("claimId") ? null : obj.getInt("claimId"));
			adv.put("claimLossId", obj.isNull("clmLossId") ? null : obj.getInt("clmLossId"));
			adv.put("riIssCd", obj.isNull("riIssCd") ? null : obj.getString("riIssCd"));
			adv.put("moduleId", "GIACS017");
			adv.put("userId", userId);
			System.out.println("Retrieving new DCP from advice: "+adv);
			dcp= this.getGiacDirectClaimPaymentDAO().getDCPFromClaim(adv, "getDCPFromAdvice");
			dcpRows.add(dcp);
			obj = null;
			adv = null;
			dcp = null;
		}
		dcpRows = (List<Map<String, Object>>) StringFormatter.escapeHTMLInListOfMap(dcpRows);
		System.out.println("Retrieved DCP: "+dcpRows.size());
		return dcpRows;
	}

	@Override
	public void showBatchClaimModal(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS017BatchClaimTableGrid");
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("adviceYear", request.getParameter("adviceYear"));
		params.put("adviceSeqNo", request.getParameter("adviseSeqNo"));
		params.put("riIssCd", request.getParameter("riIssCd"));
		params.put("tranType", Integer.parseInt(request.getParameter("tranType")));
		params.put("moduleId", "GIACS017");
		//added by reymon 02242013
		if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")){
			params.put("notIn",request.getParameter("notIn"));
		}
		System.out.println("Show batch claim modal... "+params);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString();
		request.setAttribute("batchClaimTG", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public Map<String, Object> getEnteredAdviceDetails(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", "GIACS017");
		params.put("userId", userId);
		params.put("vIssCd", request.getParameter("vIssCd"));
		params.put("tranType", request.getParameter("tranType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("adviceYear", request.getParameter("adviceYear"));
		params.put("adviceSeqNo", request.getParameter("adviceSeqNo"));
		Map<String, Object> dcps = this.getGiacDirectClaimPaymentDAO().getEnteredAdviceDetails(params);
		return dcps == null ? null : StringFormatter.escapeHTMLInMap(dcps);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDCPFromBatch(String param, String userId)
			throws SQLException, JSONException {
		List<Map<String, Object>> dcpRows = new ArrayList<Map<String,Object>>();
		JSONArray advRows = new JSONArray(param);
		Map<String, Object> adv = null;
		Map<String, Object> dcp = null;
		JSONObject obj = null;
		List<Map<String, Object>> dcpList = null;
		for(int index=0; index<advRows.length(); index++) {
			adv = new HashMap<String, Object>();
			dcp = new HashMap<String, Object>();
			obj = advRows.getJSONObject(index);
			dcpList = new ArrayList<Map<String,Object>>();
			
			adv.put("gaccTranId", obj.isNull("gaccTranId") ? null : obj.getInt("gaccTranId"));
			adv.put("tranType", obj.isNull("transactionType") ? null : obj.getInt("transactionType"));
			adv.put("batchCsrId", obj.isNull("batchCsrId") ? null : obj.getString("batchCsrId"));
			adv.put("riIssCd", obj.isNull("riIssCd") ? null : obj.getString("riIssCd"));
			adv.put("moduleId", "GIACS017");
			adv.put("userId", userId);
			System.out.println("Retrieving new DCP from batch: "+adv);
			dcpList = this.getGiacDirectClaimPaymentDAO().getDCPFromBatch(adv);
			dcpRows.addAll(dcpList);
			/*dcp= this.getGiacDirectClaimPaymentDAO().getDCPFromClaim(adv, "getDCPFromBatch");
			dcpRows.add(dcp);*/
			obj = null;
			adv = null;
			dcp = null;
		}
		dcpRows = (List<Map<String, Object>>) StringFormatter.escapeHTMLInListOfMap(dcpRows);
		System.out.println("Retrieved DCP: "+dcpRows.size());
		return dcpRows;
	}
	
	@Override
	public List<Map<String, Object>> getListOfPayees(HttpServletRequest request)
			throws SQLException, JSONException {
		List<Map<String, Object>> dcpRows = new ArrayList<Map<String,Object>>();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("adviceId", request.getParameter("adviceId"));
		params.put("claimId", request.getParameter("claimId"));
		params.put("tranType", request.getParameter("tranType"));
		/*JSONArray advRows = new JSONArray(param);
		Map<String, Object> adv = null;
		Map<String, Object> dcp = null;
		JSONObject obj = null;
		List<Map<String, Object>> dcpList = null;
		for(int index=0; index<advRows.length(); index++) {
			adv = new HashMap<String, Object>();
			dcp = new HashMap<String, Object>();
			obj = advRows.getJSONObject(index);
			dcpList = new ArrayList<Map<String,Object>>();
			
			adv.put("gaccTranId", obj.isNull("gaccTranId") ? null : obj.getInt("gaccTranId"));
			adv.put("tranType", obj.isNull("transactionType") ? null : obj.getInt("transactionType"));
			adv.put("batchCsrId", obj.isNull("batchCsrId") ? null : obj.getString("batchCsrId"));
			adv.put("riIssCd", obj.isNull("riIssCd") ? null : obj.getString("riIssCd"));
			adv.put("moduleId", "GIACS017");
			adv.put("userId", userId);
			System.out.println("Retrieving new DCP from batch: "+adv);
			
			dcpRows.addAll(dcpList);
			dcp= this.getGiacDirectClaimPaymentDAO().getDCPFromClaim(adv, "getDCPFromBatch");
			dcpRows.add(dcp);
			obj = null;
			adv = null;
			dcp = null;
		}*/
		dcpRows = this.getGiacDirectClaimPaymentDAO().getListOfPayees(params);
		return dcpRows;
	}
	
	
}