package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLReassignClaimRecordDAO {
	public String updateClaimRecord(Map<String, Object> params) throws SQLException;
	String checkIfCanReassignClaim(String userId) throws SQLException;
}
