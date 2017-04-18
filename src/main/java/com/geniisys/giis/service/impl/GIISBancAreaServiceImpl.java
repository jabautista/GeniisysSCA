package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISBancArea;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISBancAreaDAO;
import com.geniisys.giis.service.GIISBancAreaService;

public class GIISBancAreaServiceImpl implements GIISBancAreaService{
	
	private GIISBancAreaDAO giisBancAreaDAO;
	
	public GIISBancAreaDAO getGissBancAreaDAO() {
		return giisBancAreaDAO;
	}

	public void setGiisBancAreaDAO(GIISBancAreaDAO giisBancAreaDAO) {
		this.giisBancAreaDAO = giisBancAreaDAO;
	}

	@Override
	public JSONObject showGiiss215(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss215RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void saveGiiss215(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISBancArea.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISBancArea.class));
		params.put("appUser", userId);
		this.giisBancAreaDAO.saveGiiss215(params);
	}

	@Override
	public void giiss215ValAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("areaCd", request.getParameter("areaCd"));
		params.put("areaDesc", request.getParameter("areaDesc"));
		this.giisBancAreaDAO.giiss215ValAddRec(params);
	}

	@Override
	public JSONObject showGiiss215Hist(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss215Hist");
		params.put("areaCd", request.getParameter("areaCd"));
		params.put("pageSize", 5);
		Map<String, Object> histList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(histList);
	}
	
	

}
