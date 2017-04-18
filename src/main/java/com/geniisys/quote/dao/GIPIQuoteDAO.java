package com.geniisys.quote.dao;

import java.sql.SQLException;

import com.geniisys.quote.entity.GIPIQuote;

public interface GIPIQuoteDAO {
	
	GIPIQuote getQuotationDetailsByQuoteId(Integer quoteId) throws SQLException;
	String getVatTag(Integer quoteId) throws SQLException;
	
}
