package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACCheckNoService {

	void checkBranchForCheck(HttpServletRequest request) throws SQLException;
	JSONObject getCheckNoList(HttpServletRequest request) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDelRec(HttpServletRequest request) throws SQLException;
	void saveGIACS326(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
