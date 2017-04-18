package com.geniisys.giis.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISSlidCommService {

	JSONObject getPerils(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getSlidingComm(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getHistory(HttpServletRequest request) throws SQLException, JSONException;
	void checkRate(HttpServletRequest request) throws SQLException;
	void saveGIISS220(HttpServletRequest request, String userId) throws SQLException, JSONException;
	List<Map<String, Object>> getRateList(HttpServletRequest request) throws SQLException;
	
}
