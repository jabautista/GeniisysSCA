package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACDeferredService {
	
	String checkIss (HttpServletRequest request, GIISUser USER) throws SQLException;
	String checkIfDataExists (HttpServletRequest request) throws SQLException;
	String checkGenTag (HttpServletRequest request) throws SQLException;
	String checkStatus (HttpServletRequest request) throws SQLException;
	void setTranFlag (HttpServletRequest request, GIISUser USER) throws SQLException;
	String extractMethod (HttpServletRequest request, GIISUser USER) throws SQLException;
	JSONObject getGdMain (HttpServletRequest request, GIISUser USER) throws SQLException, ParseException, JSONException;
	JSONObject getExtractHistory (HttpServletRequest request) throws SQLException, ParseException, JSONException;
	JSONObject getGdDetail (HttpServletRequest request, GIISUser USER) throws SQLException, ParseException, JSONException;
	String checkIfComputed (HttpServletRequest request) throws SQLException;
	String computeMethod (HttpServletRequest request, GIISUser USER) throws SQLException;
	String cancelAcctEntries (HttpServletRequest request, GIISUser USER) throws SQLException;
	String reversePostedTrans (HttpServletRequest request, GIISUser USER) throws SQLException;
	String generateAcctEntries (HttpServletRequest request, GIISUser USER) throws SQLException;
	String setGenTag (HttpServletRequest request, GIISUser USER) throws SQLException;
	JSONObject getDeferredAcctEntries (HttpServletRequest request) throws SQLException, ParseException, JSONException;
	JSONObject getDeferredGLSummary (HttpServletRequest request) throws SQLException, ParseException, JSONException;
	JSONObject getBranchList (HttpServletRequest request, GIISUser USER) throws SQLException, ParseException, JSONException;
}
