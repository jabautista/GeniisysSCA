package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GICLLossProfileService {

	public Map<String, Object> whenNewFormInstance() throws SQLException;
	public JSONObject showLossProfileParam(HttpServletRequest request, String userId) throws SQLException, JSONException;
	public void saveProfile(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	public JSONObject showRange(HttpServletRequest request, String userId) throws SQLException, JSONException;
	public String extractLossProfile(HttpServletRequest request, String userId) throws SQLException, ParseException;
	public JSONObject showLossProfileSummary(HttpServletRequest request, String userId) throws SQLException, JSONException;
	public JSONObject showLossProfileDetail(HttpServletRequest request, String userId) throws SQLException, JSONException;
	public String checkRecovery(HttpServletRequest request) throws SQLException;
	public JSONObject showRecoveryListing(HttpServletRequest request) throws SQLException, JSONException;
	
	void validateRange(HttpServletRequest request, String userId) throws SQLException;

}
