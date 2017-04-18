package com.geniisys.giis.service;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISLine;

public interface GIISWarrClaService {
	
	List<GIISLine> getGIISLine() throws SQLException;
	JSONObject getGIISWarrCla(HttpServletRequest request) throws SQLException, JSONException;
	String validateDeleteWarrCla(HttpServletRequest request) throws SQLException;
	String validateAddWarrCla(HttpServletRequest request) throws SQLException;
	String saveWarrCla(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
