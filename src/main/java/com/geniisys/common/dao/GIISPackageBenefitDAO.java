package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISPackageBenefitDAO {
	void saveGiiss120(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> param) throws SQLException;
	void valDeleteRec(Map<String, Object> param) throws SQLException;
}
