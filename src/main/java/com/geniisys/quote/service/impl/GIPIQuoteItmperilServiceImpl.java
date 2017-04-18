package com.geniisys.quote.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.quote.dao.GIPIQuoteItmperilDAO;
import com.geniisys.quote.entity.GIPIQuoteItmperil;
import com.geniisys.quote.service.GIPIQuoteItmperilService;

public class GIPIQuoteItmperilServiceImpl implements GIPIQuoteItmperilService{

	private GIPIQuoteItmperilDAO gipiQuoteItmperilDAO;

	public GIPIQuoteItmperilDAO getGipiQuoteItmperilDAO() {
		return gipiQuoteItmperilDAO;
	}

	public void setGipiQuoteItmperilDAO(GIPIQuoteItmperilDAO gipiQuoteItmperilDAO) {
		this.gipiQuoteItmperilDAO = gipiQuoteItmperilDAO;
	}
	
	@Override
	public String savePerilInfo(String rowParams, Map<String, Object> params)
			throws JSONException, SQLException {
		JSONObject objParameters = new JSONObject(rowParams);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), (String)params.get("userId"), GIPIQuoteItmperil.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), (String)params.get("userId"), GIPIQuoteItmperil.class));
		return this.getGipiQuoteItmperilDAO().savePerilInfo(allParams, params);
	}

	@Override
	public List<GIPIQuoteItmperil> getItmperils(Map<String, Object> params)
			throws SQLException {
		return this.getGipiQuoteItmperilDAO().getItmperils(params);
	}
	
}
