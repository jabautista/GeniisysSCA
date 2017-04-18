package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIPIInvoiceService {
	
	/**
	 * Returns invoice for a given policy
	 * @param   policyId
	 * @returns policyId,itemGrp,issCd,premSeqNo,premCollMode
	 * @throws  SQLException
	 */
	HashMap<String, Object> getPolicyInvoice (HashMap<String,Object> params) throws SQLException;

	/**
	 * Gets monthly booking year and monthly booking date based on specified policy id and dist no.
	 * @param policyId
	 * @param distNo
	 * @return
	 * @throws SQLException
	 */
	String getMultiBookingDateByPolicy(Integer policyId, Integer distNo) throws SQLException;
	
	HashMap<String, Object> populateBasicDetails(HashMap<String, Object> params) throws SQLException, JSONException;

	//GIPIS137
	JSONObject showInvoiceInformation(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	JSONObject getInvoiceTaxDetails(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
