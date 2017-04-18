package com.geniisys.quote.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.quote.entity.GIPIQuoteAVItem;

public interface GIPIQuoteAVItemDAO {
	
	GIPIQuoteAVItem getGIPIQuoteAVItemDetails(Map<String, Object> params) throws SQLException;

}
