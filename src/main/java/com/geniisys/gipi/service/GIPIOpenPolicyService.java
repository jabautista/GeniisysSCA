package com.geniisys.gipi.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPIOpenPolicy;

public interface GIPIOpenPolicyService {
	
	GIPIOpenPolicy getEndtseq0OpenPolicy(Integer policyEndSeq0) throws SQLException;
	JSONObject getOpenPolicyList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getOpenLiabFiMn(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getOpenCargos(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getOpenPerils(HttpServletRequest request) throws SQLException, JSONException;
}
