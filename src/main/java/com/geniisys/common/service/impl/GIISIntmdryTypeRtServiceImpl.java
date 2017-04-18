package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISIntmdryTypeRtDAO;
import com.geniisys.common.entity.GIISIntmdryTypeRt;
import com.geniisys.common.service.GIISIntmdryTypeRtService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISIntmdryTypeRtServiceImpl implements GIISIntmdryTypeRtService{

	private GIISIntmdryTypeRtDAO giisIntmdryTypeRtDAO;

	public GIISIntmdryTypeRtDAO getGiisIntmdryTypeRtDAO() {
		return giisIntmdryTypeRtDAO;
	}

	public void setGiisIntmdryTypeRtDAO(GIISIntmdryTypeRtDAO giisIntmdryTypeRtDAO) {
		this.giisIntmdryTypeRtDAO = giisIntmdryTypeRtDAO;
	}
	
	@Override
	public JSONObject showGiiss201(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss201RecList");
		params.put("issCd", request.getParameter("issCd"));
		params.put("intmType", request.getParameter("intmType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("intmType", request.getParameter("intmType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		this.getGiisIntmdryTypeRtDAO().valDeleteRec(params);
	}

	@Override
	public void saveGiiss201(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISIntmdryTypeRt.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISIntmdryTypeRt.class));
		params.put("appUser", userId);
		this.getGiisIntmdryTypeRtDAO().saveGiiss201(params);
	}
	
	@Override
	public JSONObject showGiiss201History(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss201HistList");
		params.put("issCd", request.getParameter("issCd"));
		params.put("intmType", request.getParameter("intmType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
}
