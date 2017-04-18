package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.ibm.disthub2.impl.matching.selector.ParseException;

public interface GIACFileSourceService {
	JSONObject getFileSourceRecords (HttpServletRequest request) throws SQLException, JSONException, ParseException;
	String saveFileSource(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException;
}
