package com.geniisys.quote.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.quote.entity.GIPIQuoteAVItem;

public interface GIPIQuoteAVItemService {

	GIPIQuoteAVItem getGIPIQuoteAVItemDetails(Map<String, Object> params) throws SQLException;

	
}
