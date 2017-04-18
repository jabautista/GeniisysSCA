package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giis.dao.GIISIntreatyDAO;
import com.geniisys.giis.entity.GIISIntreaty;
import com.geniisys.giis.service.GIISIntreatyService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISIntreatyServiceImpl implements GIISIntreatyService{
	private GIISIntreatyDAO giisIntreatyDAO;

	public GIISIntreatyDAO getGiisIntreatyDAO() {
		return giisIntreatyDAO;
	}

	public void setGiisIntreatyDAO(GIISIntreatyDAO giisIntreatyDAO) {
		this.giisIntreatyDAO = giisIntreatyDAO;
	}

	@Override
	public JSONObject showGiiss032(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss032RecList");
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("trtyYy") != null 
		&& request.getParameter("trtySeqNo") != null && request.getParameter("riCd") != null ){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("trtyYy", request.getParameter("trtyYy"));
			params.put("trtySeqNo", request.getParameter("trtySeqNo"));
			params.put("riCd", request.getParameter("riCd"));
			this.giisIntreatyDAO.valAddRec(params);
		}
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("trtyYy") != null 
		&& request.getParameter("trtySeqNo") != null && request.getParameter("riCd") != null ){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("trtyYy", request.getParameter("trtyYy"));
			params.put("trtySeqNo", request.getParameter("trtySeqNo"));
			params.put("riCd", request.getParameter("riCd"));
			this.giisIntreatyDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGiiss032(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISIntreaty.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISIntreaty.class));
		params.put("appUser", userId);
		System.out.println("Intreaty save parameters ::::::::::::::::: " + params);
		this.giisIntreatyDAO.saveGiiss032(params);
	}
}
