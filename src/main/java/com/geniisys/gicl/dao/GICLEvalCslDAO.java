/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: GICLEvalCslDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 2, 2012
	Description: 
*/


package com.geniisys.gicl.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GICLEvalCslDAO {
	BigDecimal getTotalPartAmtCsl(Map<String, Object>params) throws SQLException;
	void generateCsl(List<Map<String, Object>> cslList, String userId) throws SQLException;
	String generateCslFromLossEx(List<Map<String, Object>> cslList, String userId) throws SQLException, Exception;
}
