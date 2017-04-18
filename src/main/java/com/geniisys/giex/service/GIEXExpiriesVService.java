package com.geniisys.giex.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIEXExpiriesVService {
	
	HashMap<String, Object> getExpiredPolicies(HashMap<String, Object> params) throws SQLException, JSONException;
	HashMap<String, Object> getQueriedExpiredPolicies(HashMap<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> preFormGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> postQueryGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPolicyGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkRenewFlagGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> verifyOverrideRbGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> processPostButtonGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> processPostOnOverrideGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveProcessTagGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedNotParam(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedNotTime(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedOnBeforeMonth(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedOnBeforeDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedExactMonth(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedExactDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkNoOfRecordsToPurge(Map<String, Object> params) throws SQLException;
	List<String> getPolicyIdGiexs006(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGiex004InitialVariables() throws SQLException;
	void giexs004ProcessPostButton(Map<String, Object>params ) throws SQLException;
	void giexs004ProcessRenewal(Map<String, Object> params) throws SQLException;
	void giexs004ProcessPolicies(Map<String, Object> params) throws SQLException;
	JSONObject showViewRenewal(HttpServletRequest request, String USER) throws SQLException, JSONException;
	JSONObject showRenewalHistory(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getExpiryRecord (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String updateExpiryRecord (HttpServletRequest request, String USER) throws SQLException, ParseException, JSONException;
	String updateExpiriesByBatch(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException, JSONException;
	Integer checkExtractUserAccess (HttpServletRequest request) throws SQLException;
	String checkRecords (HttpServletRequest request, GIISUser USER) throws SQLException;
	String checkSubline (HttpServletRequest request) throws SQLException;
}
