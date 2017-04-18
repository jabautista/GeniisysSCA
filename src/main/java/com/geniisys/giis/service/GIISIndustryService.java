package com.geniisys.giis.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISIndustryService {
	JSONObject getGIISS014IndustryList(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss014(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valUpdateRec(HttpServletRequest request) throws SQLException;
}
