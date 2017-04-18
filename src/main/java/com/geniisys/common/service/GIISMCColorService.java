package com.geniisys.common.service;

import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;

public interface GIISMCColorService {
	JSONObject showGiiss114BasicColor(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiiss114(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRecBasic(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss114(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRecBasic(HttpServletRequest request) throws SQLException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
