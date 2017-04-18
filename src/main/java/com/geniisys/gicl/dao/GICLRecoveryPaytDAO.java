package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface GICLRecoveryPaytDAO {

	Map<String, Object> cancelRecoveryPayt(Map<String, Object> params) throws SQLException;
	void saveGICLAcctEntries(Map<String, Object> params) throws SQLException;
	Map<String, Object> generateRecAcctInfo (Map<String, Object> params) throws SQLException;
	String generateRecovery(Map<String, Object> params) throws SQLException;
	String aegParameterGICLS055(Map<String, Object> params) throws SQLException;
	void setRecoveryAcct(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkRecoveryValidPayt(Map<String, Object> params) throws SQLException;
	Map<String, Object> getRecAEAmountSum(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getRecoveryAccts(Map<String, Object> params) throws SQLException;
	
}
