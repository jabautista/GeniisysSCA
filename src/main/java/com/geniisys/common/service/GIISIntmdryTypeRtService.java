package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISIntmdryTypeRtService {

	JSONObject showGiiss201(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss201(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiiss201History(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
