package com.geniisys.giex.dao;

import java.sql.SQLException;
import java.util.Map;


public interface GIEXItmperilDAO {
	
	public void deleteItmperilByPolId(Integer policyId) throws SQLException;
	Map<String, Object> deletePerilGIEXS007(Map<String, Object> params) throws SQLException;
	Map<String, Object> createPerilGIEXS007(Map<String, Object> params) throws SQLException, Exception;
	void saveGIEXItmperil(Map<String, Object> params) throws SQLException;
	Map<String, Object> computeTsiGIEXS007(Map<String, Object> params) throws SQLException;
	Map<String, Object> computePremiumGIEXS007(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateWitemGIEXS007(Map<String, Object> params) throws SQLException;
	public void deleteOldPEril(Map<String, Object> params) throws SQLException;
	String computeDeductibleAmt(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateItemperil(Map<String, Object> params) throws SQLException; //joanne 12-02-13
	Map<String, Object> deleteItemperil(Map<String, Object> params) throws SQLException; //joanne 12-05-13	
}
