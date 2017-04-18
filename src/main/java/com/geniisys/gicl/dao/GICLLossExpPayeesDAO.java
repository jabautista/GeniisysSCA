package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLLossExpPayeesDAO {
	Integer getPayeeClmClmntNo(Map<String, Object> params) throws SQLException;
	String validateAssdClassCd(Map<String, Object> params) throws SQLException;
}
