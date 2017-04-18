package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;

public interface GIISMotorTypeService {
	JSONObject showSubline (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showMotorType (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> validateGIISS055MotorType (HttpServletRequest request) throws SQLException;
	Map<String, Object> chkDeleteGIISS055MotorType (HttpServletRequest request) throws SQLException;
	Map<String, Object> saveGiiss055(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
}
