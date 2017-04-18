package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giis.dao.GIISMcDepreciationRateDAO;
import com.geniisys.giis.entity.GIISMcDepreciationPeril;
import com.geniisys.giis.entity.GIISMcDepreciationRate;
import com.geniisys.giis.service.GIISMcDepreciationRateService;
import com.ibm.disthub2.impl.matching.selector.ParseException;

public class GIISMcDepreciationRateServiceImpl implements GIISMcDepreciationRateService {
	
	private GIISMcDepreciationRateDAO giisMcDepreciationRateDAO;
	
	public GIISMcDepreciationRateDAO getGiisMcDepreciationRateDAO(){
		return giisMcDepreciationRateDAO;
	}
	
	public void setGiisMcDepreciationRateDAO(GIISMcDepreciationRateDAO giisMcDepreciationRateDAO) {
		this.giisMcDepreciationRateDAO = giisMcDepreciationRateDAO;
	}

	@Override
	public String saveMcDr(HttpServletRequest request, String userId) throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISMcDepreciationRate.class));
		return this.getGiisMcDepreciationRateDAO().saveMcDr(allParams);
	}
	
	@Override
	public String validateAddMcDepRate(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", request.getParameter("id"));
		params.put("carCompanyCd", request.getParameter("carCompanyCd"));
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("seriesCd", request.getParameter("seriesCd"));
		params.put("modelYear", request.getParameter("modelYear"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("sublineTypeCd", request.getParameter("sublineTypeCd"));
		return this.getGiisMcDepreciationRateDAO().validateAddMcDepRate(params);
	}	
	
	@Override
	public String validateMcPerilRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", request.getParameter("id"));
		return this.getGiisMcDepreciationRateDAO().validateMcPerilRec(params);
	}
	
	@Override
	public String deleteMcPerilRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", request.getParameter("id"));
		return this.getGiisMcDepreciationRateDAO().deleteMcPerilRec(params);
	}	
	
	@Override
	public String savePerilDepRate(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISMcDepreciationPeril.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISMcDepreciationPeril.class));		
		return this.getGiisMcDepreciationRateDAO().savePerilDepRate(allParams);
	}	
}
