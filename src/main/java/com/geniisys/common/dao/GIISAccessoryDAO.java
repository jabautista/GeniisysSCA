package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISAccessoryDAO {
	void saveGiiss107(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Integer recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
