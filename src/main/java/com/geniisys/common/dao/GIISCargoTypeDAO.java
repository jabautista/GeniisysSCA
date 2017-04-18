package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

public interface GIISCargoTypeDAO {
	JSONObject showCargoClass(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	JSONObject showCargoType(HttpServletRequest request, Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> saveCargoType(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateCargoType (Map<String, Object> params) throws SQLException;
	Map<String, Object> chkDeleteGIISS008CargoType (Map<String, Object> params) throws SQLException;
}