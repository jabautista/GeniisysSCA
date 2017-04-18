package com.geniisys.gicl.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Map;

public interface GICLAdvLineAmtDAO {

	BigDecimal getRangeTo(Map<String, Object> params) throws SQLException;
	
	// shan 11.27.2013
	void saveGicls182(Map<String, Object> params) throws SQLException;
}
