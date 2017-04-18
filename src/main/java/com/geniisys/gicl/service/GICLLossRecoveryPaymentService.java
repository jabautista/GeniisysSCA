package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLLossRecoveryPaymentService {

	JSONObject showLossRecoveryPayment(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showGICLS270PaymentDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showGICLS270DistributionDs(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject showGICLS270DistributionRids(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
}
