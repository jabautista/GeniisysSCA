package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISIndustryGroupDAO {
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void saveGiiss205(Map<String, Object> params) throws SQLException;
}
