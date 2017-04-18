package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import org.json.JSONException;

public interface GIPIOrigCommInvPerilService {
	HashMap<String, Object> getGipiOrigCommInvPeril(HashMap<String, Object> params) throws SQLException, JSONException;
	
	HashMap<String, Object> getCommInvPerils(HashMap<String, Object> params) throws SQLException;
}
