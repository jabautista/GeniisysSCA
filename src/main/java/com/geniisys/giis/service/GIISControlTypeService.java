package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISControlTypeService {

	JSONObject showGIISS108(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGIISS108(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDelRec(HttpServletRequest request) throws SQLException;
	JSONObject getAllRecList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
