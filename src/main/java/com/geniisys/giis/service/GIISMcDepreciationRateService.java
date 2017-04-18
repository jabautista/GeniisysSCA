package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.ibm.disthub2.impl.matching.selector.ParseException;

public interface GIISMcDepreciationRateService {
	
	String saveMcDr(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String validateAddMcDepRate(HttpServletRequest request) throws SQLException;
	String validateMcPerilRec(HttpServletRequest request) throws SQLException;
	String deleteMcPerilRec(HttpServletRequest request) throws SQLException;
	String savePerilDepRate(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException;
}
