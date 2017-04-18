package com.geniisys.gixx.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface GIXXProdBudgetService {

	Map<String, Object> extractBudgetProduction(HttpServletRequest request, String userId) throws SQLException; 
	
}
