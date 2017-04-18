/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.service
	File Name: GIACReplenishDvService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Nov 8, 2012
	Description: 
*/


package com.geniisys.giac.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACReplenishDvService {
	Map<String, Object> getRfDetailAmounts(Map<String, Object> params)throws SQLException;
	void saveRfDetail(String strParameters, String userId) throws SQLException, JSONException;
	Map<String, Object> getGIACS016AcctEntPostQuery(Map<String, Object>params) throws SQLException;

	//Gzelle 04162013
	JSONObject showReplenishmentListing (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showReplenishmentDetail (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showReplenishmentDetailList (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showReplenishmentAcctEntries (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showReplenishmentSumAcctEntries (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	void saveReplenishmentMasterRecord (HttpServletRequest request,  GIISUser USER) throws SQLException;
	void saveReplenishment (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Map<String, Object> getCurrReplenishmentId (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String checkReplenishmentPaytReq(Map<String, Object> params) throws SQLException; // shan 10.09.2014
	BigDecimal getRevolvingFund(Map<String, Object> params) throws SQLException; // shan 10.09.2014
}
