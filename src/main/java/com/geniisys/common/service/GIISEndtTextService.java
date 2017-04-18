package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;

public interface GIISEndtTextService {

	PaginatedList getEndtTextList(HashMap<String, Object> params, Integer pageNo) throws SQLException;
	JSONObject showGiiss104(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGiiss104(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDelRec(HttpServletRequest request) throws SQLException;	//Gzelle 02062015
}
