package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISPolicyTypeService {
	JSONObject showGiiss091(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void valTypeDesc(HttpServletRequest request) throws SQLException;
	void saveGiiss091(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	//added by jdiago 08.27.2004 : get all of them for unique validation
	JSONObject getAllLineCdTypeCd(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getAllTypeDesc(HttpServletRequest request) throws SQLException, JSONException;
}
