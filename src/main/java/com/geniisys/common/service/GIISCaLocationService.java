package com.geniisys.common.service;

import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

public interface GIISCaLocationService {
	JSONObject showGiiss217(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiiss217(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
