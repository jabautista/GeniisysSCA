package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giis.dao.GIISIndustryGroupDAO;
import com.geniisys.giis.service.GIISIndustryGroupService;
import com.geniisys.common.entity.GIISIndustryGroup;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISIndustryGroupServiceImpl implements GIISIndustryGroupService{
	private GIISIndustryGroupDAO giisIndustryGroupDAO;

	public GIISIndustryGroupDAO getGiisIndustryGroupDAO() {
		return giisIndustryGroupDAO;
	}

	public void setGiisIndustryGroupDAO(GIISIndustryGroupDAO giisIndustryGroupDAO) {
		this.giisIndustryGroupDAO = giisIndustryGroupDAO;
	}

	@Override
	public JSONObject showGiiss205(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss205RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("indGrpCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("indGrpCd", request.getParameter("indGrpCd"));
			params.put("indGrpNm", request.getParameter("indGrpNm"));
			this.giisIndustryGroupDAO.valAddRec(params);
		}
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("indGrpCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("indGrpCd", request.getParameter("indGrpCd"));
			this.giisIndustryGroupDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGiiss205(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISIndustryGroup.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISIndustryGroup.class));
		params.put("appUser", userId);
		this.giisIndustryGroupDAO.saveGiiss205(params);
	}
}
