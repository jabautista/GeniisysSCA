package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLBatchCsrDAO;
import com.geniisys.gicl.entity.GICLAdvice;
import com.geniisys.gicl.entity.GICLBatchCsr;
import com.geniisys.gicl.service.GICLBatchCsrService;

public class GICLBatchCsrServiceImpl implements GICLBatchCsrService{
	
	private GICLBatchCsrDAO giclBatchCsrDAO;

	public void setGiclBatchCsrDAO(GICLBatchCsrDAO giclBatchCsrDAO) {
		this.giclBatchCsrDAO = giclBatchCsrDAO;
	}

	public GICLBatchCsrDAO getGiclBatchCsrDAO() {
		return giclBatchCsrDAO;
	}

	@Override
	public GICLBatchCsr getGICLBatchCsr(Map<String, Object> params)
			throws SQLException {
		return this.getGiclBatchCsrDAO().getGICLBatchCsr(params);
	}

	@Override
	public Integer generateBatchNumber(JSONObject objParams, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		List<GICLAdvice> adviceList = this.prepareAdviceListForBatchCsr(new JSONArray(objParams.getString("adviceList")));
		params.put("batchCsr", JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("batchCsr")), USER.getUserId(), GICLBatchCsr.class));
		params.put("adviceList", adviceList);
		params.put("userId", USER.getUserId());
		return this.getGiclBatchCsrDAO().generateBatchNumber(params);
	}
	
	private List<GICLAdvice> prepareAdviceListForBatchCsr(JSONArray list) throws JSONException{
		List<GICLAdvice> giclAdviceList = new ArrayList<GICLAdvice>();
		
		for(int i=0; i<list.length(); i++){
			GICLAdvice giclAdvice = new GICLAdvice();
			JSONObject obj = new JSONObject();
			obj = list.getJSONObject(i);
			giclAdvice.setAdviceId(obj.isNull("adviceId") ? null : obj.getInt("adviceId"));
			giclAdvice.setClaimId(obj.isNull("claimId") ? null : obj.getInt("claimId"));
			giclAdvice.setLineCode(obj.isNull("lineCode") ? "" : obj.getString("lineCode"));
			giclAdvice.setIssueCode(obj.isNull("issueCode") ? "" : obj.getString("issueCode"));
			giclAdvice.setAdviceYear(obj.isNull("adviceYear") ? null : obj.getInt("adviceYear"));
			giclAdvice.setAdviceSequenceNumber(obj.isNull("adviceSequenceNumber") ? null : obj.getInt("adviceSequenceNumber"));
			giclAdviceList.add(giclAdvice);
		}
		
		return giclAdviceList;
		
	}

	@Override
	public void cancelBatchCsr(Map<String, Object> params) throws SQLException,
			Exception {
		this.getGiclBatchCsrDAO().cancelBatchCsr(params);
	}

	@Override
	public Map<String, Object> gicls043C024PostQuery(Map<String, Object> params)
			throws SQLException, Exception {
		return this.getGiclBatchCsrDAO().gicls043C024PostQuery(params);
	}

	@Override
	public void saveBatchCsr(JSONObject objParams, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("batchCsr", JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("batchCsr")), USER.getUserId(), GICLBatchCsr.class));
		this.getGiclBatchCsrDAO().saveBatchCsr(params);
	}

	@Override
	public String getBatchCsrReportId(Map<String, Object> params)
			throws SQLException, Exception {
		return this.getGiclBatchCsrDAO().getBatchCsrReportId(params);
	}

}
