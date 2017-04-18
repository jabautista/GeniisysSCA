package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACRecapDtlExtDAO {

	Map<String, Object> getRecapVariables() throws SQLException;
	void extractRecap(Map<String, Object> params) throws SQLException;
	Integer checkDataFetched() throws SQLException;
	
}
