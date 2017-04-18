package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISSlidCommDAO;
import com.geniisys.giis.entity.GIISSlidComm;
import com.geniisys.giis.service.GIISSlidCommService;
import com.seer.framework.util.StringFormatter;

public class GIISSlidCommServiceImpl implements GIISSlidCommService{

	private GIISSlidCommDAO giisSlidCommDAO;

	public GIISSlidCommDAO getGiisSlidCommDAO() {
		return giisSlidCommDAO;
	}

	public void setGiisSlidCommDAO(GIISSlidCommDAO giisSlidCommDAO) {
		this.giisSlidCommDAO = giisSlidCommDAO;
	}

	@Override
	public JSONObject getPerils(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS220PerilList");
		params.put("lineCd", request.getParameter("lineCd"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public JSONObject getSlidingComm(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS220SlidingComm");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public JSONObject getHistory(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS220History");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void checkRate(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("loPremLim", request.getParameter("loPremLim"));
		params.put("hiPremLim", request.getParameter("hiPremLim"));
		params.put("oldLoPremLim", request.getParameter("oldLoPremLim"));
		params.put("oldHiPremLim", request.getParameter("oldHiPremLim"));
		this.getGiisSlidCommDAO().checkRate(params);
	}

	@Override
	public void saveGIISS220(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISSlidComm.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISSlidComm.class));
		params.put("appUser", userId);		
		this.getGiisSlidCommDAO().saveGIISS220(params);
	}

	@Override
	public List<Map<String, Object>> getRateList(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		return this.getGiisSlidCommDAO().getRateList(params);
	}
	
}
