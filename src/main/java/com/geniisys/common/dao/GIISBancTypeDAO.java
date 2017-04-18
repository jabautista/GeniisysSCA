package com.geniisys.common.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Map;

public interface GIISBancTypeDAO {

	void valAddRec(String recId) throws SQLException;
	void valAddDtl(Map<String, Object> params) throws SQLException;
	void saveGiiss218(Map<String, Object> params) throws SQLException;
	BigDecimal getBancTypeDtlTotal(Map<String, Object> params) throws SQLException;
	
}
