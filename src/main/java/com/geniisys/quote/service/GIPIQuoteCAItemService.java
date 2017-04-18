package com.geniisys.quote.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.quote.entity.GIPIQuoteCAItem;

public interface GIPIQuoteCAItemService {
	
	GIPIQuoteCAItem getGIPIQuoteCAItemDetails(Map<String, Object> params) throws SQLException;

}
