package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISSectionOrHazardDAO;
import com.geniisys.common.entity.GIISSectionOrHazard;
import com.geniisys.common.service.GIISSectionOrHazardService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISSectionOrHazardServiceImpl implements GIISSectionOrHazardService{
	private GIISSectionOrHazardDAO giisSectionOrHazardDAO;
	
	public GIISSectionOrHazardDAO getGiisSectionOrHazardDAO() {
		return giisSectionOrHazardDAO;
	}

	public void setGiisSectionOrHazardDAO(GIISSectionOrHazardDAO giisSectionOrHazardDAO) {
		this.giisSectionOrHazardDAO = giisSectionOrHazardDAO;
	}
	
	@Override
	public JSONObject showGiiss020(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss020RecList");
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		params.put("fromMenu", request.getParameter("fromMenu"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}	

	@Override
	public void saveGiiss020(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISSectionOrHazard.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISSectionOrHazard.class));
		params.put("appUser", userId);
		this.giisSectionOrHazardDAO.saveGiiss020(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("sectionOrHazardCd", request.getParameter("sectionOrHazardCd"));
		this.giisSectionOrHazardDAO.valAddRec(params);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("sectionOrHazardCd", request.getParameter("sectionOrHazardCd"));
		this.giisSectionOrHazardDAO.valDeleteRec(params);
	}
}
