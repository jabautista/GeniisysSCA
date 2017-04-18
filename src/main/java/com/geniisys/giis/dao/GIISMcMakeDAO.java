package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIISMcMakeDAO {

	void saveGIISS103(Map<String, Object> params) throws SQLException, JSONException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void saveGIISS103Engine(Map<String, Object> params) throws SQLException, JSONException;
	void valAddEngine(Map<String, Object> params) throws SQLException;
	void valDeleteEngine(Map<String, Object> params) throws SQLException;
	
}
