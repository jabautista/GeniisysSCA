package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACSoaTitleDAO {

	void saveGiacs335(Map<String, Object> params) throws SQLException;
	String valDeleteRec(String recId) throws SQLException;
	String valAddRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateRepCd(Map<String, Object> params) throws SQLException;
}
