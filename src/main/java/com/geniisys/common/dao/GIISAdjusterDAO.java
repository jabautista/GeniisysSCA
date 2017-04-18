package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISAdjusterDAO {

	void saveGicls210(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	Integer getLastPrivAdjNo(Integer adjCompanyCd) throws SQLException;
}
