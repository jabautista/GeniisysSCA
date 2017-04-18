package com.geniisys.giac.service;

import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;
import java.text.ParseException;

public interface GIACBudgetService {
	
	JSONObject showGIACS510(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showBudgetPerYear(HttpServletRequest request) throws SQLException, JSONException;
	void valAddBudgetYear(HttpServletRequest request) throws SQLException;
	void copyBudget(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGLAcctLOV(HttpServletRequest request) throws SQLException, JSONException;
	void saveGiacs510(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGIACS510Dtl(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteBudgetPerYear(HttpServletRequest request) throws SQLException;
	String validateGLAcctNo(HttpServletRequest request) throws SQLException;
	JSONObject showBudgetDtlOverlay(HttpServletRequest request) throws SQLException, JSONException;
	String checkExistBeforeExtractGiacs510(HttpServletRequest request) throws SQLException;
	String extractGiacs510(HttpServletRequest request, String userId) throws SQLException, ParseException;
	JSONObject viewNoDtl(HttpServletRequest request) throws SQLException, JSONException;
}
