package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

public interface GIISSlidCommDAO {

	void checkRate(Map<String, Object> params) throws SQLException;
	void saveGIISS220(Map<String, Object> params) throws SQLException, JSONException;
	List<Map<String, Object>> getRateList(Map<String, Object> params) throws SQLException;
	
}
