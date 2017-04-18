package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIISCityDAO {
	List<Map<String, Object>> getCityDtls(Map<String, Object> params) throws SQLException;
}
