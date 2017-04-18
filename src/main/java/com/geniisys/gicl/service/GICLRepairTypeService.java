package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GICLRepairTypeService {

	JSONObject showGicls172(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGicls172(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDelRec(HttpServletRequest request) throws SQLException;
}
