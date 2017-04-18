package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWCargo;

public interface GIPIWCargoDAO {
	
	List<GIPIWCargo> getGipiWCargo(Integer parId) throws SQLException;
	void saveGIPIParMarineCargo(Map<String, Object> params) throws SQLException;
	void saveGIPIEndtMarineCargo(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	boolean saveMarineCargoItem(Map<String, Object> param) throws SQLException;
	Map<String, Object> gipis068NewFormInstance(Map<String, Object> params) throws SQLException;
	Map<String, Object> gipis006NewFormInstance(Map<String, Object> params) throws SQLException;
	void saveGIPIWCargo(Map<String, Object> params) throws SQLException, JSONException;
}
