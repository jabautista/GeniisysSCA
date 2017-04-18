package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

public interface GIISMotorTypeDAO {
	JSONObject showSubline(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	JSONObject showMotorType(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> validateGIISS055MotorType (Map<String, Object> params) throws SQLException;
	Map<String, Object> chkDeleteGIISS055MotorType (Map<String, Object> params) throws SQLException;
	Map<String, Object> saveGiiss055(Map<String, Object> params) throws SQLException;
}
