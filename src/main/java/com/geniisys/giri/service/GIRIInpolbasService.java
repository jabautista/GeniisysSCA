package com.geniisys.giri.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIRIInpolbasService {
	JSONObject getInwardRiPaymentStatus (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showInwRiDetailsOverlay (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	
	JSONObject showGIRIS012MainTableGrid (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
	JSONObject showGIRIS012Details (HttpServletRequest request) throws SQLException, JSONException, ParseException;
	
	JSONObject getGIUTS030BinderList (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;	
	JSONObject populateGiris027 (HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException;
}
