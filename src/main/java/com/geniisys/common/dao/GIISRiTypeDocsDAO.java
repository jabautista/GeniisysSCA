package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISRiTypeDocsDAO {

	void saveGiiss074(Map<String, Object> params) throws SQLException;
	String valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateRiType(Map<String, Object> params) throws SQLException;
}
