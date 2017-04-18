package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACSlTypeService {

	JSONObject showGiacs308(HttpServletRequest request) throws SQLException, JSONException;
	void valDeleteSlType(HttpServletRequest request) throws SQLException;
	void saveGiacs308(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddSlType(HttpServletRequest request) throws SQLException;
	
}
