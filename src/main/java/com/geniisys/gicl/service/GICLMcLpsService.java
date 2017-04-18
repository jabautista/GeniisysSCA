package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GICLMcLpsService {
	JSONObject showGicls171(HttpServletRequest request) throws SQLException, JSONException;
	void saveGicls171(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGicls171LpsHistory(HttpServletRequest request) throws SQLException, JSONException;
}
