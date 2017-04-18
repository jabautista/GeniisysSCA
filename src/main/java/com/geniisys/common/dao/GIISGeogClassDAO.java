package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISGeogClassDAO {
	JSONObject showGeographyClass(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> validateGeogCdInput (Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGeogDescInput (Map<String, Object> params) throws SQLException;
	Map<String, Object> validateBeforeDelete (Map<String, Object> params) throws SQLException;
	Map<String, Object> saveGeogClass(Map<String, Object> params) throws SQLException;
}