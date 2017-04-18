package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIRiskLossProfileDAO;
import com.geniisys.gipi.service.GIPIRiskLossProfileService;

public class GIPIRiskLossProfileServiceImpl implements GIPIRiskLossProfileService{

	private GIPIRiskLossProfileDAO gipiRiskLossProfileDAO;	

	public GIPIRiskLossProfileDAO getGipiRiskLossProfileDAO() {
		return gipiRiskLossProfileDAO;
	}

	public void setGipiRiskLossProfileDAO(GIPIRiskLossProfileDAO gipiRiskLossProfileDAO) {
		this.gipiRiskLossProfileDAO = gipiRiskLossProfileDAO;
	}

	@Override
	public JSONObject getGipiRiskLossProfile(HttpServletRequest request, String userId)
			throws SQLException, JSONException {		
		
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getGipiRiskLossProfile");
		params.put("userId", userId);
		return new JSONObject((Map<String, Object>)TableGridUtil.getTableGrid(request, params));
	}

	@Override
	public JSONObject getGipiRiskLossProfileRange(HttpServletRequest request, String userId)
			throws SQLException, JSONException {

		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getGipiRiskLossProfileRange");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("userId", userId);
		return new JSONObject((Map<String, Object>)TableGridUtil.getTableGrid(request, params));
	}

	@Override
	public void saveGIPIS902(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setParamRows", new JSONArray(request.getParameter("setParamRows")));
		params.put("delParamRows", new JSONArray(request.getParameter("delParamRows")));
		params.put("setRangeRows", new JSONArray(request.getParameter("setRangeRows")));
		params.put("delRangeRows", new JSONArray(request.getParameter("delRangeRows")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("type", request.getParameter("type"));
		params.put("userId", userId);
		gipiRiskLossProfileDAO.saveGIPIS902(params);		
	}

	@Override
	public void extractGIPIS902(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("paramDate", request.getParameter("paramDate"));
		params.put("allLineTag", request.getParameter("allLineTag"));
		params.put("byTarf", request.getParameter("byTarf"));
		params.put("credBranch", request.getParameter("credBranch"));
		params.put("incExpired", request.getParameter("incExpired"));
		params.put("incEndt", request.getParameter("incEndt"));
		params.put("lossDateFrom", request.getParameter("lossDateFrom"));
		params.put("lossDateTo", request.getParameter("lossDateTo"));
		params.put("claimDate", request.getParameter("claimDate"));
		params.put("userId", userId); //added by gab 06.09.2016 SR 21538	
		
		gipiRiskLossProfileDAO.extractGIPIS902(params);
	}
}
