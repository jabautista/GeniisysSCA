package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACPdcChecksService  {
	JSONObject showGiacs032(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> checkDateForDeposit(HttpServletRequest request) throws SQLException;
	void saveForDeposit(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showReplacementHistory(HttpServletRequest request) throws SQLException, JSONException;
	void saveReplacePDC(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiacs031(HttpServletRequest request) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGiacs031(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject queryPolicyDummyTable(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> applyPDC(HttpServletRequest request, String userId) throws SQLException;
}
