package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIPIReminderService {

	JSONObject getGIPIReminderListing(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGIPIReminderDetails(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String saveReminder(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String validateAlarmUser(HttpServletRequest request) throws SQLException;
	JSONObject showNotesPage(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	Integer getClaimParId(String claimId) throws SQLException;	//SR-19555 : shan 07.07.2015
}
