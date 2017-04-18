package com.geniisys.common.service.impl;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISCoverageDAO;
import com.geniisys.common.entity.GIISCoverage;
import com.geniisys.common.service.GIISCoverageService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISCoverageServiceImpl implements GIISCoverageService{

	private GIISCoverageDAO giisCoverageDAO;

	public GIISCoverageDAO getGiisCoverageDAO() {
		return giisCoverageDAO;
	}

	public void setGiisCoverageDAO(GIISCoverageDAO giisCoverageDAO) {
		this.giisCoverageDAO = giisCoverageDAO;
	}
	
	@Override
	public JSONObject showGiiss113(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss113RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("coverageDesc") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("coverageDesc", request.getParameter("coverageDesc"));
			this.giisCoverageDAO.valAddRec(params);
		}
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("coverageCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("coverageCd", request.getParameter("coverageCd"));
			this.giisCoverageDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGiiss113(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISCoverage.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISCoverage.class));
		params.put("appUser", userId);
		System.out.println("Coverage save parameters : " + params);
		this.giisCoverageDAO.saveGiiss113(params);
	}

	@Override
	public JSONObject getAllCoverageDescList(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAllCoverageDescList");
		params.put("pageSize", 100);
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

}
