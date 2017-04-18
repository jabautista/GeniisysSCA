package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISClassDAO {

	void saveGiiss063(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
	void valAddRec2(String recDesc) throws SQLException;
}
