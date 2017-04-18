package com.geniisys.giex.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIEXNewGroupDeductiblesDAO {
	
	void saveGIEXNewGroupDeductibles(Map<String, Object> params) throws SQLException;
	public void deleteModNewGroupDeductibles(Map<String, Object> params) throws SQLException;
	Integer validateIfDeductibleExists(Map<String, Object> params) throws SQLException;
	String countTsiDed (String policyId) throws SQLException;
	String getDeductibleCurrency (String policyId) throws SQLException;
}
