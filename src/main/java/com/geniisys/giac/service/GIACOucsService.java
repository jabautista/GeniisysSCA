package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACOucsService {

	JSONObject showGiacs305DepartmentList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiacs305(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteOuc(HttpServletRequest request) throws SQLException;
	void valAddOuc(HttpServletRequest request) throws SQLException;
	JSONObject showAllGiacs305(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
