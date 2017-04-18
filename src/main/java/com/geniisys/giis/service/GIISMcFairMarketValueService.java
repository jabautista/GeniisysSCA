package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISMcFairMarketValueService {
	
	JSONObject showMcFairMarketValueMaintenance(HttpServletRequest request) throws SQLException, JSONException;
	String saveFmv(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
