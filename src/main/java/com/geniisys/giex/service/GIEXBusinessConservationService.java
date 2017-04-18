package com.geniisys.giex.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;

public interface GIEXBusinessConservationService {
	Map<String, Object> extractPolicies(Map<String, Object> params) throws SQLException;
	HashMap<String, Object> getBusConDetails(HashMap<String, Object> params) throws SQLException, JSONException, ParseException;
	HashMap<String, Object> getBusConPackDetails(HashMap<String, Object> params) throws SQLException, JSONException, ParseException;
}
