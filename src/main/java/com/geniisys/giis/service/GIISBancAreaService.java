package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISBancAreaService {

	JSONObject showGiiss215(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiiss215(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void giiss215ValAddRec(HttpServletRequest request) throws SQLException;
	JSONObject showGiiss215Hist(HttpServletRequest request) throws SQLException, JSONException;
}
