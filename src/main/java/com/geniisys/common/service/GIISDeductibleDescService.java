package com.geniisys.common.service;
import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;
import java.util.Map;
import org.json.JSONException;
import java.text.ParseException;


import org.json.JSONObject;


public interface GIISDeductibleDescService {
	JSONObject showGiiss010(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss010(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	Map<String, Object> getAllTDedType (HttpServletRequest request) throws SQLException, JSONException, ParseException;	//Gzelle 08272015 SR4851
}
