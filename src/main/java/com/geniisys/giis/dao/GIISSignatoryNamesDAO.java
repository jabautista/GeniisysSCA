package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISSignatoryNamesDAO {
	
	Integer getSignatoryNamesNoSeq() throws SQLException;
	void saveGiiss071(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String signatoryId) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valUpdateRec(Map<String, Object> params) throws SQLException;
	void updateFilename(Map<String, Object> params) throws SQLException;
	String getFilename(Integer signatoryId) throws SQLException;
}
