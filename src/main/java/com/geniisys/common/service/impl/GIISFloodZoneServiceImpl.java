package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISFloodZoneDAO;
import com.geniisys.common.entity.GIISFloodZone;
import com.geniisys.common.service.GIISFloodZoneService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISFloodZoneServiceImpl implements GIISFloodZoneService {
	
	private GIISFloodZoneDAO giisFloodZoneDAO;

	public GIISFloodZoneDAO getGiisFloodZoneDAO() {
		return giisFloodZoneDAO;
	}

	public void setGiisFloodZoneDAO(GIISFloodZoneDAO giisFloodZoneDAO) {
		this.giisFloodZoneDAO = giisFloodZoneDAO;
	}

	@Override
	public JSONObject showGiiss053(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss053RecList");	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("floodZone") != null){
			String recId = request.getParameter("floodZone");
			this.giisFloodZoneDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss053(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISFloodZone.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISFloodZone.class));
		params.put("appUser", userId);
		this.giisFloodZoneDAO.saveGiiss053(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("floodZone", (request.getParameter("floodZone") != null && !request.getParameter("floodZone").equals("")) ? request.getParameter("floodZone") : null);
		params.put("floodZoneDesc", request.getParameter("floodZoneDesc"));
		this.giisFloodZoneDAO.valAddRec(params);
	}

}
