package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACRecapDtlExtService {

	Map<String, Object> getRecapVariables() throws SQLException;
	JSONObject getRecapDetailsTableGrid(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getRecapLineDetailsTableGrid(HttpServletRequest request) throws SQLException, JSONException;
	void extractRecap(HttpServletRequest request, String userId) throws SQLException;
	Integer checkDataFetched() throws SQLException;
	
}
