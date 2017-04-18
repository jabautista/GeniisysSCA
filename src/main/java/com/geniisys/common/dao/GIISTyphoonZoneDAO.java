package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISTyphoonZoneDAO {
	JSONObject showTyphoonZoneMaintenance(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> validateTyphoonZoneInput (Map<String, Object> params) throws SQLException;
	Map<String, Object> validateDeleteTyphoonZone (Map<String, Object> params) throws SQLException;
	Map<String, Object> saveTyphoonZoneMaintenance(Map<String, Object> params) throws SQLException;
}