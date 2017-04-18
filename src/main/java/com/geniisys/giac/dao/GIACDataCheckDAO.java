package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACDataCheckDAO {
	public List<Map<String, Object>> checkQuery (String month, String year, String query) throws SQLException;
	void patchRecords(Map<String, Object> params) throws SQLException; //mikel 06.20.2016; GENQA 5544
}
