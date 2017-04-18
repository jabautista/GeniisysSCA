package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISMortgageeDAO {
	
	String validateAddMortgageeCd (Map<String, Object> params) throws SQLException;
	String validateAddMortgageeName(Map<String, Object> params) throws SQLException;
	String validateDeleteMortgagee (Map<String, Object> params) throws SQLException;
	String saveMortgagee(Map<String, Object> allParams) throws SQLException;
	
}
