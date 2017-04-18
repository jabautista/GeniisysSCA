package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;


public interface GIACBatchCheckDAO {
	
	Map<String, Object> getPrevExtractParams (Map<String, Object> params) throws SQLException;
	String extractBatchChecking (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalNet (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalGross (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalFacul (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalTreaty (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalOutstanding (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalPaid (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalGrossDtl (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalFaculDtl (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalTreatyDtl (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalOutstandingDtl (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalPaidDtl (Map<String, Object> params) throws SQLException;
	void checkRecords(Map<String, Object> params) throws SQLException;
	void checkDetails(Map<String, Object> params) throws SQLException;
}

