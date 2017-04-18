package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GICLRepSignatoryService {

	JSONObject showGicls181(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showRepSignatory(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGicls181(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	
}
