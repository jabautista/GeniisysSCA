package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIPIRiskLossProfileDAO {
	void saveGIPIS902(Map<String, Object> params) throws SQLException, JSONException;
	void extractGIPIS902(Map<String, Object> params) throws SQLException;
}
