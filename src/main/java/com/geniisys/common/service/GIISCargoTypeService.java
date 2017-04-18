package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;

public interface GIISCargoTypeService {
	JSONObject showCargoClass (HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showCargoType (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> saveCargoType(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> validateCargoType (HttpServletRequest request) throws SQLException;
	Map<String, Object> chkDeleteGIISS008CargoType (HttpServletRequest request) throws SQLException;
}
