package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISBancBranchService {

	JSONObject showGiiss216(HttpServletRequest request) throws SQLException, JSONException;
	void saveGiiss216(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiiss216Hist(HttpServletRequest request) throws SQLException, JSONException;
	void valAddRecGiiss216(HttpServletRequest request) throws SQLException;
}
