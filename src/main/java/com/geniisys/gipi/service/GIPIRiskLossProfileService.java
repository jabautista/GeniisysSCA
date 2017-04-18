package com.geniisys.gipi.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIPIRiskLossProfileService {
	JSONObject getGipiRiskLossProfile (HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGipiRiskLossProfileRange (HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGIPIS902 (HttpServletRequest request, String userId) throws SQLException, JSONException;
	void extractGIPIS902(HttpServletRequest request, String userId) throws SQLException;
}
