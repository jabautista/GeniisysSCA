package com.geniisys.quote.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIPIDeductiblesDAO {
	
	String saveDeductibleInfo(Map<String, Object> rowParams, Map<String, Object> params) throws SQLException;
	String checkDeductibleText() throws SQLException;
	
}
