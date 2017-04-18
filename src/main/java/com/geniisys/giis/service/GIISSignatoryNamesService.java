package com.geniisys.giis.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;


public interface GIISSignatoryNamesService {
	
	JSONObject showGiiss071(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss071(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valUpdateRec(HttpServletRequest request) throws SQLException;
	void updateFilename(Map<String, Object> params) throws SQLException;
	String getFilename(Integer signatoryId) throws SQLException;
}
