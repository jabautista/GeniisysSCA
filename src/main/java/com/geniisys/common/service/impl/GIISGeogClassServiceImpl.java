package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISGeogClassDAO;
import com.geniisys.common.dao.GIISLineSublineCoveragesDAO;
import com.geniisys.common.entity.GIISGeogClass;
import com.geniisys.common.entity.GIISLineSublineCoverages;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISGeogClassService;
import com.geniisys.framework.util.JSONUtil;

public class GIISGeogClassServiceImpl implements GIISGeogClassService{
	private GIISGeogClassDAO giisGeogClassDAO;
	
	/**
	 * @return the giisGeogClassDAO
	 */
	public GIISGeogClassDAO getGiisGeogClassDAO() {
		return giisGeogClassDAO;
	}

	/**
	 * @param giisGeogClassDAO the giisGeogClassDAO to set
	 */
	public void setGiisGeogClassDAO(GIISGeogClassDAO giisGeogClassDAO) {
		this.giisGeogClassDAO = giisGeogClassDAO;
	}
		
	@Override
	public JSONObject showGeographyClass(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showGeographyClass");		
		return this.giisGeogClassDAO.showGeographyClass(request, params); 
	}
	
	@Override
	public Map<String, Object> validateGeogCdInput(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("inputString", request.getParameter("inputString"));	
		return this.giisGeogClassDAO.validateGeogCdInput(params);
	}
	
	@Override
	public Map<String, Object> validateGeogDescInput(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("inputString", request.getParameter("inputString"));	
		return this.giisGeogClassDAO.validateGeogDescInput(params);
	}
	
	@Override
	public Map<String, Object> validateBeforeDelete(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();			
		params.put("geogCd", request.getParameter("geogCd"));	
		return this.giisGeogClassDAO.validateBeforeDelete(params);
	}	
	
	@Override
	public Map<String, Object> saveGeogClass(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GIISGeogClass.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GIISGeogClass.class));
		return this.giisGeogClassDAO.saveGeogClass(params);
	}	
}
