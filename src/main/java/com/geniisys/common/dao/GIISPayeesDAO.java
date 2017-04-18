package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISPayees;

public interface GIISPayeesDAO {
	List<Map<String, Object>> getPayeeByAdjusterListing(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getPayeeByAdjusterListing2(Map<String, Object> params) throws SQLException;
	List<GIISPayees> getPayeeMortgageeListing(Map<String, Object> params) throws SQLException;
	String getPayeeClassDesc(String payeeClassCd) throws SQLException;
	String getPayeeClassSlTypeCd(String payeeClassCd) throws SQLException;
	String getPayeeFullName(Map<String, Object>params) throws SQLException;
}
