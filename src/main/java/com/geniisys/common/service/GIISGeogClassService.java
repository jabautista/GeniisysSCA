package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIISGeogClassService {
	JSONObject showGeographyClass (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> validateGeogCdInput (HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGeogDescInput (HttpServletRequest request) throws SQLException;
	Map<String, Object> validateBeforeDelete (HttpServletRequest request) throws SQLException;
	Map<String, Object> saveGeogClass (String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
}
