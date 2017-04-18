package com.geniisys.common.service;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISCoverageService {
	JSONObject showGiiss113(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss113(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getAllCoverageDescList(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
