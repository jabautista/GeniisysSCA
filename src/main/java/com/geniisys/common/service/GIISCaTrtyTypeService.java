package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISCaTrtyTypeService {
	JSONObject showGiiss094(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiiss094(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
