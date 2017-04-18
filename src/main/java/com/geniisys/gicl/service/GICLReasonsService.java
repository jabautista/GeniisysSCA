package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLReasonsService {
	JSONObject showClmStatReasonsMaintenance (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> validateReasonsInput (HttpServletRequest request) throws SQLException;
	Map<String, Object> saveClmStatReasonsMaintenance(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
}
