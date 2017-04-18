package com.geniisys.quote.service;

import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIPIQuoteItemService {
	
	void saveAllQuotationInformation(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	Integer getMaxQuoteItemNo(Integer quoteId) throws SQLException;
		
}
