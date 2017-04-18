package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;


public interface GIACDCBBankDepService {
	
	/**
	 * Gets the map that will be used for the display of table grid for the GDBD block records in GIACS035
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	Map<String, Object> getGdbdSumListTableGridMap(Map<String, Object> params) throws SQLException, JSONException;
	
	/**
	 * Executes POPULATE_GDBD procedure and fetches the records for GDBD block
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	Map<String, Object> populateGDBD(Map<String, Object> params) throws SQLException, JSONException;
	
	Map<String, Object> saveDCBForClosing(String param, String userId) throws SQLException, JSONException, ParseException;
	void refreshDCB(HttpServletRequest request, String userId) throws SQLException;
}
