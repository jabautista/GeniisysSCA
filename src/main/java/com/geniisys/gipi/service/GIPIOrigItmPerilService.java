package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;
import org.json.JSONException;

public interface GIPIOrigItmPerilService {
	
	HashMap<String, Object> getGipiOrigItmPerilList(HashMap<String,Object> params) throws SQLException, JSONException;
	
	HashMap<String, Object> getOrigItmPerils(HashMap<String, Object> params) throws SQLException;
}
