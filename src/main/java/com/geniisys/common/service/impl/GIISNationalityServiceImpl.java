package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISNationalityDAO;
import com.geniisys.common.entity.GIISNationality;
import com.geniisys.common.service.GIISNationalityService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISNationalityServiceImpl implements GIISNationalityService {
	
	private GIISNationalityDAO giisNationalityDAO;

	@Override
	public JSONObject showGicls184(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls184RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("nationalityCd") != null){
			String recId = request.getParameter("nationalityCd");
			this.giisNationalityDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGicls184(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISNationality.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISNationality.class));
		params.put("appUser", userId);
		this.giisNationalityDAO.saveGicls184(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("nationalityCd") != null){
			String recId = request.getParameter("nationalityCd");
			this.giisNationalityDAO.valAddRec(recId);
		}
	}

	public GIISNationalityDAO getGiisNationalityDAO() {
		return giisNationalityDAO;
	}

	public void setGiisNationalityDAO(GIISNationalityDAO giisNationalityDAO) {
		this.giisNationalityDAO = giisNationalityDAO;
	}

	

}
