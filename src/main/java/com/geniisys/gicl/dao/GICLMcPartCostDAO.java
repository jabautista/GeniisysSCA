package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLMcPartCostDAO {

	void saveGicls058(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	String checkModelYear(Map<String, Object> params) throws SQLException;
}
