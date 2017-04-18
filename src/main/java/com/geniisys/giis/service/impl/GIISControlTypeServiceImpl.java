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
import com.geniisys.giis.dao.GIISControlTypeDAO;
import com.geniisys.giis.entity.GIISControlType;
import com.geniisys.giis.service.GIISControlTypeService;

public class GIISControlTypeServiceImpl implements GIISControlTypeService{

	private GIISControlTypeDAO giisControlTypeDAO;

	public GIISControlTypeDAO getGiisControlTypeDAO() {
		return giisControlTypeDAO;
	}

	public void setGiisControlTypeDAO(GIISControlTypeDAO giisControlTypeDAO) {
		this.giisControlTypeDAO = giisControlTypeDAO;
	}

	@Override
	public JSONObject showGIISS108(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss108RecList");
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void saveGIISS108(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISControlType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISControlType.class));
		params.put("appUser", userId);
		this.getGiisControlTypeDAO().saveGIISS108(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("oldValue", request.getParameter("oldValue"));
		params.put("controlTypeDesc", request.getParameter("controlTypeDesc"));
		this.getGiisControlTypeDAO().valAddRec(params);
	}

	@Override
	public void valDelRec(HttpServletRequest request) throws SQLException {
		this.getGiisControlTypeDAO().valDelRec(request.getParameter("controlTypeCd"));
	}

	@Override
	public JSONObject getAllRecList(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss108AllRecList");
		params.put("pageSize", 100);
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
}
