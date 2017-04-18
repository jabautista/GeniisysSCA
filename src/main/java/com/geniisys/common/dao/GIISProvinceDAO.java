package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIISProvinceDAO {
	List<Map<String, Object>> getProvinceDtls(Map<String, Object> params) throws SQLException;
}
