package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIMainCoIns;

public interface GIPIMainCoInsDAO {

	GIPIMainCoIns getPolicyMainCoIns(Integer policyId) throws SQLException;
	// shan 10.21.2013
	String limitEntryGIPIS154(Map<String, Object> params) throws SQLException;
}
