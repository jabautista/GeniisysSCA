package com.geniisys.giis.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISSplOverrideRtService {
	JSONObject getGiiss202RecList(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	String getGiiss202SelectedPerils(HttpServletRequest request) throws SQLException, Exception;
	void saveGiiss202(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void populateGiiss202(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void copyGiiss202(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGiiss202History(HttpServletRequest request) throws SQLException, JSONException, ParseException;
}
