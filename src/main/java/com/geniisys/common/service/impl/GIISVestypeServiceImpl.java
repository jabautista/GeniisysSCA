package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISVestypeDAO;
import com.geniisys.common.entity.GIISVestype;
import com.geniisys.common.service.GIISVestypeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;


public class GIISVestypeServiceImpl implements GIISVestypeService {
	
	private GIISVestypeDAO giisVestypeDAO;

	@Override
	public JSONObject showGiiss077(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss077RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("vestypeCd") != null){
			String recId = request.getParameter("vestypeCd");
			this.giisVestypeDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss077(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISVestype.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISVestype.class));
		params.put("appUser", userId);
		this.giisVestypeDAO.saveGiiss077(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("vestypeCd") != null){
			String recId = request.getParameter("vestypeCd");
			this.giisVestypeDAO.valAddRec(recId);
		}
	}

	public GIISVestypeDAO getGiisVestypeDAO() {
		return giisVestypeDAO;
	}

	public void setGiisVestypeDAO(GIISVestypeDAO giisVestypeDAO) {
		this.giisVestypeDAO = giisVestypeDAO;
	}
}
