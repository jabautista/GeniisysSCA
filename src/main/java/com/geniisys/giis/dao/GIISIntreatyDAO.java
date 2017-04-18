package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISIntreatyDAO {
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void saveGiiss032(Map<String, Object> params) throws SQLException;
}
