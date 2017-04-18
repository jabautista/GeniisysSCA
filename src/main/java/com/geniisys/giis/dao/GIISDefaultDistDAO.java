package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIISDefaultDistDAO {

	void saveGiiss165(Map<String, Object> params) throws SQLException, JSONException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Integer defaultNo) throws SQLException;
	Map<String, Object> getDistPerilVariables(Map<String, Object> params) throws SQLException;
	void checkDistRecords(Map<String, Object> params) throws SQLException;
	
}