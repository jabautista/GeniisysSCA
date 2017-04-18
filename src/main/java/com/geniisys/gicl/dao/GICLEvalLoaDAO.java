/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: GICLEvalLoaDAO.java
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

public interface GICLEvalLoaDAO {
	BigDecimal getTotalPartAmt(Map<String, Object>params)throws SQLException; 
	void generateLoa(List<Map<String, Object>> loaList, String userId) throws SQLException;
	String generateLoaFromLossExp(List<Map<String, Object>> loaList, String userId) throws SQLException, Exception;
}	
