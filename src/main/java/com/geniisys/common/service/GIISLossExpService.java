package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISLossExpService {

	JSONObject showGicls104(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGicls104(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	Map<String, Object> valPartSw(HttpServletRequest request) throws SQLException;
	String valLpsSw(HttpServletRequest request) throws SQLException;
	Map<String, Object> valCompSw(HttpServletRequest request) throws SQLException;
	String valLossExpType(HttpServletRequest request) throws SQLException;
	Map<String, Object> getOrigSurplusAmt(HttpServletRequest request) throws SQLException; //Added by Kenneth L. 06.11.2015 SR 3626			
}
