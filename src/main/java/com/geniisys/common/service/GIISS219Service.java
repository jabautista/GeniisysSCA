package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISS219Service {
	JSONObject showGiiss219(HttpServletRequest request, String userId)throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss219(HttpServletRequest request, String userId) throws SQLException, Exception, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
