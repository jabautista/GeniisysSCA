package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIPIUserEventService {

	Map<String, Object> getGIPIUserEventTableGrid(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> getGIPIUserEventDetailTableGrid(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	String saveCreatedEvent(Map<String, Object> params) throws SQLException, JSONException, Exception;
	void setWorkflowGICLS010(Map<String, Object> params) throws SQLException;
	String transferEvents(Map<String, Object> params) throws SQLException, JSONException, Exception;
	void deleteEvents(Map<String, Object> params) throws SQLException, JSONException;
	void saveGIPIUserEventDtls(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
