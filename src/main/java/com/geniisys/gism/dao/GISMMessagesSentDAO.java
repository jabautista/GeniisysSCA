package com.geniisys.gism.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GISMMessagesSentDAO {

	void resendMessage(Map<String, Object> params) throws SQLException;
	void cancelMessage(Map<String, Object> params) throws SQLException;
	void saveMessages(Map<String, Object> params) throws SQLException, JSONException;
	String validateCellphoneNo(Map<String, Object> params) throws SQLException;
	
}
