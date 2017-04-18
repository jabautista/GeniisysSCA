package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;


public interface GIISDefaultOneRiskDAO {
	void valAddDefaultDistRec(Map<String, Object> params) throws SQLException;
	void valDelDefaultDistRec(Map<String, Object> params) throws SQLException;
	void saveGiiss065(Map<String, Object> params) throws SQLException;
	void valExistingDistPerilRecord(Map<String, Object> params) throws SQLException;
	void valAddDefaultDistGroupRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateSaveExist(Map<String, Object> params) throws SQLException;
	Integer getMaxSequencNo(Integer defaultNo) throws SQLException;
	
}
