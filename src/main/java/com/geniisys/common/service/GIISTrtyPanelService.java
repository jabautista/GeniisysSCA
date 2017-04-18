package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISTrtyPanelService {

	JSONObject showGiiss031(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiiss031(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGiiss031Reinsurer(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGiiss031ParentRi(HttpServletRequest request) throws SQLException;
	JSONObject showGiiss031AllRec(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddNpRec(HttpServletRequest request) throws SQLException;
	void saveGiiss031Np(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
}
