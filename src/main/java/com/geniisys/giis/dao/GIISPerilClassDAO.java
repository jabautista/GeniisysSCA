package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIISPerilClassDAO {
	void savePerilClass(Map<String, Object> params) throws SQLException, Exception;
	List<Map<String, Object>> getAllPerilsPerClassDetails(Map<String, Object> params)throws SQLException, Exception;
}
