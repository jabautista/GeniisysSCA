package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWCargo;

public interface GIPIWCargoService {
	
	List<GIPIWCargo> getGipiWCargo(Integer parId) throws SQLException;
	//void saveGIPIParMarineCargo(List<GIPIWCargo> marineCargoParam,String[] delItemNos,Integer parId) throws SQLException;
	void saveGIPIParMarineCargo(Map<String, Object> params) throws SQLException;
	void saveGIPIEndtMarineCargo(Map<String, Object> params) throws SQLException, JSONException, ParseException;
	boolean saveMarineCargoItem(Map<String, Object> param) throws SQLException;
	boolean saveGIPIEndtMarineCargoItem(String parameters) throws JSONException, ParseException, SQLException;
	Map<String, Object> gipis068NewFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> newFormInstance(Map<String, Object> params) throws SQLException, JSONException;
	void saveGIPIWCargo(String param, GIISUser USER) throws SQLException, JSONException, ParseException;
	Map<String, Object> newFormInstanceTG(Map<String, Object> params) throws SQLException, JSONException;
}
