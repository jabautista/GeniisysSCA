package com.geniisys.gicl.service;

import java.math.BigDecimal;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GICLAdvLineAmtService {

	BigDecimal getRangeTo(HttpServletRequest request) throws SQLException;
	
	// shan 11.27.2013
	JSONObject showGicls182(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGicls182(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
