package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISBancBranch;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISBancBranchDAO;
import com.geniisys.giis.service.GIISBancBranchService;

public class GIISBancBranchServiceImpl implements GIISBancBranchService{
	
private GIISBancBranchDAO giisBancBranchDAO;
	
	public GIISBancBranchDAO getGissBancBranchDAO() {
		return giisBancBranchDAO;
	}

	public void setGiisBancBranchDAO(GIISBancBranchDAO giisBancBranchDAO) {
		this.giisBancBranchDAO = giisBancBranchDAO;
	}

	@Override
	public JSONObject showGiiss216(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss216RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}

	@Override
	public void saveGiiss216(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("Service - saveGiiss216");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISBancBranch.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISBancBranch.class));
		params.put("appUser", userId);
		this.giisBancBranchDAO.saveGiiss216(params);
	}

	@Override
	public JSONObject showGiiss216Hist(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss216History");
		params.put("branchCd", request.getParameter("branchCd"));
		//params.put("pageSize", 5);
		Map<String, Object> histList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(histList);
	}

	@Override
	public void valAddRecGiiss216(HttpServletRequest request)
			throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("branchDesc", request.getParameter("branchDesc"));
		params.put("areaCd", request.getParameter("areaCd"));
		params.put("stat", request.getParameter("stat"));
		System.out.println(params);
		this.giisBancBranchDAO.valAddRecGiiss216(params);
	}

}
