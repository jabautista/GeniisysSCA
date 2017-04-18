package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISCollateralTypeDAO;
import com.geniisys.common.entity.GIISCollateralType;
import com.geniisys.common.service.GIISCollateralTypeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISCollateralTypeServiceImpl implements GIISCollateralTypeService{
	
	private GIISCollateralTypeDAO giisCollateralTypeDAO;
	

	public GIISCollateralTypeDAO getGiisCollateralTypeDAO() {
		return giisCollateralTypeDAO;
	}

	public void setGiisCollateralTypeDAO(GIISCollateralTypeDAO giisCollateralTypeDAO) {
		this.giisCollateralTypeDAO = giisCollateralTypeDAO;
	}

	@Override
	public JSONObject showGiiss102(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss102RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("collType") != null){
			String recId = request.getParameter("collType");
			this.giisCollateralTypeDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss102(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISCollateralType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISCollateralType.class));
		params.put("appUser", userId);
		this.giisCollateralTypeDAO.saveGiiss102(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("collType") != null){
			String recId = request.getParameter("collType");
			this.giisCollateralTypeDAO.valAddRec(recId);
		}
	}

}
