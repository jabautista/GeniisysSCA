package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISDspColumnService {
	JSONObject showDisplayColumns(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGiiss167(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
