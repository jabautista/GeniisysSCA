package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

public interface GIISCityService {
	Map<String, Object> getCityDtls(Map<String, Object> params) throws SQLException;
}
