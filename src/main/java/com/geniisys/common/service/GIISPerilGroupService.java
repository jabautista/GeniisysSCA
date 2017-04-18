package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISPerilGroupService {
	JSONObject showGiiss213(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiiss213(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiiss213Dtl(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	JSONObject showGiiss213PerilList(HttpServletRequest request) throws SQLException, JSONException;
}
