package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;


public interface GIACCommSlipService {
	
	Map<String, Object> getCommSlip(Map<String, Object> params) throws SQLException;
	Map<String, Object> preparePrintParam(String param, String userId, int tranId, String vpdc) throws SQLException, JSONException;
	void confirmCommSlipPrinted(Map<String, Object> params) throws SQLException;
	JSONObject getCommSlipJSON(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
