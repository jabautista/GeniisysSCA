/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Nov 11, 2010
 ***************************************************/
package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClaimLossExpenseDAO;
import com.geniisys.gicl.entity.GICLClaimLossExpense;
import com.geniisys.gicl.entity.GICLLossExpDtl;
import com.geniisys.gicl.entity.GICLLossExpPayees;
import com.geniisys.gicl.service.GICLClaimLossExpenseService;
import com.seer.framework.util.StringFormatter;

public class GICLClaimLossExpenseServiceImpl implements GICLClaimLossExpenseService{

	private GICLClaimLossExpenseDAO giclClaimLossExpenseDAO;
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimLossExpenseService#getClaimLossExpense(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public GICLClaimLossExpense getClaimLossExpense(Integer claimId,
			Integer claimLossId) throws SQLException {
		return this.getGiclClaimLossExpenseDAO().getClaimLossExpense(claimId, claimLossId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClaimLossExpenseService#getClaimLossExpenseByTransType(java.lang.Integer, java.lang.String, java.lang.Integer, java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public GICLClaimLossExpense getClaimLossExpenseByTransType(
			Integer transType, String lineCd, Integer adviceId,
			Integer claimId, Integer claimLossId) throws SQLException {
		return this.getGiclClaimLossExpenseDAO().getClaimLossExpenseByTransType(transType, lineCd, adviceId, claimId, claimLossId);
	}

	/**
	 * @param giclClaimLossExpenseDAO the giclClaimLossExpenseDAO to set
	 */
	public void setGiclClaimLossExpenseDAO(GICLClaimLossExpenseDAO giclClaimLossExpenseDAO) {
		this.giclClaimLossExpenseDAO = giclClaimLossExpenseDAO;
	}

	/**
	 * @return the giclClaimLossExpenseDAO
	 */
	public GICLClaimLossExpenseDAO getGiclClaimLossExpenseDAO() {
		return giclClaimLossExpenseDAO;
	}

	@Override
	public String getClmHistInfo(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClmHistInfo");
		params.put("claimId", request.getParameter("claimId"));
		params.put("dspItemNo", request.getParameter("dspItemNo"));
		params.put("dspPerilCd", request.getParameter("dspPerilCd"));
		params = TableGridUtil.getTableGrid(request, params);
		
		String tbGrid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		
		return tbGrid;		
	}

	/**
	 * 
	 */
	@Override
	public Map<String, Object> getSettlementHist(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClmHistInfo");
		params.put("claimId", request.getParameter("claimId"));
		params.put("dspItemNo", request.getParameter("dspItemNo"));
		params.put("dspPerilCd", request.getParameter("dspPerilCd"));
		
		params = TableGridUtil.getTableGrid(request, params);
		
		return params;
	}

	@Override
	public Integer getNextClmLossIdValue(Integer claimId) throws SQLException {
		return this.getGiclClaimLossExpenseDAO().getNextClmLossIdValue(claimId);
	}

	@Override
	public void saveLossExpenseHistory(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setGiclLossExpPayees", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setGiclLossExpPayees")), USER.getUserId(), GICLLossExpPayees.class));
		params.put("delGiclLossExpPayees", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delGiclLossExpPayees")), USER.getUserId(), GICLLossExpPayees.class));
		params.put("setGiclClmLossExp", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setGiclClmLossExpense")), USER.getUserId(), GICLClaimLossExpense.class));
		params.put("delGiclClmLossExp", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delGiclClmLossExpense")), USER.getUserId(), GICLClaimLossExpense.class));
		params.put("setGiclLossExpDtl", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setGiclLossExpDtl")), USER.getUserId(), GICLLossExpDtl.class));
		params.put("delGiclLossExpDtl", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delGiclLossExpDtl")), USER.getUserId(), GICLLossExpDtl.class));
		this.getGiclClaimLossExpenseDAO().saveLossExpenseHistory(params);
	}

	@Override
	public String validateHistSeqNo(Map<String, Object> params)
			throws SQLException {
		return this.getGiclClaimLossExpenseDAO().validateHistSeqNo(params);
	}

	@Override
	public void cancelHistory(HttpServletRequest request, GIISUser USER) throws SQLException,
			Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("histSeqNo", request.getParameter("histSeqNo"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("payeeType", request.getParameter("payeeType"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("userId", USER.getUserId());
		this.getGiclClaimLossExpenseDAO().cancelHistory(params);
	}
	
	@Override
	public void clearHistory(HttpServletRequest request, GIISUser USER) throws SQLException,
			Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("userId", USER.getUserId());
		this.getGiclClaimLossExpenseDAO().clearHistory(params);
	}

	@Override
	public String copyHistory(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("histSeqNo", request.getParameter("histSeqNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("clmClmntNo", request.getParameter("clmClmntNo"));
		params.put("payeeType", request.getParameter("payeeType"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("userId", USER.getUserId());
		return this.getGiclClaimLossExpenseDAO().copyHistory(params);
		
	}

	@Override//kenneth 06162015 SR3616
	public void checkHistoryNumber(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("payeeType", request.getParameter("payeeType"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("histSeqNo", request.getParameter("histSeqNo"));
		this.getGiclClaimLossExpenseDAO().checkHistoryNumber(params);
	}


}
