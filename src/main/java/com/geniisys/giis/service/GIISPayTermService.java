package com.geniisys.giis.service;

import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.giis.entity.GIISPayTerm;
import com.ibm.disthub2.impl.matching.selector.ParseException;

public interface GIISPayTermService {
	List<GIISPayTerm> getPaymentTerm() throws SQLException, JSONException;

	String savePaymentTerm(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException;

	String validateDeletePaytTerm(String paytTerms) throws JSONException, SQLException, ParseException;

	String validateAddPaytTerm(String paytTerms) throws JSONException, SQLException, ParseException;

	String validateAddPaytTermDesc(HttpServletRequest request) throws JSONException, SQLException, ParseException;
}
