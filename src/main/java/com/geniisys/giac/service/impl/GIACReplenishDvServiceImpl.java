/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.service.impl
	File Name: GIACReplenishDvServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Nov 8, 2012
	Description: 
*/


package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACReplenishDvDAO;
import com.geniisys.giac.entity.GIACReplenishDv;
import com.geniisys.giac.service.GIACReplenishDvService;
import com.seer.framework.util.StringFormatter;

public class GIACReplenishDvServiceImpl implements GIACReplenishDvService{

	private GIACReplenishDvDAO giacReplenishDvDAO;
	
	@Override
	public Map<String, Object> getRfDetailAmounts(Map<String, Object> params)
			throws SQLException {
		return getGiacReplenishDvDAO().getRfDetailAmounts(params);
	}

	public GIACReplenishDvDAO getGiacReplenishDvDAO() {
		return giacReplenishDvDAO;
	}

	public void setGiacReplenishDvDAO(GIACReplenishDvDAO giacReplenishDvDAO) {
		this.giacReplenishDvDAO = giacReplenishDvDAO;
	}

	@Override
	public void saveRfDetail(String strParameters, String userId)
			throws SQLException, org.json.JSONException {
		JSONObject objParameter  = new JSONObject(strParameters);
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setRows",JSONUtil.prepareMapListFromJSON(new JSONArray(objParameter.getString("setRows"))));
		params.put("replenishId", objParameter.getString("replenishId"));
		params.put("userId",userId);
		
		getGiacReplenishDvDAO().saveRfDetail(params);
	}

	@Override
	public Map<String, Object> getGIACS016AcctEntPostQuery(
			Map<String, Object> params) throws SQLException {
				return getGiacReplenishDvDAO().getGIACS016AcctEntPostQuery(params);
	}

	@Override
	public JSONObject showReplenishmentListing(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getReplenishmentListing");
		params.put("userId", USER.getUserId());	// shan 10.08.2014
		Map<String, Object> replenishmentListingTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonReplenishmentListing = new JSONObject(replenishmentListingTableGrid);
		request.setAttribute("jsonReplenishmentListing", jsonReplenishmentListing);
		return jsonReplenishmentListing;
	}

	@Override
	public JSONObject showReplenishmentDetail(HttpServletRequest request,GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getReplenishmentDetail");
		params.put("replenishId", request.getParameter("replenishId"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("checkDateFrom", request.getParameter("checkDateFrom"));
		params.put("checkDateTo", request.getParameter("checkDateTo"));
		params.put("modifyRec", request.getParameter("modifyRec"));
		Map<String, Object> replenishmentTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonReplenishmentDetail = new JSONObject(replenishmentTableGrid);
		request.setAttribute("jsonReplenishmentDetail", jsonReplenishmentDetail);
		return jsonReplenishmentDetail;

	}
	
	@Override
	public JSONObject showReplenishmentDetailList(HttpServletRequest request,GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getReplenishmentDetail");
		params.put("replenishId", request.getParameter("replenishId"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("checkDateFrom", request.getParameter("checkDateFrom"));
		params.put("checkDateTo", request.getParameter("checkDateTo"));
		params.put("modifyRec", request.getParameter("modifyRec"));
		params.put("pageSize", 50);
		Map<String, Object> replenishmentTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonReplenishmentDetail = new JSONObject(replenishmentTableGrid);
		request.setAttribute("jsonReplenishmentDetailListing", jsonReplenishmentDetail);
		return jsonReplenishmentDetail;

	}	
	

	@Override
	public JSONObject showReplenishmentAcctEntries(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getReplenishmentAcctEntries");
		params.put("tranId", request.getParameter("tranId"));
		Map<String, Object> replenishmentAcctEntTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonReplenishmentAcctEnt = new JSONObject(replenishmentAcctEntTableGrid);
		request.setAttribute("jsonReplenishmentAcctEnt", jsonReplenishmentAcctEnt);
		return jsonReplenishmentAcctEnt;
	}
	
	@Override
	public JSONObject showReplenishmentSumAcctEntries(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getReplenishmentSumAcctEntries");
		params.put("replenishId", request.getParameter("replenishId"));
		Map<String, Object> replenishmentSumAcctEntTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonReplenishmentSumAcctEnt = new JSONObject(replenishmentSumAcctEntTableGrid);
		request.setAttribute("jsonReplenishmentSumAcctEnt", jsonReplenishmentSumAcctEnt);
		return jsonReplenishmentSumAcctEnt;
	}
	
	@Override
	public void saveReplenishmentMasterRecord(HttpServletRequest request,  GIISUser USER) throws SQLException {
		Map<String, Object> masterParams = new HashMap<String, Object>();
		masterParams.put("replenishId", request.getParameter("replenishId"));
		masterParams.put("branchCd", request.getParameter("branchCd"));
		masterParams.put("revolvingFund", request.getParameter("revolvingFund").equals(null) || request.getParameter("revolvingFund").equals("") ? new BigDecimal(0.00) : new BigDecimal(request.getParameter("revolvingFund")));
		masterParams.put("totalTagged", request.getParameter("totalTagged").equals(null) || request.getParameter("totalTagged").equals("") ? new BigDecimal(0.00) : new BigDecimal(request.getParameter("totalTagged")));
		masterParams.put("appUser", USER.getUserId());
		masterParams.put("exist", request.getParameter("exist"));
		this.giacReplenishDvDAO.saveReplenishmentMasterRecord(masterParams);
	}	

	@Override
	public void saveReplenishment(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		String userId = USER.getUserId();
		Map<String, Object> repParams = new HashMap<String, Object>();
		repParams.put("replenishId", request.getParameter("replenishId"));
		repParams.put("revolvingFund", request.getParameter("revolvingFund").equals(null) || request.getParameter("revolvingFund").equals("") ? new BigDecimal(0.00) : new BigDecimal(request.getParameter("revolvingFund")));;
		repParams.put("totalTagged", request.getParameter("totalTagged").equals(null) || request.getParameter("totalTagged").equals("") ? new BigDecimal(0.00) : new BigDecimal(request.getParameter("totalTagged")));
		repParams.put("appUser", USER.getUserId());		
		repParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACReplenishDv.class));
		System.out.println(">>>>>>>>>>>>>>>>" + new JSONArray(request.getParameter("setRows")));
		this.giacReplenishDvDAO.saveReplenishment(repParams);
	}
	
	@Override
	public Map<String, Object> getCurrReplenishmentId(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCurrReplenishmentId");
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", USER.getUserId());	// shan 10.08.2014
		params = this.giacReplenishDvDAO.getCurrReplenishmentId(params);
		List<?> list = (List<?>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("rec", new JSONArray(list));
		return params;
	}
	
	public String checkReplenishmentPaytReq(Map<String, Object> params) throws SQLException{
		String res = this.giacReplenishDvDAO.checkReplenishmentPaytReq(params);
		res = (res == null ? "Y" : "N");
		return res;
	}
	
	public BigDecimal getRevolvingFund(Map<String, Object> params) throws SQLException{
		return this.giacReplenishDvDAO.getRevolvingFund(params);
	}
}
