package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACTaxesDAO {

	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void saveGIACS320(Map<String, Object> params) throws SQLException;
	Integer checkAccountCode(Map<String, Object> params) throws SQLException;
	
}
