package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISBinderStatusDAO {
	
	void saveGiiss209(Map<String, Object> params) throws SQLException;
	void valAddBinderStatus(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
}
