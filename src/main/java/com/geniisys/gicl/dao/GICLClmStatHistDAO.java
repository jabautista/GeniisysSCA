package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GICLClmStatHistDAO {
	List<Map<String, Object>> getClmStatHistory(Map<String, Object> params) throws SQLException;
}
