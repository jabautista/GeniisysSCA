package com.geniisys.gism.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GISMMessagesReceivedDAO {

	Map<String, Object> getMessageDetail(Integer messageId) throws SQLException, JSONException;
	void replyToMessage(Map<String, Object> params) throws SQLException;
	void gisms008Assign(Map<String, Object> params) throws SQLException;
	void gisms008Purge(Map<String, Object> params) throws SQLException, JSONException;
	
}
