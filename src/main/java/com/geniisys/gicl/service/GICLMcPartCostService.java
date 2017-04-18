package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GICLMcPartCostService {

	JSONObject showGicls058(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGicls058(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	JSONObject showGicls058History(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valModelYear(HttpServletRequest request) throws SQLException; 
}
