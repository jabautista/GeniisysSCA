package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLMcDepreciationDAO {
	void saveGicls059(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
