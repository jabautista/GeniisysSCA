package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISIntmSpecialRateService {

	JSONObject showGIISS082(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showHistory(HttpServletRequest request) throws SQLException, JSONException;
	void populatePerils(HttpServletRequest request, String userId) throws SQLException;
	void copyIntmRate(HttpServletRequest request, String userId) throws SQLException;
	void saveGIISS082(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String getPerilList(HttpServletRequest request) throws SQLException;
	
}
