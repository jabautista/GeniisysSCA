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
import com.geniisys.giis.dao.GIISDefaultDistDAO;
import com.geniisys.giis.entity.GIISDefaultDist;
import com.geniisys.giis.entity.GIISDefaultDistPeril;
import com.geniisys.giis.service.GIISDefaultDistService;
import com.seer.framework.util.StringFormatter;

public class GIISDefaultDistServiceImpl implements GIISDefaultDistService{

	private GIISDefaultDistDAO giisDefaultDistDAO;

	public GIISDefaultDistDAO getGiisDefaultDistDAO() {
		return giisDefaultDistDAO;
	}

	public void setGiisDefaultDistDAO(GIISDefaultDistDAO giisDefaultDistDAO) {
		this.giisDefaultDistDAO = giisDefaultDistDAO;
	}

	@Override
	public JSONObject getDefaultDistList(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDefaultDistList");
		params.put("userId", userId);
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public JSONObject getDefaultDistDtlList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDefaultDistDtlList");
		params.put("defaultNo", request.getParameter("defaultNo"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public JSONObject getPerilList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss165PerilList");
		params.put("lineCd", request.getParameter("lineCd"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public JSONObject getDefaultDistPerilList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDefaultDistPerilList");
		params.put("defaultNo", request.getParameter("defaultNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void saveGiiss165(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISDefaultDist.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISDefaultDist.class));		
		params.put("setPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setPerilRows")), userId, GIISDefaultDistPeril.class));
		params.put("delPerilRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delPerilRows")), userId, GIISDefaultDistPeril.class));
		params.put("appUser", userId);
		
		this.getGiisDefaultDistDAO().saveGiiss165(params);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		this.getGiisDefaultDistDAO().valDeleteRec(Integer.parseInt(request.getParameter("defaultNo")));
	}

	@Override
	public void checkDistRecords(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("defaultNo", request.getParameter("defaultNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		
		this.getGiisDefaultDistDAO().checkDistRecords(params);
	}

	@Override
	public Map<String, Object> getDistPerilVariables(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("defaultNo", request.getParameter("defaultNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		
		return this.getGiisDefaultDistDAO().getDistPerilVariables(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("defaultNo", request.getParameter("defaultNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		
		this.getGiisDefaultDistDAO().valAddRec(params);
	}
	
}
