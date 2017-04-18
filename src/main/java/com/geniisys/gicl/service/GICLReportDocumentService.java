package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GICLReportDocumentService {

	JSONObject showGICLS180(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGICLS180(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
}
