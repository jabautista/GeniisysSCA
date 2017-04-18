package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISPositionDAO {

	void saveGiiss023(Map<String, Object> params) throws SQLException;
	String valDeleteRec(String recId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
