package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISGroupDAO {

	void saveGiiss118(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
