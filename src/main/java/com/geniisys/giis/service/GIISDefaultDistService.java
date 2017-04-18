package com.geniisys.giis.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISDefaultDistService {

	JSONObject getDefaultDistList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getDefaultDistDtlList(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getPerilList(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getDefaultDistPerilList(HttpServletRequest request) throws SQLException, JSONException;
	void saveGiiss165(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void checkDistRecords(HttpServletRequest request) throws SQLException;
	Map<String, Object> getDistPerilVariables(HttpServletRequest request) throws SQLException;
	
}