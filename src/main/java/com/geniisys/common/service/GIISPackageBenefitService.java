package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISPackageBenefitService {
	JSONObject showGiiss120(HttpServletRequest request, String userId)throws SQLException, JSONException;
	void saveGiiss120(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	JSONObject showAllGiiss120(HttpServletRequest request, String userId)throws SQLException, JSONException;
}
