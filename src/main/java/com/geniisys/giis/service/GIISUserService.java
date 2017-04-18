package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIISUserService {

	JSONObject showGiiss040(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss040(HttpServletRequest request, String userId) throws Exception;
	void saveGiiss040Tran(HttpServletRequest request, String userId) throws Exception;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGiiss040UserModules(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkAllUserModule(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void uncheckAllUserModule(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONArray includeAllIssCodes(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONArray includeAllLineCodes(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRecTran1(HttpServletRequest request) throws SQLException;
	void valDeleteRecTran1Line(HttpServletRequest request) throws SQLException;
	GIISUser getUserDetails(String userId) throws SQLException;
}
