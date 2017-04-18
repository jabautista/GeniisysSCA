package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISPositionService {

	JSONObject showGiiss023(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss023(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	JSONObject showGiiss023AllRec(HttpServletRequest request, String userId) throws SQLException, JSONException;
}