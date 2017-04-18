package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACAmlaCoveredTransactionDAO {
	List<Map<String, Object>> getAmlaBranch(String userId) throws SQLException;
	List<Map<String, Object>> getAmlaRecords(Map<String, Object> params) throws SQLException;
	Map<String, Object> insertAmlaRecord(Map<String, Object> params) throws SQLException;
	String deleteAmlaRecord(String userId) throws SQLException;
}
