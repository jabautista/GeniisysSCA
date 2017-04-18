package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACTaxesService {

	JSONObject showGIACS320(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGIACS320(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Integer checkAccountCode(HttpServletRequest request) throws SQLException;
	
}
