package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISRequiredDocDAO;
import com.geniisys.giis.entity.GIISRequiredDoc;
import com.geniisys.giis.service.GIISRequiredDocService;
import com.seer.framework.util.StringFormatter;

public class GIISRequiredDocServiceImpl implements GIISRequiredDocService{

	private GIISRequiredDocDAO giisRequiredDocDAO;
	
	public GIISRequiredDocDAO getGiisRequiredDocDAO() {
		return giisRequiredDocDAO;
	}

	public void setGiisRequiredDocDAO(GIISRequiredDocDAO giisRequiredDocDAO) {
		this.giisRequiredDocDAO = giisRequiredDocDAO;
	}

	@Override
	public void saveGIISRequiredDoc(HttpServletRequest request, String userId) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		/*params.put("setRequiredDoc", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISRequiredDoc.class));
		params.put("delRequiredDoc", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISRequiredDoc.class));*/
		
		// added by Kris 05.23.2013
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		params.put("setRequiredDoc", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISRequiredDoc.class));
		params.put("delRequiredDoc", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISRequiredDoc.class));
		
		this.giisRequiredDocDAO.saveGIISRequiredDoc(params);
	}

	@Override
	public List<String> getCurrenDocCdList(Map<String, Object> params) throws SQLException {
		return this.getGiisRequiredDocDAO().getCurrenDocCdList(params);
	}
	
	@Override
	public JSONObject showGiiss035(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss035RecList");	
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("docCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("docCd", request.getParameter("docCd"));
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("sublineCd", request.getParameter("sublineCd"));
			return this.giisRequiredDocDAO.valDeleteRec(params);
		} else {
			return null;
		}
		
	}

	@Override
	public void saveGiiss035(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISRequiredDoc.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISRequiredDoc.class));
		params.put("appUser", userId);
		this.giisRequiredDocDAO.saveGiiss035(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("docCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("docCd", request.getParameter("docCd"));
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("sublineCd", request.getParameter("sublineCd"));
			this.giisRequiredDocDAO.valAddRec(params);
		}
	}
	
	@Override
	public Map<String, Object> validateGiiss035Line(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", userId);
		return this.giisRequiredDocDAO.validateGiiss035Line(params);
	}
	
	@Override
	public Map<String, Object> validateGiiss035Subline(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		return this.giisRequiredDocDAO.validateGiiss035Subline(params);
	}
	
}
