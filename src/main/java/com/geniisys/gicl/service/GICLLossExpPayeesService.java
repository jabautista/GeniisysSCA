package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

public interface GICLLossExpPayeesService {
	Integer getPayeeClmClmntNo(Map<String, Object> params) throws SQLException;
	String validateAssdClassCd(Map<String, Object> params) throws SQLException;
}
