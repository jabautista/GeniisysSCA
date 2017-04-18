package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISAirTypeService {

	JSONObject showGiiss048(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss048(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
