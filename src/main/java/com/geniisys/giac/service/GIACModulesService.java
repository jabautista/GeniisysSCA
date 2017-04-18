/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * The Interface GIACModulesService.
 */
public interface GIACModulesService {
	
	/**
	 * Validates user function.
	 * 
	 * @param user, moduleaccess, moduleid
	 * @return validation flag
	 * @throws SQLException the sQL exception
	 */
	String validateUserFunc(Map<String, Object> param) throws SQLException;
	String validateUserFunc2(Map<String, Object> params) throws SQLException;
	String validateUserFunc3(Map<String, Object> params) throws SQLException;
	JSONObject showGiacs317(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiacs317(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGiacs317ScreenRepTag(HttpServletRequest request) throws SQLException;

}
