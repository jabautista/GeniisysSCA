package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIISXolMaintService {

	String saveXol(String strParams, Map<String, Object>params) throws JSONException, SQLException;
	String validateAddXol(Map<String, Object> params) throws JSONException, SQLException;
	String validateUpdateXol(Map<String, Object> params) throws JSONException, SQLException;
	String validateDeleteXol(Map<String, Object> params) throws JSONException, SQLException;
}
