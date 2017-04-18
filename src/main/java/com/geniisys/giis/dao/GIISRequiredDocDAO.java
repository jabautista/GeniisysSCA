package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIISRequiredDocDAO {
	void saveGIISRequiredDoc(Map<String, Object> params) throws SQLException, Exception;
	List<String> getCurrenDocCdList(Map<String, Object> params) throws SQLException;
	void saveGiiss035(Map<String, Object> params) throws SQLException;
	String valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGiiss035Line(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGiiss035Subline(Map<String, Object> params) throws SQLException;
}
