package com.geniisys.gixx.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIXXProdBudgetDAO {

	Map<String, Object> extractBudgetProduction(Map<String, Object> params) throws SQLException;
	
}
