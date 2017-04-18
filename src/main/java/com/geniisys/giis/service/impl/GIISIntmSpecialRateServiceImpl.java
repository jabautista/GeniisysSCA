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
import com.geniisys.giis.dao.GIISIntmSpecialRateDAO;
import com.geniisys.giis.entity.GIISIntmSpecialRate;
import com.geniisys.giis.service.GIISIntmSpecialRateService;

public class GIISIntmSpecialRateServiceImpl implements GIISIntmSpecialRateService{

	private GIISIntmSpecialRateDAO giisIntmSpecialRateDAO;

	public GIISIntmSpecialRateDAO getGiisIntmSpecialRateDAO() {
		return giisIntmSpecialRateDAO;
	}

	public void setGiisIntmSpecialRateDAO(GIISIntmSpecialRateDAO giisIntmSpecialRateDAO) {
		this.giisIntmSpecialRateDAO = giisIntmSpecialRateDAO;
	}

	@Override
	public JSONObject showGIISS082(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS082RecList");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public JSONObject showHistory(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS082History");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void populatePerils(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("userId", userId);
		
		this.getGiisIntmSpecialRateDAO().populatePerils(params);
	}

	@Override
	public void copyIntmRate(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNoTo", request.getParameter("intmNoTo"));
		params.put("intmNoFrom", request.getParameter("intmNoFrom"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("userId", userId);
		
		this.getGiisIntmSpecialRateDAO().copyIntmRate(params);
	}

	@Override
	public void saveGIISS082(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISIntmSpecialRate.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISIntmSpecialRate.class));
		params.put("appUser", userId);
		
		this.getGiisIntmSpecialRateDAO().saveGIISS082(params);
	}

	@Override
	public String getPerilList(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		return this.getGiisIntmSpecialRateDAO().getPerilList(params);
	}
	
}
