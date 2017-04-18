package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISMcMakeService {

	JSONObject showGIISS103(HttpServletRequest request) throws SQLException, JSONException;
	void saveGIISS103(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	JSONObject showEngineSeries(HttpServletRequest request) throws SQLException, JSONException;
	void saveGIISS103Engine(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddEngine(HttpServletRequest request) throws SQLException;
	void valDeleteEngine(HttpServletRequest request) throws SQLException;
	
}