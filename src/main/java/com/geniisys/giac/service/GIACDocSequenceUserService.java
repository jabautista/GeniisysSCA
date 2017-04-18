package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACDocSequenceUserService {

	JSONObject showGiacs316(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiacs316(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valMinSeqNo(HttpServletRequest request) throws SQLException;
	void valMaxSeqNo(HttpServletRequest request) throws SQLException;
	void valActiveTag(HttpServletRequest request) throws SQLException;
}
