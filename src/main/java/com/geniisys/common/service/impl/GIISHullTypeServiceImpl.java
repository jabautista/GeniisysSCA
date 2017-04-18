package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISHullTypeDAO;
import com.geniisys.common.entity.GIISHullType;
import com.geniisys.common.service.GIISHullTypeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISHullTypeServiceImpl implements GIISHullTypeService{
	
	private GIISHullTypeDAO giisHullTypeDAO;

	public void setGiisHullTypeDAO(GIISHullTypeDAO giisHullTypeDAO) {
		this.giisHullTypeDAO = giisHullTypeDAO;
	}

	public GIISHullTypeDAO getGiisHullTypeDAO() {
		return giisHullTypeDAO;
	}

	@Override
	public JSONObject showGiiss046(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss046RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("hullTypeCd") != null){
			Integer recId = Integer.parseInt(request.getParameter("hullTypeCd"));
			this.giisHullTypeDAO.valDeleteRec(recId);
		}
		
	}

	@Override
	public void saveGiiss046(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISHullType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISHullType.class));
		params.put("appUser", userId);
		System.out.println("DAOOOO" + params);
		this.giisHullTypeDAO.saveGiiss046(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("hullTypeCd") != null){
			Integer recId = Integer.parseInt(request.getParameter("hullTypeCd"));
			this.giisHullTypeDAO.valAddRec(recId);
		}
	}
	
	
	
}
