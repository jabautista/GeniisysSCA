package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIPIRefNoHistDAO {

	Map<String, Object> generateBankRefNo(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> generateCSV(Map<String, Object> params) throws SQLException;
	
}
