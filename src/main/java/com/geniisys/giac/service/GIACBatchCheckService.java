package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;


public interface GIACBatchCheckService {
	
	Map<String, Object> getPrevExtractParams (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject getMainTable (HttpServletRequest request, String userId) throws SQLException, ParseException, JSONException;
	JSONObject getDetail (HttpServletRequest request, String userId) throws SQLException, ParseException, JSONException;
	JSONObject getNet (HttpServletRequest request, String userId) throws SQLException, ParseException, JSONException;
	String extractBatchChecking (HttpServletRequest request, GIISUser USER) throws SQLException;
	Map<String, Object> getTotalNet (HttpServletRequest request) throws SQLException, JSONException, ParseException;
	Map<String, Object> getTotal (HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	Map<String, Object> getTotalDetail (HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	void checkRecords(HttpServletRequest request, String userId) throws SQLException;
	void checkDetails(HttpServletRequest request, String userId) throws SQLException;
}

