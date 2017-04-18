package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISIntmTypeComrtService {
	JSONObject showGiiss084(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiiss084(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiiss084History(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
