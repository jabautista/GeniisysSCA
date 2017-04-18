package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

public interface GIISProvinceService {
	Map<String, Object> getProvinceDtls(Map<String, Object> params) throws SQLException;
}
