package com.geniisys.giac.service;


import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;


public interface GIACReinsuranceInquiryService {

	JSONObject viewRiLossRecoveries (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject viewRiLossRecoveriesOverlay (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;

	//mikel
	JSONObject showRiBillPayment(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject getGIACS270GipiInvoice(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException;
	JSONObject getGIACS270GiacInwfaculPremCollns(HttpServletRequest request,GIISUser USER)throws SQLException, JSONException;

}
