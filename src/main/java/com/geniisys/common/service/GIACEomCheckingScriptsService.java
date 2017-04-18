package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACEomCheckingScriptsService {
	
	JSONObject showGiacs352(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiacs352(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
