package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISTariffZoneService {
	Integer checkGiiss054UserAccess(String userId)throws SQLException;
	JSONObject showGiiss054(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss054(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
