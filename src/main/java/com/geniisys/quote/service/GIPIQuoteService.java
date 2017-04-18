package com.geniisys.quote.service;

import java.sql.SQLException;

import com.geniisys.quote.entity.GIPIQuote;

public interface GIPIQuoteService {
	
	GIPIQuote getQuotationDetailsByQuoteId(Integer quoteId) throws SQLException;
	String getVatTag(Integer quoteId) throws SQLException;
	
}
