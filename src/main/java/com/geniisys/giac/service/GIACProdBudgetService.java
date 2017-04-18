package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACProdBudgetService {
	
	JSONObject getGiacs360YearMonth(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiacs360(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiacs360(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valAddYearRec(HttpServletRequest request) throws SQLException;
}
