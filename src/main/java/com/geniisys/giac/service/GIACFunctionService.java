package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACFunctionService {

	void getFunctionName(HttpServletRequest request, String userId) throws SQLException;
	JSONObject showGiacs314(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiacs314(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGiacs314Module(HttpServletRequest request) throws SQLException;
	JSONObject showFunctionColumn(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validateGiacs314Table(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGiacs314Column(HttpServletRequest request) throws SQLException;
	void saveFunctionColumn(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddFunctionColumn(HttpServletRequest request) throws SQLException;
	JSONObject showFunctionDisplay(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validateGiacs314Display(HttpServletRequest request) throws SQLException;
	void saveColumnDisplay(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddColumnDisplay(HttpServletRequest request) throws SQLException;
	String checkFuncExists(HttpServletRequest request) throws SQLException; //Added by Jerome Bautista 05.28.2015 SR 4225
}
