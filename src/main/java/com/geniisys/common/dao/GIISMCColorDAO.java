package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISMCColorDAO {
	void saveGiiss114(Map<String, Object> params) throws SQLException;
	void valDeleteRecBasic(String recId) throws SQLException;
	void valDeleteRec(Integer recId) throws SQLException;
	void valAddRecBasic(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;	
}
