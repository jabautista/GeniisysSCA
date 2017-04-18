package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISMCEngineSeries;
import com.geniisys.common.entity.GIISMCMake;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISMcMakeDAO;
import com.geniisys.giis.service.GIISMcMakeService;

public class GIISMcMakeServiceImpl implements GIISMcMakeService{

	private GIISMcMakeDAO giisMcMakeDAO;

	public GIISMcMakeDAO getGiisMcMakeDAO() {
		return giisMcMakeDAO;
	}

	public void setGiisMcMakeDAO(GIISMcMakeDAO giisMcMakeDAO) {
		this.giisMcMakeDAO = giisMcMakeDAO;
	}

	@Override
	public JSONObject showGIISS103(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS103RecList");
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void saveGIISS103(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISMCMake.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISMCMake.class));
		params.put("appUser", userId);
		this.getGiisMcMakeDAO().saveGIISS103(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("make", request.getParameter("make"));
		params.put("sublineCd", request.getParameter("sublineCd")); // andrew - 08052015 - SR 19241
		params.put("noOfPass", request.getParameter("noOfPass"));// andrew - 08052015 - SR 19241
		params.put("carCompanyCd", request.getParameter("carCompanyCd"));
		params.put("action", request.getParameter("valAction"));// andrew - 08052015 - SR 19241
		this.getGiisMcMakeDAO().valAddRec(params);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("carCompanyCd", request.getParameter("carCompanyCd"));
		this.getGiisMcMakeDAO().valDeleteRec(params);
	}

	@Override
	public JSONObject showEngineSeries(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS103EngineList");
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("carCompanyCd", request.getParameter("carCompanyCd"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void saveGIISS103Engine(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISMCEngineSeries.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISMCEngineSeries.class));
		params.put("appUser", userId);
		this.getGiisMcMakeDAO().saveGIISS103Engine(params);
	}

	@Override
	public void valAddEngine(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("carCompanyCd", request.getParameter("carCompanyCd"));
		params.put("seriesCd", request.getParameter("seriesCd"));
		params.put("engineSeries", request.getParameter("engineSeries"));
		params.put("action", request.getParameter("valAction"));
		this.getGiisMcMakeDAO().valAddEngine(params);
	}

	@Override
	public void valDeleteEngine(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("makeCd", request.getParameter("makeCd"));
		params.put("carCompanyCd", request.getParameter("carCompanyCd"));
		params.put("seriesCd", request.getParameter("seriesCd"));
		this.getGiisMcMakeDAO().valDeleteEngine(params);
	}
	
}
