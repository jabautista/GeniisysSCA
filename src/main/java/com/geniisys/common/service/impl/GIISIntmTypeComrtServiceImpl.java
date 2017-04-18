package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISIntmTypeComrtDAO;
import com.geniisys.common.entity.GIISIntmTypeComrt;
import com.geniisys.common.service.GIISIntmTypeComrtService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISIntmTypeComrtServiceImpl implements GIISIntmTypeComrtService{
	
	private GIISIntmTypeComrtDAO giisIntmTypeComrtDAO;

	public GIISIntmTypeComrtDAO getGiisIntmTypeComrtDAO() {
		return giisIntmTypeComrtDAO;
	}

	public void setGiisIntmTypeComrtDAO(GIISIntmTypeComrtDAO giisIntmTypeComrtDAO) {
		this.giisIntmTypeComrtDAO = giisIntmTypeComrtDAO;
	}

	@Override
	public JSONObject showGiiss084(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss084RecList");
		params.put("issCd", request.getParameter("issCd"));
		params.put("coIntmType", request.getParameter("coIntmType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void saveGiiss084(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISIntmTypeComrt.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISIntmTypeComrt.class));
		params.put("appUser", userId);
		System.out.println("Co-Intm Type Comm Rate save parameters : " + params);
		this.giisIntmTypeComrtDAO.saveGiiss084(params);
	}

	@Override
	public JSONObject showGiiss084History(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss084HistoryRecList");
		params.put("issCd", request.getParameter("issCd"));
		params.put("coIntmType", request.getParameter("coIntmType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valAddRec(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss084HistoryRecList");
		params.put("issCd", request.getParameter("issCd"));
		params.put("coIntmType", request.getParameter("coIntmType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		this.getGiisIntmTypeComrtDAO().valAddRec(params);
	}
	
}
