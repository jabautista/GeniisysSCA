package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIISXolMaintDAO {

	String saveXol(Map<String, Object> allParams) throws SQLException;
	String validateAddXol(Map<String, Object> params) throws JSONException, SQLException;
	String validateUpdateXol(Map<String, Object> params) throws JSONException, SQLException;
	String validateDeleteXol(Map<String, Object> params) throws SQLException;
}
