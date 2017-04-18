package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISSplOverrideRtDAO {

	String getGiiss202SelectedPerils(Map<String, Object> params) throws SQLException, Exception;
	void saveGiiss202(Map<String, Object> params) throws SQLException;
	void populateGiiss202(Map<String, Object> params) throws SQLException;
	void copyGiiss202(Map<String, Object> params) throws SQLException;
}
