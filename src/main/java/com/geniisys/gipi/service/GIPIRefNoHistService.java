package com.geniisys.gipi.service;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIPIRefNoHistService {

	JSONObject getRefNoHistListByUser(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject generateBankRefNo(HttpServletRequest request, String userId) throws SQLException;
	String generateCSV(HttpServletRequest request, String userId) throws SQLException, IOException;
	
}
