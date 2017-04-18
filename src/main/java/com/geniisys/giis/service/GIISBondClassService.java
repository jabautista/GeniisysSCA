package com.geniisys.giis.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISBondClassService {
	
	JSONObject getGiiss043BondClass(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	void saveGiiss043(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void giiss043ValAddBondClass(HttpServletRequest request) throws SQLException;
	void giiss043ValDelBondClass(HttpServletRequest request) throws SQLException;
	JSONObject getGiiss043BondClassSubline(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	void giiss043ValAddBondClassSubline(HttpServletRequest request) throws SQLException;
	void giiss043ValDelBondClassSubline(HttpServletRequest request) throws SQLException;
	JSONObject getGiiss043BondClassRt(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	void giiss043ValAddBondClassRt(HttpServletRequest request) throws SQLException;
}
