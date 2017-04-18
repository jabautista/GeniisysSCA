package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISMCSublineTypeService {
	JSONObject showGiiss056(HttpServletRequest request) throws SQLException, JSONException;
	void giiss056ValAddRec(HttpServletRequest request) throws SQLException, JSONException;
	void saveGiiss056(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void giiss056ValDelRec(HttpServletRequest request) throws SQLException;
}
