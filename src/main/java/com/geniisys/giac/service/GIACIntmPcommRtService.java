package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACIntmPcommRtService {
	JSONObject showGiacs334(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGiacs334(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
