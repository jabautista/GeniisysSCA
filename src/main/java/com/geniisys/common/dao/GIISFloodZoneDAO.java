package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISFloodZoneDAO {

	void saveGiiss053(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
}
