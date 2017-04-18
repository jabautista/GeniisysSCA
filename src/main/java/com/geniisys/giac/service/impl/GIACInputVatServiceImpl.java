package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISPayees;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.dao.GIACInputVatDAO;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.entity.GIACInputVat;
import com.geniisys.giac.entity.GIACSlLists;
import com.geniisys.giac.service.GIACInputVatService;
import com.seer.framework.util.StringFormatter;

public class GIACInputVatServiceImpl implements GIACInputVatService{
	
	private GIACInputVatDAO giacInputVatDAO;

	public GIACInputVatDAO getGiacInputVatDAO() {
		return giacInputVatDAO;
	}

	public void setGiacInputVatDAO(GIACInputVatDAO giacInputVatDAO) {
		this.giacInputVatDAO = giacInputVatDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACInputVat> getGiacInputVat(HashMap<String, String> params)
			throws SQLException {
		return (List<GIACInputVat>) StringFormatter.replaceQuotesInList(this.giacInputVatDAO.getGiacInputVat(params));
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public PaginatedList getPayeeList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<GIISPayees> payeeList = (List<GIISPayees>) StringFormatter.replaceQuotesInList(this.giacInputVatDAO.getPayeeList(params));
		PaginatedList paginatedList = new PaginatedList(payeeList , ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public PaginatedList getSlNameList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<GIACSlLists> slList = (List<GIACSlLists>) StringFormatter.replaceQuotesInList(this.giacInputVatDAO.getSlNameList(params));
		PaginatedList paginatedList = new PaginatedList(slList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public PaginatedList getAcctCodeList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<GIACChartOfAccts> acctCodeList = (List<GIACChartOfAccts>) StringFormatter.replaceQuotesInList(this.giacInputVatDAO.getAcctCodeList(params));
		PaginatedList paginatedList = new PaginatedList(acctCodeList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@Override
	public GIACChartOfAccts validateAcctCode(HashMap<String, String> params)
			throws SQLException {
		return this.giacInputVatDAO.validateAcctCode(params);
	}

	@Override
	public String saveInputVat(Map<String, Object> params) throws SQLException, JSONException {
		return this.giacInputVatDAO.saveInputVat(params);
	}
	
	@Override
	public List<GIACInputVat> prepareGIACInputVatJSON(JSONArray rows, String userId) throws JSONException{
		GIACInputVat giacInputVat = null;
		List<GIACInputVat> giacInputVatList = new ArrayList<GIACInputVat>();
		
		for(int index=0; index<rows.length(); index++) {
			giacInputVat = new GIACInputVat();
			giacInputVat.setGaccTranId(rows.getJSONObject(index).isNull("gaccTranId") ? null : rows.getJSONObject(index).getInt("gaccTranId"));
			giacInputVat.setTransactionType(rows.getJSONObject(index).isNull("transactionType") ? null :rows.getJSONObject(index).getInt("transactionType"));
			giacInputVat.setPayeeNo(rows.getJSONObject(index).isNull("payeeNo") ? null :rows.getJSONObject(index).getInt("payeeNo"));
			giacInputVat.setPayeeClassCd(rows.getJSONObject(index).isNull("payeeClassCd") ? null :rows.getJSONObject(index).getString("payeeClassCd"));
			giacInputVat.setReferenceNo(rows.getJSONObject(index).isNull("referenceNo") ? null :rows.getJSONObject(index).getString("referenceNo"));
			giacInputVat.setBaseAmt(rows.getJSONObject(index).isNull("baseAmt") ? null :new BigDecimal(rows.getJSONObject(index).getString("baseAmt")));
			giacInputVat.setInputVatAmt(rows.getJSONObject(index).isNull("inputVatAmt") ? null :new BigDecimal(rows.getJSONObject(index).getString("inputVatAmt")));
			giacInputVat.setGlAcctId(rows.getJSONObject(index).isNull("glAcctId") ? null :rows.getJSONObject(index).getInt("glAcctId"));
			giacInputVat.setVatGlAcctId(rows.getJSONObject(index).isNull("vatGlAcctId") || rows.getJSONObject(index).get("vatGlAcctId").equals("") ? null :rows.getJSONObject(index).getInt("vatGlAcctId"));
			giacInputVat.setItemNo(rows.getJSONObject(index).isNull("itemNo") ? null :rows.getJSONObject(index).getInt("itemNo"));
			giacInputVat.setSlCd(rows.getJSONObject(index).isNull("slCd") || rows.getJSONObject(index).get("slCd").equals("") ? null :rows.getJSONObject(index).getInt("slCd"));
			giacInputVat.setOrPrintTag(rows.getJSONObject(index).isNull("orPrintTag") ? null :rows.getJSONObject(index).getString("orPrintTag"));
			giacInputVat.setRemarks(rows.getJSONObject(index).isNull("remarks") ? null :rows.getJSONObject(index).getString("remarks"));
			giacInputVat.setCpiRecNo(rows.getJSONObject(index).isNull("cpiRecNo") || rows.getJSONObject(index).get("cpiRecNo").equals("") ? null :rows.getJSONObject(index).getInt("cpiRecNo"));
			giacInputVat.setCpiBranchCd(rows.getJSONObject(index).isNull("cpiBranchCd") ? null :rows.getJSONObject(index).getString("cpiBranchCd"));
			giacInputVat.setVatSlCd(rows.getJSONObject(index).isNull("vatSlCd") || rows.getJSONObject(index).get("vatSlCd").equals("") ? null :rows.getJSONObject(index).getInt("vatSlCd"));
			giacInputVat.setUserId(userId);
			giacInputVatList.add((GIACInputVat) StringFormatter.replaceQuoteTagIntoQuotesInObject(giacInputVat));
		}
		return giacInputVatList;
	}
	
}
