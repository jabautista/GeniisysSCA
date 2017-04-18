package com.geniisys.giis.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giis.dao.GIISDefaultOneRiskDAO;
import com.geniisys.giis.entity.GIISDefaultDist;
import com.geniisys.giis.entity.GIISDefaultDistDtl;
import com.geniisys.giis.entity.GIISDefaultDistGroup;
import com.geniisys.giis.service.GIISDefaultOneRiskService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISDefaultOneRiskServiceImpl implements GIISDefaultOneRiskService{
	
	private GIISDefaultOneRiskDAO giisDefaultOneRiskDAO;

	public GIISDefaultOneRiskDAO getGiisDefaultOneRiskDAO() {
		return giisDefaultOneRiskDAO;
	}

	public void setGiisDefaultOneRiskDAO(GIISDefaultOneRiskDAO giisDefaultOneRiskDAO) {
		this.giisDefaultOneRiskDAO = giisDefaultOneRiskDAO;
	}

	@Override
	public JSONObject showGiiss065(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisDefaultDistRecList");	
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	@Override
	public JSONObject showGiiss065AllRec(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisDefaultDistAllList");	
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddDefaultDistRec(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("sublineCd") != null && request.getParameter("issCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("sublineCd", request.getParameter("sublineCd"));
			params.put("issCd", request.getParameter("issCd"));
			this.giisDefaultOneRiskDAO.valAddDefaultDistRec(params);
		}
	}

	@Override
	public void valDelDefaultDistRec(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("defaultNo") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("defaultNo", request.getParameter("defaultNo"));
			this.giisDefaultOneRiskDAO.valDelDefaultDistRec(params);
		}
	}

	@Override
	public void saveGiiss065(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		String defaultNo = request.getParameter("defaultNo");
		
		if (defaultNo == "" || defaultNo == null) { //Added by Jerome 10.18.2016 SR 5552
		    defaultNo = "0";
		}
		
		params.put("setGIISDefaultDist", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setGIISDefaultDist")), userId, GIISDefaultDist.class));
		params.put("delGIISDefaultDist", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delGIISDefaultDist")), userId, GIISDefaultDist.class));
		params.put("setGIISDefaultDistDtl", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setGIISDefaultDistDtl")), userId, GIISDefaultDistDtl.class)); //Added by Jerome SR 5552
		params.put("delGIISDefaultDistDtl", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delGIISDefaultDistDtl")), userId, GIISDefaultDistDtl.class)); //Added by Jerome SR 5552
		params.put("setGIISDefaultDistGroup", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setGIISDefaultDistGroup")), userId, GIISDefaultDistGroup.class));
		params.put("delGIISDefaultDistGroup", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delGIISDefaultDistGroup")), userId, GIISDefaultDistGroup.class));
		params.put("lineCd", request.getParameter("lineCd")); //Added by Jerome 09.05.2016 SR 5552
		params.put("defaultNo", Integer.parseInt(defaultNo)); //Added by Jerome 10.17.2016 SR 5552
		
		params.put("appUser", userId);
		this.giisDefaultOneRiskDAO.saveGiiss065(params);
	}

	@Override
	public JSONObject queryGiisDefaultDistGroup(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisDefaultDistGroupRecList");
		if(request.getParameter("defaultNo") != null){
			params.put("defaultNo", request.getParameter("defaultNo"));
		}
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	@Override
	public void valExistingDistPerilRecord(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("defaultNo") != null && request.getParameter("lineCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("defaultNo", request.getParameter("defaultNo"));
			params.put("lineCd", request.getParameter("lineCd"));
			this.giisDefaultOneRiskDAO.valExistingDistPerilRecord(params);
		}
	}

	@Override
	public void valAddDefaultDistGroupRec(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("defaultNo") != null && request.getParameter("shareCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("defaultNo", request.getParameter("defaultNo"));
			params.put("shareCd", request.getParameter("shareCd"));
			this.giisDefaultOneRiskDAO.valAddDefaultDistGroupRec(params);
		}
	}

	@Override
	public JSONObject queryGiisDefaultDistDtl(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisDefaultDistDtlRecList");	
		params.put("defaultNo", request.getParameter("defaultNo"));
		//params.put("shareCd", request.getParameter("shareCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public String validateSaveExist(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("distType", request.getParameter("distType"));
		params.put("defaultType", request.getParameter("defaultType"));
		JSONObject result = new JSONObject(this.getGiisDefaultOneRiskDAO().validateSaveExist(params));
		return result.toString();
	}

	@Override
	public JSONObject queryAllGiisDefaultDistGroup(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAllGiisDefaultDistGroupRecList");
		params.put("defaultNo", request.getParameter("defaultNo"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public JSONObject queryGiisDefaultDistGroup2(HttpServletRequest request, //Added by Jerome SR 5552
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisDefaultDistGroupRecList2");
		BigDecimal rangeFrom = new BigDecimal(request.getParameter("rangeFrom"));
		BigDecimal rangeTo = new BigDecimal(request.getParameter("rangeTo"));
		
		if(request.getParameter("defaultNo") != null){
			params.put("defaultNo", request.getParameter("defaultNo"));
			params.put("rangeFrom", rangeFrom);
			params.put("rangeTo", rangeTo);
		}
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public Integer getMaxSequenceNo(Integer defaultNo) throws SQLException {
		return this.giisDefaultOneRiskDAO.getMaxSequencNo(defaultNo);
	}
}
