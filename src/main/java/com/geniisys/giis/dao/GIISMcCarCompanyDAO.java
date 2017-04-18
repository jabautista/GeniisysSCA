package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISMcCarCompanyDAO {

	void saveGiiss115(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Integer recId) throws SQLException;
	void valAddRec(Map <String, Object> params) throws SQLException; // carlo  - 08052015 - SR 19241
	
}
