package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLLossProfileDAO;
import com.geniisys.gicl.entity.GICLLossProfile;
import com.geniisys.gicl.service.GICLLossProfileService;

public class GICLLossProfileServiceImpl implements GICLLossProfileService{

	private GICLLossProfileDAO giclLossProfileDAO;

	public GICLLossProfileDAO getGiclLossProfileDAO() {
		return giclLossProfileDAO;
	}

	public void setGiclLossProfileDAO(GICLLossProfileDAO giclLossProfileDAO) {
		this.giclLossProfileDAO = giclLossProfileDAO;
	}

	@Override
	public Map<String, Object> whenNewFormInstance() throws SQLException {
		return this.getGiclLossProfileDAO().whenNewFormInstance();
	}

	@Override
	public JSONObject showLossProfileParam(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getLossProfileParamList");
		params.put("userId", userId);
		params.put("moduleId", request.getParameter("moduleId"));
		
		Map<String, Object> lossProfileParamTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonLossProfileParamList = new JSONObject(lossProfileParamTableGrid);
		return jsonLossProfileParamList;
	}

	@Override
	public void saveProfile(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLLossProfile.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GICLLossProfile.class));
		params.put("setDtlRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setDtlRows")), userId, GICLLossProfile.class));
		params.put("delDtlRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delDtlRows")), userId, GICLLossProfile.class));
		params.put("type", request.getParameter("type"));
		params.put("appUser", userId);
		
		this.getGiclLossProfileDAO().saveProfile(params);
	}

	@Override
	public JSONObject showRange(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRangeList");		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		
		Map<String, Object> rangeTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRangeList = new JSONObject(rangeTableGrid);
		return jsonRangeList;
	}

	@Override
	public String extractLossProfile(HttpServletRequest request, String userId) throws SQLException, ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("paramDate", request.getParameter("paramDate"));
		params.put("claimDate", request.getParameter("claimDate"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("dateFrom", request.getParameter("dateFrom") == null ? null : sdf.parse((String) request.getParameter("dateFrom")));
		params.put("dateTo", request.getParameter("dateTo") == null ? null : sdf.parse((String) request.getParameter("dateTo")));
		params.put("lossDateFrom", request.getParameter("lossDateFrom") == null ? null : sdf.parse((String) request.getParameter("lossDateFrom")));
		params.put("lossDateTo", request.getParameter("lossDateTo") == null ? null : sdf.parse((String) request.getParameter("lossDateTo")));
		params.put("extractByRg", Integer.parseInt(request.getParameter("extractByRg")));
		params.put("eType", Integer.parseInt(request.getParameter("eType")));
		JSONObject result = new JSONObject(this.getGiclLossProfileDAO().extractLossProfile(params)); 
		return result.toString();
	}

	@Override
	public JSONObject showLossProfileSummary(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getLossProfileSummaryList");
		params.put("globalChoice", request.getParameter("globalChoice"));
		params.put("globalTreaty", request.getParameter("globalTreaty"));
		params.put("globalLineCd", request.getParameter("globalLineCd"));
		params.put("globalSublineCd", request.getParameter("globalSublineCd"));
		params.put("userId", userId);
		
		Map<String, Object> json = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonList = new JSONObject(json);
		return jsonList;
	}

	@Override
	public JSONObject showLossProfileDetail(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getLossProfileDetailList");
		params.put("globalExtr", request.getParameter("globalExtr"));
		params.put("rangeFrom", request.getParameter("rangeFrom"));
		params.put("rangeTo", request.getParameter("rangeTo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("userId", userId);
		
		Map<String, Object> json = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonList = new JSONObject(json);
		return jsonList;
	}

	@Override
	public String checkRecovery(HttpServletRequest request) throws SQLException {
		Integer claimId = Integer.parseInt(request.getParameter("claimId"));
		return this.getGiclLossProfileDAO().checkRecovery(claimId);
	}

	@Override
	public JSONObject showRecoveryListing(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRecoveryList");
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("globalExtr", request.getParameter("globalExtr"));
		
		Map<String, Object> json = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonList = new JSONObject(json);
		return jsonList;
	}
	
	@Override
	public void validateRange(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("rangeFrom", request.getParameter("rangeFrom"));
		params.put("rangeTo", request.getParameter("rangeTo"));
		params.put("oldFrom", request.getParameter("oldFrom"));
		params.put("oldTo", request.getParameter("oldTo"));
		params.put("userId", userId);
		
		this.getGiclLossProfileDAO().validateRange(params);
	}
	
}
