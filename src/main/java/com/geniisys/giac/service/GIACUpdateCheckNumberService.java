package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACUpdateCheckNumberService {
	public void validateCheckPrefSuf (HttpServletRequest request, String userId) throws SQLException, JSONException;
	public JSONObject validateCheckNo (HttpServletRequest request) throws SQLException;
	public String updateCheckNumber(HttpServletRequest request, String userId) throws SQLException, JSONException ;
}
