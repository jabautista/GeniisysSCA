package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISBancTypeService {

	JSONObject showGiiss218(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getBancTypeDtls(HttpServletRequest request) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valAddDtl(HttpServletRequest request) throws SQLException;
	void saveGiiss218(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
