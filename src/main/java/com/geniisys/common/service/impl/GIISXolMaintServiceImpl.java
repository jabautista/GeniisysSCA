package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISXolMaintDAO;
import com.geniisys.common.entity.GIISXol;
import com.geniisys.common.service.GIISXolMaintService;
import com.geniisys.framework.util.JSONUtil;

public class GIISXolMaintServiceImpl implements GIISXolMaintService{
	
	private GIISXolMaintDAO giisXolMaintDAO;

	public GIISXolMaintDAO getGiisXolMaintDAO() {
		return giisXolMaintDAO;
	}

	public void setGiisXolMaintDAO(GIISXolMaintDAO giisXolMaintDAO) {
		this.giisXolMaintDAO = giisXolMaintDAO;
	}
	
	@Override
	public String saveXol(String strParams, Map<String, Object> params) throws JSONException, SQLException {
		
		JSONObject objParameters = new JSONObject(strParams);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")),(String)params.get("appUser"), GIISXol.class));
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")),(String)params.get("appUser"), GIISXol.class));
		allParams.put("lineCd", (String)params.get("lineCd"));
		allParams.put("userId", (String)params.get("appUser"));
		return this.getGiisXolMaintDAO().saveXol(allParams);	
	}
	
	public String validateAddXol(Map<String, Object> params) throws JSONException, SQLException {
		return this.getGiisXolMaintDAO().validateAddXol(params);
	}
	
	public String validateUpdateXol(Map<String, Object> params) throws JSONException, SQLException {
		return this.getGiisXolMaintDAO().validateUpdateXol(params);
	}
	
	public String validateDeleteXol(Map<String, Object> params) throws JSONException, SQLException {
		return this.getGiisXolMaintDAO().validateDeleteXol(params);
	}
}
