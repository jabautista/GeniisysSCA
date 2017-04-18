package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISCoverageDAO {
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void saveGiiss113(Map<String, Object> params) throws SQLException;
}
