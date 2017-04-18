package com.geniisys.quote.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.quote.entity.GIPIQuoteCAItem;

public interface GIPIQuoteCAItemDAO {
	
	GIPIQuoteCAItem getGIPIQuoteCAItemDetails(Map<String, Object> params) throws SQLException;

}
