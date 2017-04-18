package com.geniisys.giis.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISNotaryPublicService {
	
	JSONObject getGIISS016NotaryPublicList(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	void saveGiiss016(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void giiss016ValDelRec(HttpServletRequest request) throws SQLException;
}
