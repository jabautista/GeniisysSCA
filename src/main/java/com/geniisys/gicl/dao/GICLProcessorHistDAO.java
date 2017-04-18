package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GICLProcessorHistDAO {
	List<Map<String, Object>> getProcessorHist(Map<String, Object> params) throws SQLException;
}
