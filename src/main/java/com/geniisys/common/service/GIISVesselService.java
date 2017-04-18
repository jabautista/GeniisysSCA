package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISVesselService {

	JSONObject showGiiss049(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss049(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateAirTypeCd(HttpServletRequest request) throws SQLException;
	
	JSONObject showGiiss050(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRecGiiss050(HttpServletRequest request) throws SQLException;
	void saveGiiss050(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRecGiiss050(HttpServletRequest request) throws SQLException;
	
	JSONObject showGiiss039(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRecGiiss039(HttpServletRequest request) throws SQLException;
	void saveGiiss039(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRecGiiss039(HttpServletRequest request) throws SQLException;
}
