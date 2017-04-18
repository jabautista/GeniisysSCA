package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACLossRiCollnsDAO;
import com.geniisys.giac.entity.GIACLossRiCollns;
import com.geniisys.giac.service.GIACLossRiCollnsService;
import com.seer.framework.util.StringFormatter;

public class GIACLossRiCollnsServiceImpl implements GIACLossRiCollnsService{

	private GIACLossRiCollnsDAO giacLossRiCollnsDAO;

	private Logger log = Logger.getLogger(GIACLossRiCollnsServiceImpl.class);
	
	public GIACLossRiCollnsDAO getGiacLossRiCollnsDAO() {
		return giacLossRiCollnsDAO;
	}

	public void setGiacLossRiCollnsDAO(GIACLossRiCollnsDAO giacLossRiCollnsDAO) {
		this.giacLossRiCollnsDAO = giacLossRiCollnsDAO;
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public PaginatedList getLossAdviceList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<Map<String, Object>> listing = (List<Map<String, Object>>) StringFormatter.replaceQuotesInListOfMap(this.giacLossRiCollnsDAO.getLossAdviceList(params));
		PaginatedList paginatedList = new PaginatedList(listing , ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACLossRiCollns> getGIACLossRiCollns(Integer gaccTranId)
			throws SQLException {
		return (List<GIACLossRiCollns>) StringFormatter.replaceQuotesInList(this.giacLossRiCollnsDAO.getGIACLossRiCollns(gaccTranId));
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> validateFLA(HashMap<String, Object> params)
			throws SQLException {
		return (List<Map<String, Object>>) StringFormatter.replaceQuotesInList(this.giacLossRiCollnsDAO.validateFLA(params));
	}

	@Override
	public Map<String, Object> validateCurrencyCode(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) StringFormatter.replaceQuotesInMap(this.giacLossRiCollnsDAO.validateCurrencyCode(params));
	}

	public Map<String, Object> prepareParametersGIACLossRiCollns(
			HttpServletRequest request, GIISUser USER, Integer gaccTranId, String gaccBranchCd, String gaccFundCd) throws JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", gaccTranId);
		params.put("gaccBranchCd", gaccBranchCd);
		params.put("gaccFundCd", gaccFundCd);
		params.put("tranSource", request.getParameter("globalTranSource"));
		params.put("orFlag", request.getParameter("globalOrFlag"));
		params.put("userId", USER.getUserId());
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIACLossRiCollns.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delRows")), USER.getUserId(), GIACLossRiCollns.class));
		return params;
	}
	
	@Override
	public String saveLossesRecov(Map<String, Object> params)
			throws SQLException {
		return this.giacLossRiCollnsDAO.saveLossesRecov(params);
	}

	@Override
	public List<GIACLossRiCollns> prepareGIACLossRiCollnsJSON(
			JSONArray rows, String userId) throws JSONException {
		GIACLossRiCollns lossesRecov = null;
		List<GIACLossRiCollns> list = new ArrayList<GIACLossRiCollns>();
		for(int index=0; index<rows.length(); index++) {
			lossesRecov = new GIACLossRiCollns();
			lossesRecov.setGaccTranId(rows.getJSONObject(index).isNull("gaccTranId") ? null : rows.getJSONObject(index).getInt("gaccTranId"));
			lossesRecov.setA180RiCd(rows.getJSONObject(index).isNull("a180RiCd") ? null :rows.getJSONObject(index).getInt("a180RiCd"));
			lossesRecov.setTransactionType(rows.getJSONObject(index).isNull("transactionType") ? null :rows.getJSONObject(index).getInt("transactionType"));
			lossesRecov.setE150LineCd(rows.getJSONObject(index).isNull("e150LineCd") ? null :rows.getJSONObject(index).getString("e150LineCd"));
			lossesRecov.setE150LaYy(rows.getJSONObject(index).isNull("e150LaYy") ? null :rows.getJSONObject(index).getInt("e150LaYy"));
			lossesRecov.setE150FlaSeqNo(rows.getJSONObject(index).isNull("e150FlaSeqNo") ? null :rows.getJSONObject(index).getInt("e150FlaSeqNo"));
			lossesRecov.setCollectionAmt(rows.getJSONObject(index).isNull("collectionAmt") ? null :new BigDecimal(rows.getJSONObject(index).getString("collectionAmt")));
			lossesRecov.setClaimId(rows.getJSONObject(index).isNull("claimId") ? null :rows.getJSONObject(index).getInt("claimId"));
			lossesRecov.setCurrencyCd(rows.getJSONObject(index).isNull("currencyCd") ? null :rows.getJSONObject(index).getInt("currencyCd"));
			lossesRecov.setConvertRate(rows.getJSONObject(index).isNull("convertRate") ? null :new BigDecimal(rows.getJSONObject(index).getString("convertRate")));
			lossesRecov.setForeignCurrAmt(rows.getJSONObject(index).isNull("foreignCurrAmt") ? null :new BigDecimal(rows.getJSONObject(index).getString("foreignCurrAmt")));
			lossesRecov.setOrPrintTag(rows.getJSONObject(index).isNull("orPrintTag") ? null :rows.getJSONObject(index).getString("orPrintTag"));
			lossesRecov.setParticulars(rows.getJSONObject(index).isNull("particulars") ? null :rows.getJSONObject(index).getString("particulars"));
			lossesRecov.setCpiRecNo(rows.getJSONObject(index).isNull("cpiRecNo") || rows.getJSONObject(index).get("cpiRecNo").equals("") ? null :rows.getJSONObject(index).getInt("cpiRecNo"));
			lossesRecov.setCpiBranchCd(rows.getJSONObject(index).isNull("cpiBranchCd") ? null :rows.getJSONObject(index).getString("cpiBranchCd"));
			lossesRecov.setShareType(rows.getJSONObject(index).isNull("shareType") ? null :rows.getJSONObject(index).getString("shareType"));
			lossesRecov.setPayeeType(rows.getJSONObject(index).isNull("payeeType") ? null :rows.getJSONObject(index).getString("payeeType"));
			lossesRecov.setUserId(userId);
			lossesRecov.setAppUser(userId);
			list.add((GIACLossRiCollns) StringFormatter.replaceQuoteTagIntoQuotesInObject(lossesRecov));
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getLossAdviceListTableGrid(
			HashMap<String, Object> params) throws SQLException, JSONException {
		if ((String) params.get("filter")!=null){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
		}
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> lossAdviceListing = this.giacLossRiCollnsDAO.getLossAdviceListTableGrid(params);
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInListOfMap(lossAdviceListing)));
		grid.setNoOfPages(lossAdviceListing);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
}
