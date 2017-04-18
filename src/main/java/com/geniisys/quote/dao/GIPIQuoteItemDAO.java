package com.geniisys.quote.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIPIQuoteItemDAO {
	
	void saveAllQuotationInformation(Map<String, Object> params) throws SQLException;
	Integer getMaxQuoteItemNo(Integer quoteId) throws SQLException;
	
}
