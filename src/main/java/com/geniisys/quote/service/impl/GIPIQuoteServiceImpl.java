package com.geniisys.quote.service.impl;

import java.sql.SQLException;

import com.geniisys.quote.dao.GIPIQuoteDAO;
import com.geniisys.quote.entity.GIPIQuote;
import com.geniisys.quote.service.GIPIQuoteService;

public class GIPIQuoteServiceImpl implements GIPIQuoteService{
	
	private GIPIQuoteDAO gipiQuoteDAO2;

	public GIPIQuoteDAO getGipiQuoteDAO2() {
		return gipiQuoteDAO2;
	}

	public void setGipiQuoteDAO2(GIPIQuoteDAO gipiQuoteDAO2) {
		this.gipiQuoteDAO2 = gipiQuoteDAO2;
	}

	public GIPIQuote getQuotationDetailsByQuoteId(Integer quoteId)
			throws SQLException {
		return this.getGipiQuoteDAO2().getQuotationDetailsByQuoteId(quoteId);
	}

	public String getVatTag(Integer quoteId) throws SQLException {
		return this.getGipiQuoteDAO2().getVatTag(quoteId);
	}

}
