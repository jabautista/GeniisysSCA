package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISParameterService {
	Map<String, Object> getGiiss085Rec(HttpServletRequest request, String userId) throws SQLException, JSONException;	
	void saveGiiss085(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	JSONObject showGiiss061(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiiss061(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	//Gisms011
	JSONObject getGisms011NumberList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	public String getParamValueV2(String paramName) throws SQLException;
	void valAssdNameFormat(HttpServletRequest request) throws SQLException;
	void valIntmNameFormat(HttpServletRequest request) throws SQLException;
	void valGisms011AddRec(HttpServletRequest request) throws SQLException;
	void saveGisms011(HttpServletRequest request, String userId) throws SQLException, JSONException;	
}