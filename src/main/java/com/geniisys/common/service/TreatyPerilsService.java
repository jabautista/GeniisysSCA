package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public interface TreatyPerilsService {
	JSONObject showGiris007DistShare(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiris007Xol(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject executeA6401(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddA6401Rec(HttpServletRequest request) throws SQLException;
	void saveA6401(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject includeAllA6401(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject executeTrtyPerilXol(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddTrtyPerilXolRec(HttpServletRequest request) throws SQLException;
	void saveTrtyPerilXol(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONArray getAllPerils(HttpServletRequest request) throws SQLException;
}
