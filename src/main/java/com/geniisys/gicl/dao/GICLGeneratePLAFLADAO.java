package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLGeneratePLAFLADAO {
	
	Map<String, Object> queryCountUngenerated(Map<String, Object> params) throws SQLException;
}
