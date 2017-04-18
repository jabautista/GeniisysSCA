package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISTyphoonZoneDAO;
import com.geniisys.common.entity.GIISTyphoonZone;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISTyphoonZoneService;
import com.geniisys.framework.util.JSONUtil;

public class GIISTyphoonZoneServiceImpl implements GIISTyphoonZoneService{

	private GIISTyphoonZoneDAO giisTyphoonZoneDAO;
	
	/**
	 * @return the giisTyphoonZoneDAO
	 */
	public GIISTyphoonZoneDAO getGiisTyphoonZoneDAO() {
		return giisTyphoonZoneDAO;
	}

	/**
	 * @param giisTyphoonZoneDAO the giisTyphoonZoneDAO to set
	 */
	public void setGiisTyphoonZoneDAO(GIISTyphoonZoneDAO giisTyphoonZoneDAO) {
		this.giisTyphoonZoneDAO = giisTyphoonZoneDAO;
	}
	@Override
	public JSONObject showTyphoonZoneMaintenance(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showTyphoonZoneMaintenance");	
		return this.giisTyphoonZoneDAO.showTyphoonZoneMaintenance(request, params); 
	}

	@Override
	public Map<String, Object> validateTyphoonZoneInput(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("txtField", request.getParameter("txtField"));
		params.put("inputString", request.getParameter("inputString"));	
		return this.giisTyphoonZoneDAO.validateTyphoonZoneInput(params);
	}
	
	@Override
	public Map<String, Object> validateDeleteTyphoonZone(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("typhoonZone", request.getParameter("typhoonZone"));		
		return this.giisTyphoonZoneDAO.validateDeleteTyphoonZone(params);
	}
	
	@Override
	public Map<String, Object> saveTyphoonZoneMaintenance(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GIISTyphoonZone.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GIISTyphoonZone.class));
		return this.giisTyphoonZoneDAO.saveTyphoonZoneMaintenance(params);
	}	
}
