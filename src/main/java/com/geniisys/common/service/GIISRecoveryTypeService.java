package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;


public interface GIISRecoveryTypeService {

	String getRecTypeDescGicls201(HttpServletRequest request) throws SQLException, JSONException;

	JSONObject showMenuRecoveryType(HttpServletRequest request, String userId)throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGicls101(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
