package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISCaLocationDAO {
	void saveGiiss217(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
}
