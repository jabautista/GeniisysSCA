package com.geniisys.giri.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIRIEndttextService {
	
	Map<String, Object> getRiDtlsGIUTS024(Map<String, Object> params) throws SQLException;
	HashMap<String, Object> getRiDtlsList(HashMap<String, Object> params) throws SQLException, JSONException;
	void updateCreateEndtTextBinder(Map<String, Object> params) throws Exception;
	public void deleteRiDtlsGIUTS024(Map<String, Object> params) throws SQLException;
	void saveEndtTextBinder(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;

}
