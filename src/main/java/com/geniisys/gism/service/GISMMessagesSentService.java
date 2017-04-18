package com.geniisys.gism.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;


public interface GISMMessagesSentService {

	JSONObject getMessagesSent(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getMessageDetails(HttpServletRequest request) throws SQLException, JSONException;
	void resendMessage(HttpServletRequest request, String userId) throws SQLException;
	JSONObject getCreatedMessages(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getCreatedMessagesDtl(HttpServletRequest request) throws SQLException, JSONException;
	void cancelMessage(HttpServletRequest request, String userId) throws SQLException;
	JSONObject getRecipientList(HttpServletRequest request) throws SQLException, JSONException;
	void saveMessages(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String validateCellphoneNo(HttpServletRequest request) throws SQLException;
	
}
