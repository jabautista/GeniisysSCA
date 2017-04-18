package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISMCColorDAO;
import com.geniisys.common.entity.GIISMCColor;
import com.geniisys.common.service.GIISMCColorService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISMCColorServiceImpl implements GIISMCColorService{
	
	private GIISMCColorDAO giisMCColorDAO;
	
	@Override
	public JSONObject showGiiss114BasicColor(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss114BasicColorRecList");					
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public JSONObject showGiiss114(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss114RecList");		
		params.put("basicColorCd", request.getParameter("basicColorCd"));		
		Map<String, Object> recList = StringFormatter.escapeHTMLInMap(TableGridUtil.getTableGrid(request, params));		
		return new JSONObject(recList);
	}
	
	@Override
	public void valDeleteRecBasic(HttpServletRequest request) throws SQLException {
		if(request.getParameter("basicColorCd") != null){
			String recId = request.getParameter("basicColorCd");
			this.giisMCColorDAO.valDeleteRecBasic(recId);
		}
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("colorCd") != null){
			Integer recId = Integer.parseInt(request.getParameter("colorCd"));
			this.giisMCColorDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss114(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISMCColor.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISMCColor.class));
		params.put("updateRowsBasic", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("updateRowsBasic")), userId, GIISMCColor.class));
		params.put("delRowsBasic", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRowsBasic")), userId, GIISMCColor.class));
		params.put("appUser", userId);
		this.giisMCColorDAO.saveGiiss114(params);
	}
	
	@Override
	public void valAddRecBasic(HttpServletRequest request) throws SQLException {
		if(request.getParameter("basicColorCd") != null || request.getParameter("basicColor") != null ){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("basicColorCd", request.getParameter("basicColorCd"));
			params.put("basicColor", request.getParameter("basicColor"));
			params.put("action", request.getParameter("valAction")); // andrew - 08052015 - SR 19241
			this.giisMCColorDAO.valAddRecBasic(params);
		}
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("color") != null && request.getParameter("basicColorCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("basicColorCd", request.getParameter("basicColorCd"));
			params.put("colorCd", request.getParameter("colorCd")); // andrew - 08052015 - SR 19241
			params.put("color", request.getParameter("color"));
			params.put("action", request.getParameter("valAction")); // andrew - 08052015 - SR 19241
			this.giisMCColorDAO.valAddRec(params);
		}
	}

	public GIISMCColorDAO getGiisMCColorDAO() {
		return giisMCColorDAO;
	}

	public void setGiisMCColorDAO(GIISMCColorDAO giisMCColorDAO) {
		this.giisMCColorDAO = giisMCColorDAO;
	}
}
