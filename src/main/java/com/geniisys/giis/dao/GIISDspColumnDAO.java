package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISDspColumnDAO {
	void valAddRec(Map<String, Object> params) throws SQLException;
	void saveGiiss167(Map<String, Object> params) throws SQLException;
}
