/**
 * 
 */
package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACAgingParametersService {
	JSONObject showGiacs310(HttpServletRequest request, String userId)throws SQLException, JSONException;
	void saveGiacs310(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void copyRecords(HttpServletRequest request, String userId) throws SQLException;
}
