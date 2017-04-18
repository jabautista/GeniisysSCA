package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;

public interface GIISTyphoonZoneService {
	JSONObject showTyphoonZoneMaintenance (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> validateTyphoonZoneInput (HttpServletRequest request) throws SQLException;
	Map<String, Object> validateDeleteTyphoonZone (HttpServletRequest request) throws SQLException;
	Map<String, Object> saveTyphoonZoneMaintenance(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
}