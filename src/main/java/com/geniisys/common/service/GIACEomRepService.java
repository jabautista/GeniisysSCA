package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACEomRepService {
	JSONObject showGiacs350(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiacs350(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	JSONObject showGiacs351(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void validateGLAcctNo(HttpServletRequest request) throws SQLException;
	void valAddDtlRec(HttpServletRequest request) throws SQLException;
	void saveGiacs351(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
