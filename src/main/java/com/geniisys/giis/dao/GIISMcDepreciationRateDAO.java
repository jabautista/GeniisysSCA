package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISMcDepreciationRateDAO {
	
	String saveMcDr(Map<String, Object> allParams) throws SQLException;
	String validateAddMcDepRate(Map<String, Object> params) throws SQLException;
	String validateMcPerilRec(Map<String, Object> params) throws SQLException;
	String deleteMcPerilRec(Map<String, Object> params) throws SQLException;	
	String savePerilDepRate (Map<String, Object> allParams) throws SQLException;		
}
