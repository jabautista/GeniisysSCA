package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLMcLpsService;
import com.geniisys.gicl.dao.GICLMcLpsDAO;
import com.geniisys.gicl.entity.GICLMcLps;

public class GICLMcLpsServiceImpl implements GICLMcLpsService{
	
	private GICLMcLpsDAO giclMcLpsDAO;
	
	public GICLMcLpsDAO getGiclMcLpsDAO() {
		return giclMcLpsDAO;
	}

	public void setGiclMcLpsDAO(GICLMcLpsDAO giclMcLpsDAO) {
		this.giclMcLpsDAO = giclMcLpsDAO;
	}

	@Override
	public JSONObject showGicls171(HttpServletRequest request)
			throws SQLException, JSONException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls171RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void saveGicls171(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLMcLps.class));
		params.put("appUser", userId);
		giclMcLpsDAO.saveGicls171(params);
	}

	@Override
	public JSONObject getGicls171LpsHistory(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls171LpsHist");
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		params.put("pageSize", 5);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
}
