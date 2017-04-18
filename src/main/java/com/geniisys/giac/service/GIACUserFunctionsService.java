package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giac.entity.GIACUserFunctions;

public interface GIACUserFunctionsService {

	/**
	 * Checks if user has specified function cd. Used to check the menu to be disabled in accounting.
	 * @param functionCd
	 * @param moduleName
	 * @param userId
	 * @return
	 * @throws SQLException
	 */
	String checkIfUserHasFunction(String functionCd, String moduleName, String userId) throws SQLException;
	
	String checkOverdueUser(Map<String, Object> params) throws SQLException;
	
	String checkIfUserHasFunction3(Map<String, Object> params) throws SQLException;
	
	// shan 12.16.2013
	JSONObject showGiacs315(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String getScrnRepName(Integer moduleId) throws SQLException;
	Integer getUserFunctionsSeq() throws SQLException;
	void saveGiacs315(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	List<GIACUserFunctions> prepareUserFunctionForInsert(JSONArray rows, String userId) throws SQLException, JSONException, ParseException;
	List<GIACUserFunctions> prepareUserFunctionForDelete(JSONArray rows, String userId) throws SQLException, JSONException;
	Map<String, Object> checkUserFunctionValidity(HttpServletRequest request, String userId) throws SQLException;
	/*void valDeleteRec(HttpServletRequest request) throws SQLException;
	void valAddRec(HttpServletRequest request) throws SQLException;*/
}
