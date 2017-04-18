package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISIntreatyService {
	JSONObject showGiiss032(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss032(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
