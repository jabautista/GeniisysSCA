package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLRepairTypeDAO {

	void saveGicls172(Map<String, Object> params) throws SQLException;
	void valAddRec(String recId) throws SQLException;
	void valDelRec(String recId) throws SQLException;
}
