package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISAirTypeDAO {

	void saveGiiss048(Map<String, Object> params) throws SQLException;
	String valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
