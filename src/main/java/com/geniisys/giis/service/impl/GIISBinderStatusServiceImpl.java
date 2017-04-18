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
import com.geniisys.giis.dao.GIISBinderStatusDAO;
import com.geniisys.giis.entity.GIISBinderStatus;
import com.geniisys.giis.service.GIISBinderStatusService;

public class GIISBinderStatusServiceImpl implements GIISBinderStatusService{
	
	private GIISBinderStatusDAO giisBinderStatusDAO;

	public GIISBinderStatusDAO getGiisBinderStatusDAO() {
		return giisBinderStatusDAO;
	}

	public void setGiisBinderStatusDAO(GIISBinderStatusDAO giisBinderStatusDAO) {
		this.giisBinderStatusDAO = giisBinderStatusDAO;
	}

	@Override
	public JSONObject showGiiss209(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiisBinderStatusList");
		
		Map<String, Object> giisBinderStatusList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(giisBinderStatusList);
	}

	@Override
	public void saveGiiss209(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISBinderStatus.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISBinderStatus.class));
		params.put("appUser", userId);
		this.giisBinderStatusDAO.saveGiiss209(params);
		
	}

	@Override
	public void valAddBinderStatus(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("bndrStatCd") != null || request.getParameter("bndrStatDesc") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("bndrStatCd", request.getParameter("bndrStatCd"));
			params.put("bndrStatDesc", request.getParameter("bndrStatDesc"));
			this.giisBinderStatusDAO.valAddBinderStatus(params);
		}
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("bndrStatCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("bndrStatCd", request.getParameter("bndrStatCd"));
			this.giisBinderStatusDAO.valDeleteRec(params);
		}
	}
	
}
