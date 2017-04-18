package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISTariff;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISTariffDAO;
import com.geniisys.giis.service.GIISTariffService;

public class GIISTariffServiceImpl implements GIISTariffService{

	private GIISTariffDAO giisTariffDAO;
	
	public GIISTariffDAO getGiisTariffDAO() {
		return giisTariffDAO;
	}
	
	public void setGiisTariffDAO(GIISTariffDAO giisTariffDAO) {
		this.giisTariffDAO = giisTariffDAO;
	}

	@Override
	public JSONObject showGIISS005(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS005RecList");
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void saveGIISS005(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTariff.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTariff.class));
		params.put("appUser", userId);
		this.getGiisTariffDAO().saveGIISS005(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		this.getGiisTariffDAO().valAddRec(request.getParameter("tariffCd"));
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		this.getGiisTariffDAO().valDeleteRec(request.getParameter("tariffCd"));
	}
	
}
