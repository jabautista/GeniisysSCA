package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLClmAdjHistDAO {

	String getGiclClmAdjHistExist(String claimId) throws SQLException;
	String getDateCancelled(Map<String, Object> params) throws SQLException;
}
