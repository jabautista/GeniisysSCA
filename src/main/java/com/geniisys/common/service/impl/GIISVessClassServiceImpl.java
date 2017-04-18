package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISVessClassDAO;
import com.geniisys.common.entity.GIISVessClass;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISVessClassService;
import com.geniisys.framework.util.JSONUtil;

public class GIISVessClassServiceImpl implements GIISVessClassService {


	private GIISVessClassDAO giisVessClassDAO;
	
	/**
	 * @return the giisVessClassDAO
	 */
	public GIISVessClassDAO getGiisVessClassDAO() {
		return giisVessClassDAO;
	}

	/**
	 * @param giisVessClassDAO the giisVessClassDAO to set
	 */
	public void setGiisVessClassDAO(GIISVessClassDAO giisVessClassDAO) {
		this.giisVessClassDAO = giisVessClassDAO;
	}
		
	@Override
	public JSONObject showVesselClassification(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showVesselClassification");		
		return this.giisVessClassDAO.showVesselClassification(request, params); 
	}

	@Override
	public Map<String, Object> validateGIISS047VesselClass(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();			
		params.put("vessClassCd", request.getParameter("vessClassCd"));
		return this.giisVessClassDAO.validateGIISS047VesselClass(params);
	}

	@Override
	public Map<String, Object> saveVessClass(String parameter, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GIISVessClass.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GIISVessClass.class));
		return this.giisVessClassDAO.saveVessClass(params);
	}

	@Override
	public void valDelRec(HttpServletRequest request) throws SQLException {
		this.getGiisVessClassDAO().valDelRec(Integer.parseInt(request.getParameter("vessClassCd")));
	}	
}
