package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLLossRecoveryStatusService {

	JSONObject showLossRecoveryStatus(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showGICLS269RecoveryDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showGICLS269RecoveryHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
}
