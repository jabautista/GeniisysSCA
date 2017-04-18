package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIISTariffDAO {

	void saveGIISS005(Map<String, Object> params) throws SQLException, JSONException;
	void valAddRec(String tariffCd) throws SQLException;
	void valDeleteRec(String tariffCd) throws SQLException;
	
}
