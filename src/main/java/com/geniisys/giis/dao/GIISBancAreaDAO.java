package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISBancAreaDAO {
	
	void saveGiiss215(Map<String, Object> params) throws SQLException;
	void giiss215ValAddRec(Map<String, Object> params) throws SQLException;
}
