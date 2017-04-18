package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.fire.entity.GIISFIItemType;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISFiItemTypeDAO;
import com.geniisys.giis.service.GIISFiItemTypeService;

public class GIISFiItemTypeServiceImpl implements GIISFiItemTypeService{
	
	private GIISFiItemTypeDAO giisFiItemTypeDAO;
	
	public GIISFiItemTypeDAO getGissFiItemTypeDAO() {
		return giisFiItemTypeDAO;
	}

	public void setGiisFiItemTypeDAO(GIISFiItemTypeDAO giisFiItemTypeDAO) {
		this.giisFiItemTypeDAO = giisFiItemTypeDAO;
	}

	@Override
	public JSONObject getGiiss012FiItemType(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss012FiItemType");		
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(map);	
	}

	@Override
	public void giiss012ValAddRec(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("frItemType") != null){
			String frItemType = request.getParameter("frItemType");
			this.giisFiItemTypeDAO.giiss012ValAddRec(frItemType);
		}
	}
	@Override
	public void giiss012ValDelRec(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("frItemType") != null){
			String frItemType = request.getParameter("frItemType");
			this.giisFiItemTypeDAO.giiss012ValDelRec(frItemType);
		}
	}

	@Override
	public void saveGiiss012(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("Service - saveGiiss012");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISFIItemType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISFIItemType.class));
		params.put("appUser", userId);
		this.giisFiItemTypeDAO.saveGiiss012(params);
	}

}
