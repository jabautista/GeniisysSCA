package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLDrvrOccptnService {
	JSONObject showDrvrOccptnMaintenance (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> validateDrvrOccptnInput (HttpServletRequest request) throws SQLException;
	Map<String, Object> saveDrvrOccptnMaintenance(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
}