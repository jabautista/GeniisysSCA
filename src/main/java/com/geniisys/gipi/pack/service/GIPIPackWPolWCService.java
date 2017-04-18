package com.geniisys.gipi.pack.service;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

public interface GIPIPackWPolWCService {
	
	void saveGIPIPackWPolWC (JSONArray setRows, JSONArray delRows)
							throws SQLException, JSONException, Exception;
	
	public boolean saveGIPIPackWPolWC2(Map<String, Object> parameters) throws Exception;
	Map<String,Object> checkExistWPolwcPolWc(Map<String, Object> params) throws SQLException;
	//void copyPackPolWCGiuts008a(Map<String, Object> params) throws SQLException;
	
}
