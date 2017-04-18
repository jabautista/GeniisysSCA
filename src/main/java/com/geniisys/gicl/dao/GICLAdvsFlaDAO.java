package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLAdvsFlaDAO {
	String generateFLA(Map<String, Object> params) throws SQLException;
	Integer getAdvFlaId() throws SQLException;
	Map<String, Object> cancelFla(Map<String, Object> params) throws SQLException;
	void updateFla(Map<String, Object> params) throws SQLException;
	String validatePdFla(Map<String, Object> params) throws SQLException;
	void updateFlaPrintSw(Map<String, Object> params) throws SQLException;
}
