package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISNotaryPublicDAO {
	
	void saveGiiss016(Map<String, Object> params) throws SQLException;
	void giiss016ValDelRec(String npNo) throws SQLException;
	
}
