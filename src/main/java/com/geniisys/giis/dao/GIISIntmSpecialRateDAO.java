package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIISIntmSpecialRateDAO {

	void populatePerils(Map<String, Object> params) throws SQLException;
	void copyIntmRate(Map<String, Object> params) throws SQLException;
	void saveGIISS082(Map<String, Object> params) throws SQLException, JSONException;
	String getPerilList(Map<String, Object> params) throws SQLException;
	
}
