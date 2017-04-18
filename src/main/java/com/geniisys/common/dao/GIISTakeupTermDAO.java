package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISTakeupTermDAO {

	void saveGiiss211(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String takeupTerm) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
