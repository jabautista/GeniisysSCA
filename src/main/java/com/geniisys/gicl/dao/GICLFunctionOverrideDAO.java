package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLFunctionOverrideDAO {

	public void updateFunctionOverride(Map<String, Object> params) throws SQLException;
}
