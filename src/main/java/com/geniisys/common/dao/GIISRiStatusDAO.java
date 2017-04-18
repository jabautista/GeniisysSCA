package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISRiStatusDAO {

	void saveGiiss073(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
