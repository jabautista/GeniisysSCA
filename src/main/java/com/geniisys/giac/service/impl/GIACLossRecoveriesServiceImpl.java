package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.dao.GIACLossRecoveriesDAO;
import com.geniisys.giac.entity.GIACLossRecoveries;
import com.geniisys.giac.service.GIACLossRecoveriesService;
import com.seer.framework.util.StringFormatter;

public class GIACLossRecoveriesServiceImpl implements GIACLossRecoveriesService{

	private GIACLossRecoveriesDAO giacLossRecoveriesDAO;

	public GIACLossRecoveriesDAO getGiacLossRecoveriesDAO() {
		return giacLossRecoveriesDAO;
	}

	public void setGiacLossRecoveriesDAO(GIACLossRecoveriesDAO giacLossRecoveriesDAO) {
		this.giacLossRecoveriesDAO = giacLossRecoveriesDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACLossRecoveries> getGIACLossRecoveries(Integer gaccTranId)
			throws SQLException {
		return (List<GIACLossRecoveries>) StringFormatter.escapeHTMLInList(this.giacLossRecoveriesDAO.getGIACLossRecoveries(gaccTranId));
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public PaginatedList getRecoveryNoList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<Map<String, Object>> invListing = (List<Map<String, Object>>) StringFormatter.replaceQuotesInListOfMap(this.giacLossRecoveriesDAO.getRecoveryNoList(params));
		PaginatedList paginatedList = new PaginatedList(invListing , ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@Override
	public Map<String, Object> getSumCollnAmtLossRec(
			Map<String, Object> params) throws SQLException {
		return this.giacLossRecoveriesDAO.getSumCollnAmtLossRec(params);
	}

	@Override
	public Map<String, Object> getCurrency(Map<String, Object> params)
			throws SQLException {
		return StringFormatter.replaceQuotesInMap(this.giacLossRecoveriesDAO.getCurrency(params));
	}

	@Override
	public Map<String, Object> validateCurrencyCode(Map<String, Object> params)
			throws SQLException {
		return StringFormatter.replaceQuotesInMap(this.giacLossRecoveriesDAO.validateCurrencyCode(params));
	}

	@Override
	public String validateDeleteLossRec(Map<String, Object> params) throws SQLException {
		return this.giacLossRecoveriesDAO.validateDeleteLossRec(params);
	}

	@Override
	public String getTranFlag(Integer gaccTranId) throws SQLException {
		return this.giacLossRecoveriesDAO.getTranFlag(gaccTranId);
	}

	@Override
	public List<GIACLossRecoveries> prepareGIACLossRecoveriesJSON(
			JSONArray rows, String userId) throws JSONException {
		GIACLossRecoveries lossRec = null;
		List<GIACLossRecoveries> list = new ArrayList<GIACLossRecoveries>();
		for(int index=0; index<rows.length(); index++) {
			lossRec = new GIACLossRecoveries();
			lossRec.setGaccTranId(rows.getJSONObject(index).isNull("gaccTranId") ? null : rows.getJSONObject(index).getInt("gaccTranId"));
			lossRec.setTransactionType(rows.getJSONObject(index).isNull("transactionType") ? null :rows.getJSONObject(index).getInt("transactionType"));
			lossRec.setClaimId(rows.getJSONObject(index).isNull("claimId") ? null : rows.getJSONObject(index).getInt("claimId"));
			lossRec.setRecoveryId(rows.getJSONObject(index).isNull("recoveryId") ? null : rows.getJSONObject(index).getInt("recoveryId"));
			lossRec.setPayorClassCd(rows.getJSONObject(index).isNull("payorClassCd") ? null : rows.getJSONObject(index).getString("payorClassCd"));
			lossRec.setPayorCd(rows.getJSONObject(index).isNull("payorCd") ? null : rows.getJSONObject(index).getInt("payorCd"));
			lossRec.setCollectionAmt(rows.getJSONObject(index).isNull("collectionAmt") ? null :new BigDecimal(rows.getJSONObject(index).getString("collectionAmt")));
			lossRec.setCurrencyCd(rows.getJSONObject(index).isNull("currencyCd") ? null : rows.getJSONObject(index).getInt("currencyCd"));
			lossRec.setConvertRate(rows.getJSONObject(index).isNull("convertRate") ? null :new BigDecimal(rows.getJSONObject(index).getString("convertRate")));
			lossRec.setForeignCurrAmt(rows.getJSONObject(index).isNull("foreignCurrAmt") ? null :new BigDecimal(rows.getJSONObject(index).getString("foreignCurrAmt")));
			lossRec.setOrPrintTag(rows.getJSONObject(index).isNull("orPrintTag") ? null :rows.getJSONObject(index).getString("orPrintTag"));
			lossRec.setRemarks(rows.getJSONObject(index).isNull("remarks") ? null :rows.getJSONObject(index).getString("remarks"));
			lossRec.setCpiRecNo(rows.getJSONObject(index).isNull("cpiRecNo") || rows.getJSONObject(index).get("cpiRecNo").equals("") ? null :rows.getJSONObject(index).getInt("cpiRecNo"));
			lossRec.setCpiBranchCd(rows.getJSONObject(index).isNull("cpiBranchCd") ? null :rows.getJSONObject(index).getString("cpiBranchCd"));
			lossRec.setAcctEntTag(rows.getJSONObject(index).isNull("acctEntTag") ? null :rows.getJSONObject(index).getString("acctEntTag"));
			lossRec.setUserId(userId);
			list.add((GIACLossRecoveries) StringFormatter.replaceQuoteTagIntoQuotesInObject(lossRec));
		}
		return list;
	}

	@Override
	public String saveLossRec(Map<String, Object> params) throws SQLException{
		return this.giacLossRecoveriesDAO.saveLossRec(params);
	}

	@Override
	public List<String> getManualRecoveryList(
			Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return this.giacLossRecoveriesDAO.getManualRecoveryList(params);
	}

	@Override
	public List<String> checkPayorNameExist(Map<String, Object> params)
			throws SQLException {
		// TODO Auto-generated method stub
		return this.giacLossRecoveriesDAO.checkPayorNameExist(params);
	}

	@Override
	public String checkCollectionAmt(Map<String, Object> params)
			throws SQLException {
		return this.getGiacLossRecoveriesDAO().checkCollectionAmt(params);
	}
	
}
