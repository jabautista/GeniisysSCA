package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISEventService {

	void saveGIISEvents(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String createTransferEvent(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteGIISEvents(HttpServletRequest request) throws SQLException;
	JSONObject getGIISEventColumn(HttpServletRequest request, String userId)throws SQLException, JSONException;
	void valDeleteGIISEventsColumn(HttpServletRequest request) throws SQLException;
	void valAddGIISEventsColumn(HttpServletRequest request) throws SQLException;
	void setGIISEventsColumn(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	JSONObject getGIISEventDisplay(HttpServletRequest request, String userId)throws SQLException, JSONException;
	void valAddGIISEventsDisplay(HttpServletRequest request) throws SQLException;
	void setGIISEventsDisplay(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
