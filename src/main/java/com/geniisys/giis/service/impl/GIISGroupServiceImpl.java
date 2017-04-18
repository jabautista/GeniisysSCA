package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISGroup;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISGroupDAO;
import com.geniisys.giis.service.GIISGroupService;

public class GIISGroupServiceImpl implements GIISGroupService {
	
	private GIISGroupDAO giisGroupDAO;

	public JSONObject showGiiss118(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss118RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("groupCd") != null){
			String recId = request.getParameter("groupCd");
			this.giisGroupDAO.valDeleteRec(recId);
		}
	}

	public void saveGiiss118(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISGroup.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISGroup.class));
		params.put("appUser", userId);
		this.giisGroupDAO.saveGiiss118(params);
	}

	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("groupCd") != null){
			String recId = request.getParameter("groupCd");
			this.giisGroupDAO.valAddRec(recId);
		}
	}

	public GIISGroupDAO getGissGroupDAO() {
		return giisGroupDAO;
	}

	public void setGiisGroupDAO(GIISGroupDAO giisGroupDAO) {
		this.giisGroupDAO = giisGroupDAO;
	}
}
