package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.entity.GICLRecoveryRids;

public interface GICLRecoveryRidsDAO {
	GICLRecoveryRids getFlaRecovery(Map<String, Object> params) throws SQLException;
	void updGiclRecovRids(Map<String, Object> params) throws SQLException;
	void delGiclRecovRids(Map<String, Object> params) throws SQLException;
}
