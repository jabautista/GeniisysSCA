package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISBondClassClauseDAO {

	void saveGiiss099(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
