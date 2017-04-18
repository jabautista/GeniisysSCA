package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GICLMcDepreciationService { 
	JSONObject showGicls059(HttpServletRequest request, String userId)throws SQLException, JSONException;
	void saveGicls059(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
