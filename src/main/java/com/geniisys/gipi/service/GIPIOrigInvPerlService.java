package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import org.json.JSONException;

public interface GIPIOrigInvPerlService {
	HashMap<String, Object> getGipiOrigInvPerl(HashMap<String, Object> params) throws SQLException, JSONException;
	
	HashMap<String, Object> getInvPerils(HashMap<String,Object> params) throws SQLException;
}
