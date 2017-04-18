package com.geniisys.giex.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIEXNewGroupTaxDAO {
	
	void saveGIEXNewGroupTax(Map<String, Object> params) throws SQLException;
	public void deleteModNewGroupTax(Map<String, Object> params) throws SQLException;
	String computeNewTaxAmt (Map<String, Object> params) throws SQLException;
}
