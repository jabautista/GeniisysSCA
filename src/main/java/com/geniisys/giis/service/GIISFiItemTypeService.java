package com.geniisys.giis.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISFiItemTypeService {
	JSONObject getGiiss012FiItemType(HttpServletRequest request) throws SQLException, JSONException, ParseException;
	void giiss012ValAddRec(HttpServletRequest request) throws SQLException;
	void giiss012ValDelRec(HttpServletRequest request) throws SQLException;
	void saveGiiss012(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
