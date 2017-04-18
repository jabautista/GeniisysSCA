package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISS219DAO {
	void saveGiiss219(Map<String, Object> params) throws SQLException, Exception;
	void valDeleteRec(Map<String, Object> param) throws SQLException;
	void valAddRec(Map<String, Object> param) throws SQLException;
}
