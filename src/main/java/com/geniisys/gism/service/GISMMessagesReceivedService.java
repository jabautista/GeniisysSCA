package com.geniisys.gism.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GISMMessagesReceivedService {

	JSONObject getMessagesReceived(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getMessageDetail(HttpServletRequest request) throws SQLException, JSONException;
	void replyToMessage(HttpServletRequest request, String userId) throws SQLException;
	JSONObject getSMSErrorLog(HttpServletRequest request) throws SQLException, JSONException;
	void gisms008Assign(HttpServletRequest request, String userId) throws SQLException;
	void gisms008Purge(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
