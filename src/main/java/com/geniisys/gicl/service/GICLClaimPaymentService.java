package com.geniisys.gicl.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GICLClaimPaymentService {
	JSONObject showClaimPayment(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException;
	JSONObject showClaimPaymentAdv(HttpServletRequest request, GIISUser uSER) throws SQLException, JSONException;
	String validateEntries(HttpServletRequest request) throws SQLException;
}
