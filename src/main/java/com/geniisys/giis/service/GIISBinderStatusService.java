package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISBinderStatusService {
	
	JSONObject showGiiss209(HttpServletRequest request) throws SQLException, JSONException;
	void saveGiiss209(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddBinderStatus(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
}
