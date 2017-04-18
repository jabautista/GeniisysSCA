package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLRepSignatoryDAO {

	void saveGicls181(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String reportId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
