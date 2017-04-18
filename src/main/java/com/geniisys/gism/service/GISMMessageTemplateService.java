package com.geniisys.gism.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GISMMessageTemplateService {

	JSONObject showGisms002(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGisms002ReserveWord(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGisms002(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
