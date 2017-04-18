package com.geniisys.giex.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giex.dao.GIEXSmsDtlDAO;
import com.geniisys.giex.entity.GIEXExpiry;
import com.geniisys.giex.service.GIEXSmsDtlService;

public class GIEXSmsDtlServiceImpl implements GIEXSmsDtlService{

	private GIEXSmsDtlDAO giexSmsDtlDAO;
	
	public GIEXSmsDtlDAO getGiexSmsDtlDAO() {
		return giexSmsDtlDAO;
	}

	public void setGiexSmsDtlDAO(GIEXSmsDtlDAO giexSmsDtlDAO) {
		this.giexSmsDtlDAO = giexSmsDtlDAO;
	}
	
	@Override
	public Map<String, Object> checkSMSAssured(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("assdNo", Integer.parseInt(request.getParameter("assdNo")));
		return this.getGiexSmsDtlDAO().checkSMSAssured(params);
	}

	@Override
	public Map<String, Object> checkSMSIntm(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		return this.getGiexSmsDtlDAO().checkSMSIntm(params);
	}

	@Override
	public void updateSMSTags(HttpServletRequest request, String userId) throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setRows")), userId, GIEXExpiry.class));
		this.getGiexSmsDtlDAO().updateSMSTags(params);
	}

	@Override
	public void sendSMS(HttpServletRequest request, String userId) throws SQLException, JSONException{
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setRows")), userId, GIEXExpiry.class));
		params.put("userId", userId);
		this.getGiexSmsDtlDAO().sendSMS(params);
	}

	@Override
	public void saveSMS(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setRows")), userId, GIEXExpiry.class));
		this.getGiexSmsDtlDAO().saveSMS(params);
	}

}
