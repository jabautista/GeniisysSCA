package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIISControlTypeDAO {

	void saveGIISS108(Map<String, Object> params) throws SQLException, JSONException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDelRec(String controlTypeCd) throws SQLException;
	
}
