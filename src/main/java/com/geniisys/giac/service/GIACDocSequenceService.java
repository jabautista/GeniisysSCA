package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACDocSequenceService {

	JSONObject showGiacs322(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiacs322(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valAddRec(HttpServletRequest request) throws SQLException;
}
