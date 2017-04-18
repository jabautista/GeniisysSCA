package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISBondClassClauseDAO;
import com.geniisys.common.entity.GIISBondClassClause;
import com.geniisys.common.service.GIISBondClassClauseService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISBondClassClauseServiceImpl implements GIISBondClassClauseService {
	
	private GIISBondClassClauseDAO giisBondClassClauseDAO;

	@Override
	public JSONObject showGiiss099(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss099RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("clauseType") != null){
			String recId = request.getParameter("clauseType");
			this.giisBondClassClauseDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss099(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISBondClassClause.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISBondClassClause.class));
		params.put("appUser", userId);
		this.giisBondClassClauseDAO.saveGiiss099(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("clauseType") != null){
			String recId = request.getParameter("clauseType");
			this.giisBondClassClauseDAO.valAddRec(recId);
		}
	}

	public GIISBondClassClauseDAO getGiisBondClassClauseDAO() {
		return giisBondClassClauseDAO;
	}

	public void setGiisBondClassClauseDAO(
			GIISBondClassClauseDAO giisBondClassClauseDAO) {
		this.giisBondClassClauseDAO = giisBondClassClauseDAO;
	}

}
