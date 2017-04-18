package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIACCheckNoDAO {

	void checkBranchForCheck(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valDelRec(Map<String, Object> params) throws SQLException;
	void saveGIACS326(Map<String, Object> params) throws SQLException, JSONException;
	
}
