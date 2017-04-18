package com.geniisys.giis.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISRequiredDocService {
	void saveGIISRequiredDoc(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
	List<String> getCurrenDocCdList(Map<String, Object> params) throws SQLException;
	JSONObject showGiiss035(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss035(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGiiss035Line(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> validateGiiss035Subline(HttpServletRequest request) throws SQLException;
}
