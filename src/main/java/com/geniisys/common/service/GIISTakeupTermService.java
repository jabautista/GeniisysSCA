package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISTakeupTermService {

	JSONObject showGiiss211(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss211(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
