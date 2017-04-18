package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import org.json.JSONException;

public interface GIACSpoiledOrService {

	void getGIACSpoiledOrListing(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	void saveSpoiledOrDtls(String params, String userId) throws SQLException, JSONException, ParseException;
	String validateSpoiledOr(Map<String, Object> params) throws SQLException;
}
