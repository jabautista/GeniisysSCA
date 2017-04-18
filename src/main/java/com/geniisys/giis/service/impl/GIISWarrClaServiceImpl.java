package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISLine;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISWarrClaDAO;
import com.geniisys.giis.entity.GIISWarrCla;
import com.geniisys.giis.service.GIISWarrClaService;

public class GIISWarrClaServiceImpl implements GIISWarrClaService{

	private GIISWarrClaDAO giisWarrClaDAO;
	
	public GIISWarrClaDAO getGiisWarrClaDAO() {
		return giisWarrClaDAO;
	}
	public void setGiisWarrClaDAO(GIISWarrClaDAO giisWarrClaDAO) {
		this.giisWarrClaDAO = giisWarrClaDAO;
	}
	
	@Override
	public List<GIISLine> getGIISLine() throws SQLException {
		return giisWarrClaDAO.getGIISLine();
	}

	@Override
	public JSONObject getGIISWarrCla(HttpServletRequest request) throws SQLException, JSONException {
		HashMap<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getGIISWarrCla");
		params.put("lineCd", request.getParameter("lineCd"));
		Map<String, Object> warrCla = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(warrCla);
		request.setAttribute("warrCla", json);
		return json;
	}

	@Override
	public String validateDeleteWarrCla(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("mainWcCd", request.getParameter("mainWcCd"));
		params.put("wcSwDesc", request.getParameter("wcSwDesc"));
		return this.getGiisWarrClaDAO().validateDeleteWarrCla(params);
	}

	@Override
	public String validateAddWarrCla(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("mainWcCd", request.getParameter("mainWcCd"));
		return this.getGiisWarrClaDAO().validateAddWarrCla(params);
	}

	@Override
	public String saveWarrCla(HttpServletRequest request, String userId) throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISWarrCla.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISWarrCla.class));
		return this.getGiisWarrClaDAO().saveWarrCla(allParams);
	}
}
