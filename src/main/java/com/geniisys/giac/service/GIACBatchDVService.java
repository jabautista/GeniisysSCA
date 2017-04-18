/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giac.service
	File Name: GIACBatchDVService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 8, 2011
	Description: 
*/


package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACBatchDVService {
	Map<String, Object> getSpecialCSRListing(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Map<String, Object> getGIACS086AcctTransTableGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void cancelGIACBatch(Map<String, Object>params) throws SQLException;
	Map<String, Object> getGIACS086AcctEntPostQuery(Map<String, Object>params) throws SQLException;
	
	JSONObject getGIACS087Listing(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getGIACS087BatchDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getGIACS087AcctEntries(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getGIACS087AcctEntriesDtl(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getGIACS087AcctEntTotals(HttpServletRequest request) throws SQLException;
}
