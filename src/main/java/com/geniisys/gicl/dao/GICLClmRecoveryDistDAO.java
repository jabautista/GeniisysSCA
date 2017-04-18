package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLClmRecoveryDistDAO {
	
	void distributeRecovery(Map<String, Object> params) throws SQLException;
	void negateDistRecovery(Map<String, Object> params) throws SQLException;
	String saveRecoveryDist(Map<String, Object> params) throws SQLException;
}
