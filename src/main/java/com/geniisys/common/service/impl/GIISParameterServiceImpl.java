package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISParameterDAO;
import com.geniisys.common.entity.GIISParameter;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISParameterServiceImpl implements GIISParameterService{
	
	private GIISParameterDAO giisParameterDAO;
	
	@Override
	public Map<String, Object> getGiiss085Rec(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("paramName", request.getParameter("paramName"));		
		return this.getGiisParameterDAO().getGiiss085Rec(params);		 
	}
	
	@Override
	public void saveGiiss085(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("parameters", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("parameters")), userId, GIISParameter.class));
		params.put("appUser", userId);
		this.giisParameterDAO.saveGiiss085(params);
	}
	
	@Override
	public JSONObject getGisms011NumberList(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGisms011NumberList");	
		params.put("paramName", request.getParameter("paramName"));	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public void valAssdNameFormat(HttpServletRequest request) throws SQLException {	
		String assdNameFormat = request.getParameter("assdNameFormat");
		this.getGiisParameterDAO().valAssdNameFormat(assdNameFormat);		
	}
	
	@Override
	public void valIntmNameFormat(HttpServletRequest request) throws SQLException {	
		String intmNameFormat = request.getParameter("intmNameFormat");
		this.getGiisParameterDAO().valIntmNameFormat(intmNameFormat);		
	}
	
	@Override
	public void valGisms011AddRec(HttpServletRequest request) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("networkNumber", request.getParameter("networkNumber"));
		params.put("paramName", request.getParameter("paramName"));			
		this.getGiisParameterDAO().valGisms011AddRec(params);		
	}
	
	@Override
	public String getParamValueV2(String paramName)
			throws SQLException {
		return this.getGiisParameterDAO().getParamValueV2(paramName);
	}
	
	@Override
	public void saveGisms011(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("setRows"))));
		params.put("delRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("delRows"))));
		params.put("nameFormat", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("nameFormat"))));
		this.giisParameterDAO.saveGisms011(params);
	}
	
	public GIISParameterDAO getGiisParameterDAO() {
		return giisParameterDAO;
	}

	public void setGiisParameterDAO(GIISParameterDAO giisParameterDAO) {
		this.giisParameterDAO = giisParameterDAO;
	}

	@Override
	public JSONObject showGiiss061(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss061RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void saveGiiss061(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISParameter.class));
		params.put("appUser", userId);
		this.giisParameterDAO.saveGiiss061(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("parameterName", request.getParameter("parameterName"));
		this.giisParameterDAO.valAddRec(params);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("parameterName", request.getParameter("parameterName"));
		this.giisParameterDAO.valDeleteRec(params);
	}
}
