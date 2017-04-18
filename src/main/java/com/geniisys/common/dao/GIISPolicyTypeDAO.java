package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISPolicyTypeDAO {
	void saveGiiss091(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valTypeDesc(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
}
