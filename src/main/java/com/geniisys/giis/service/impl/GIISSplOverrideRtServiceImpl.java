package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISSplOverrideRt;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISSplOverrideRtDAO;
import com.geniisys.giis.service.GIISSplOverrideRtService;
import com.seer.framework.util.StringFormatter;

public class GIISSplOverrideRtServiceImpl implements GIISSplOverrideRtService {
	
private GIISSplOverrideRtDAO giisSplOverrideRtDAO;
	
	public GIISSplOverrideRtDAO getGissSplOverrideRtDAO() {
		return giisSplOverrideRtDAO;
	}

	public void setGiisSplOverrideRtDAO(GIISSplOverrideRtDAO giisSplOverrideRtDAO) {
		this.giisSplOverrideRtDAO = giisSplOverrideRtDAO;
	}

	@Override
	public JSONObject getGiiss202RecList(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss202RecList");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		//params.put("pageSize", 5);
		
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}

	@Override
	public String getGiiss202SelectedPerils(HttpServletRequest request)
			throws SQLException, Exception {
		
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		System.out.println(params);
		return giisSplOverrideRtDAO.getGiiss202SelectedPerils(params);
	}

	@Override
	public void saveGiiss202(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("Service - saveGiiss202");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISSplOverrideRt.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISSplOverrideRt.class));
		params.put("appUser", userId);
		this.giisSplOverrideRtDAO.saveGiiss202(params);		
	}

	@Override
	public void populateGiiss202(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>(); 
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("userId", userId);
		giisSplOverrideRtDAO.populateGiiss202(params);
	}

	@Override
	public void copyGiiss202(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNoFrom", request.getParameter("intmNoFrom"));
		params.put("issCdFrom", request.getParameter("issCdFrom"));
		params.put("intmNoTo", request.getParameter("intmNoTo"));
		params.put("issCdTo", request.getParameter("issCdTo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("userId", userId);
		System.out.println(params);
		giisSplOverrideRtDAO.copyGiiss202(params);
	}

	@Override
	public JSONObject getGiiss202History(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss202History");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("pageSize", 5);
		
		
		System.out.println(params);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}

}
