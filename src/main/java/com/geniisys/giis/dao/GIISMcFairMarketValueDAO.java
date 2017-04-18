package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISMcFairMarketValueDAO {
	
	String saveFmv(Map<String, Object> allParams) throws SQLException;
	
}
