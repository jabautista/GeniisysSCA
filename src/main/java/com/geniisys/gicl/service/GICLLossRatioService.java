package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GICLLossRatioService {

	String validateAssdNoGicls204(HttpServletRequest request) throws SQLException;
	String validatePerilCdGicls204(HttpServletRequest request) throws SQLException;
	String extractGicls204(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String getDetailReportDate(HttpServletRequest request) throws SQLException;
	JSONObject showLossRatioSummary(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showPremiumsWrittenCurr(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showPremiumsWrittenPrev(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showOutLoss(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showLossPaid(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject showLossRec(HttpServletRequest request) throws SQLException, JSONException;

}
