package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISCargoClassDAO {
	void saveGiiss051(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Integer recId) throws SQLException;
	void valAddRec(Integer recId) throws SQLException;
}
