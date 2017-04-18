package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


import com.geniisys.common.dao.GIISPerilGroupDAO;
import com.geniisys.common.entity.GIISPerilGroup;
import com.geniisys.common.entity.GIISPerilGroupDtl;
import com.geniisys.common.service.GIISPerilGroupService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISPerilGroupServiceImpl implements GIISPerilGroupService{
	
	private GIISPerilGroupDAO giisPerilGroupDAO;

	public void setGiisPerilGroupDAO(GIISPerilGroupDAO giisPerilGroupDAO) {
		this.giisPerilGroupDAO = giisPerilGroupDAO;
	}

	public GIISPerilGroupDAO getGiisPerilGroupDAO() {
		return giisPerilGroupDAO;
	}
	
	@Override
	public JSONObject showGiiss213(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss213RecList");
		params.put("lineCd", request.getParameter("lineCd"));		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void saveGiiss213(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISPerilGroup.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISPerilGroup.class));
		params.put("appUser", userId);
		this.giisPerilGroupDAO.saveGiiss213(params);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilGrpCd", request.getParameter("perilGrpCd"));
		this.giisPerilGroupDAO.valDeleteRec(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilGrpCd", request.getParameter("perilGrpCd"));
		this.giisPerilGroupDAO.valAddRec(params);
	}

	@Override
	public JSONObject showGiiss213PerilList(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss213PerilRecList");
		params.put("lineCd", request.getParameter("lineCd"));	
		params.put("perilGrpCd", request.getParameter("perilGrpCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void saveGiiss213Dtl(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISPerilGroupDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISPerilGroupDtl.class));
		params.put("appUser", userId);
		this.giisPerilGroupDAO.saveGiiss213Dtl(params);
		
	}
}
