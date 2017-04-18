package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

public interface GICLDrvrOccptnDAO {
	JSONObject showDrvrOccptnMaintenance(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> validateDrvrOccptnInput (Map<String, Object> params) throws SQLException;
	Map<String, Object> saveDrvrOccptnMaintenance(Map<String, Object> params) throws SQLException;
}