package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISNotaryPublic;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISNotaryPublicDAO;
import com.geniisys.giis.service.GIISNotaryPublicService;

public class GIISNotaryPublicServiceImpl implements GIISNotaryPublicService{
	
private GIISNotaryPublicDAO giisNotaryPublicDAO;
	
	public GIISNotaryPublicDAO getGissNotaryPublicDAO() {
		return giisNotaryPublicDAO;
	}

	public void setGiisNotaryPublicDAO(GIISNotaryPublicDAO giisNotaryPublicDAO) {
		this.giisNotaryPublicDAO = giisNotaryPublicDAO;
	}

	@Override
	public JSONObject getGIISS016NotaryPublicList(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS016NotaryPublicList");		
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(map);
	}

	@Override
	public void saveGiiss016(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("Service - saveGiiss016");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISNotaryPublic.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISNotaryPublic.class));
		params.put("appUser", userId);
		this.giisNotaryPublicDAO.saveGiiss016(params);
	}

	@Override
	public void giiss016ValDelRec(HttpServletRequest request)
			throws SQLException {
		this.giisNotaryPublicDAO.giiss016ValDelRec(request.getParameter("npNo"));
	}

}
