package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISMcFairMarketValueDAO;
import com.geniisys.giis.entity.GIISMcFairMarketValue;
import com.geniisys.giis.service.GIISMcFairMarketValueService;

public class GIISMcFairMarketValueServiceImpl implements GIISMcFairMarketValueService {
	
	private GIISMcFairMarketValueDAO giisMcFairMarketValueDAO;
	
	public GIISMcFairMarketValueDAO getGiisMcFairMarketValueDAO(){
		return giisMcFairMarketValueDAO;
	}
	
	public void setGiisMcFairMarketValueDAO(GIISMcFairMarketValueDAO giisMcFairMarketValueDAO) {
		this.giisMcFairMarketValueDAO = giisMcFairMarketValueDAO;
	}

	@Override
	public JSONObject showMcFairMarketValueMaintenance(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS223FmvList");
		params.put("carCompanyCd", request.getParameter("carCompanyCd"));
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("seriesCd", request.getParameter("seriesCd"));		
		Map<String, Object> fmvListing = TableGridUtil.getTableGrid(request,params);
		JSONObject json = new JSONObject(fmvListing);
		request.setAttribute("fmvListing", json);
		return json;	
	}

	@Override
	public String saveFmv(HttpServletRequest request, String userId) throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISMcFairMarketValue.class));
		return this.getGiisMcFairMarketValueDAO().saveFmv(allParams);
	}
}
