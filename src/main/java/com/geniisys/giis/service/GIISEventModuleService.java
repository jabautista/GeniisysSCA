package com.geniisys.giis.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISEventModuleService {
	JSONObject getGiiss168EventModules(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	String getGiiss168SelectedModules(HttpServletRequest request) throws SQLException;
	void saveGiiss168(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGiiss168PassingUser(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	JSONObject getGiiss168ReceivingUser(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	String getGiiss168SelectedPassingUsers(HttpServletRequest request) throws SQLException;
	String getGiiss168SelectedReceivingUsers(HttpServletRequest request) throws SQLException;
	void saveGiiss168UserList(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
	void valDelGiiss168PassingUsers(HttpServletRequest request) throws SQLException;
}
