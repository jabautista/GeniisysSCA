package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

public interface GICLCatDtlService {
	Map<String, Object> getCatDtls(Map<String, Object> params) throws SQLException;
}
