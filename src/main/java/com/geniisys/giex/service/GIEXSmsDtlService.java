package com.geniisys.giex.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIEXSmsDtlService {

	Map<String, Object> checkSMSAssured(HttpServletRequest request) throws SQLException;
	Map<String, Object> checkSMSIntm(HttpServletRequest request) throws SQLException;
	void updateSMSTags(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void sendSMS(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveSMS(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
