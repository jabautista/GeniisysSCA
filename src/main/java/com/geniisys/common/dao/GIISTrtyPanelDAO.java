package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISTrtyPanelDAO {

	void saveGiiss031(Map<String, Object> params, Map<String, Object> paramsRecompute) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGiiss031Reinsurer(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGiiss031ParentRi(Map<String, Object> params) throws SQLException;
	void valAddNpRec(Map<String, Object> params) throws SQLException;
	void saveGiiss031Np(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
}
