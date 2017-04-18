package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISMCSublineType;
import com.geniisys.common.entity.GIISMCSublineType;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISMCSublineTypeDAO;
import com.geniisys.giis.service.GIISMCSublineTypeService;

public class GIISMCSublineTypeServiceImpl implements GIISMCSublineTypeService{
	
	private GIISMCSublineTypeDAO giisMCSublineTypeDAO;
	
	public GIISMCSublineTypeDAO getGissMCSublineTypeDAO() {
		return giisMCSublineTypeDAO;
	}

	public void setGiisMCSublineTypeDAO(GIISMCSublineTypeDAO giisMCSublineTypeDAO) {
		this.giisMCSublineTypeDAO = giisMCSublineTypeDAO;
	}

	@Override
	public JSONObject showGiiss056(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss056MCSublineType");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}

	@Override
	public void giiss056ValAddRec(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "giiss056ValSublineTypeCd");
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("oldSublineTypeCd", request.getParameter("oldSublineTypeCd"));
		params.put("newSublineTypeCd", request.getParameter("newSublineTypeCd"));
		params.put("oldSublineTypeDesc", request.getParameter("oldSublineTypeDesc"));
		params.put("newSublineTypeDesc", request.getParameter("newSublineTypeDesc"));
		params.put("pAction", request.getParameter("pAction"));
		System.out.println(params);
		this.giisMCSublineTypeDAO.giiss056ValAddRec(params);
	}

	@Override
	public void saveGiiss056(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("Service - saveGiiss056");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISMCSublineType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISMCSublineType.class));
		params.put("appUser", userId);
		this.giisMCSublineTypeDAO.saveGiiss056(params);
	}

	@Override
	public void giiss056ValDelRec(HttpServletRequest request)
			throws SQLException {
		String sublineTypeCd = request.getParameter("sublineTypeCd");
		this.giisMCSublineTypeDAO.giiss056ValDelRec(sublineTypeCd);		
	}

}
