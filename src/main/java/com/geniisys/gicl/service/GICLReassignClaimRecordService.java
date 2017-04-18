package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLReassignClaimRecordService {
	JSONObject getClaimDetail (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	String updateClaimRecord(HttpServletRequest request, String USER) throws JSONException, SQLException, ParseException;
	String checkIfCanReassignClaim (GIISUser USER) throws JSONException, SQLException, ParseException;
}
