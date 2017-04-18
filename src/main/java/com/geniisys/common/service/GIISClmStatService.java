package com.geniisys.common.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIISClmStatService {
	Map<String, Object> getClmStatDtls(Map<String, Object> params) throws SQLException;
	String getClmStatDesc(String clmStatCd) throws SQLException;
	//Claim Status Maintenance
	JSONObject showClaimStatusMaintenance (HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> saveClaimStatusMaintenance(String parameter, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> chkIfValidInput (HttpServletRequest request) throws SQLException;
}
