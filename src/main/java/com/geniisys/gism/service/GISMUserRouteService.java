package com.geniisys.gism.service;

import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

public interface GISMUserRouteService {
	JSONObject showGisms010(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGisms010(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
