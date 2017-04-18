package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACCommSlipExtDAO;
import com.geniisys.giac.service.GIACCommSlipExtService;

public class GIACCommSlipExtServiceImpl implements GIACCommSlipExtService{
	
	private GIACCommSlipExtDAO giacCommSlipExtDAO;

	public GIACCommSlipExtDAO getGiacCommSlipExtDAO() {
		return giacCommSlipExtDAO;
	}

	public void setGiacCommSlipExtDAO(GIACCommSlipExtDAO giacCommSlipExtDAO) {
		this.giacCommSlipExtDAO = giacCommSlipExtDAO;
	}

	@Override
	public void populateBatchCommSlip(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orNo", request.getParameter("orNo"));
		params.put("orPref", request.getParameter("orPref"));
		this.getGiacCommSlipExtDAO().populateBatchCommSlip(params);
	}
	
	@Override
	public JSONObject getBatchCommSlip(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBatchCommSlip");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orNo", request.getParameter("orNo"));
		params.put("orPref", request.getParameter("orPref"));
		
		if(!("1".equals(request.getParameter("refresh")))){
			this.populateBatchCommSlip(request);
		}
		
		Map<String, Object> batchCommSlipTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(batchCommSlipTG);
	}

	@Override
	public Map<String, Object> getCommSlipNo(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", userId);
		return this.getGiacCommSlipExtDAO().getCommSlipNo(params);
	}

	@Override
	public void tagAll(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = JSONUtil.prepareMapFromJSON(new JSONObject(request.getParameter("params")));
		this.getGiacCommSlipExtDAO().tagAll(params);
	}

	@Override
	public void untagAll() throws SQLException {
		this.getGiacCommSlipExtDAO().untagAll();
	}

	@Override
	public Map<String, Object> generateCommSlipNo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("commSlipPref", request.getParameter("commSlipPref"));
		params.put("commSlipSeq", request.getParameter("commSlipSeq"));
		return this.getGiacCommSlipExtDAO().generateCommSlipNo(params);
	}

	@Override
	public void saveGenerateFlag(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("setRows"))));
		this.getGiacCommSlipExtDAO().saveGenerateFlag(params);
	}

	@Override
	public List<Map<String, Object>> getBatchCommSlipReports()
			throws SQLException {
		return this.getGiacCommSlipExtDAO().getBatchCommSlipReports();
	}

	@Override
	public Map<String, Object> updateCommSlip(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("commSlipPref", request.getParameter("commSlipPref"));
		params.put("commSlipSeq", request.getParameter("commSlipSeq"));
		params.put("userId", userId);
		return this.getGiacCommSlipExtDAO().updateCommSlip(params);
	}

	@Override
	public void clearCommSlipNo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("intmNo", request.getParameter("intmNo"));
		this.getGiacCommSlipExtDAO().clearCommSlipNo(params);
	}
	
}
