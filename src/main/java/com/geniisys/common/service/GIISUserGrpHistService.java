package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIISUserGrpHistService {

	Map<String, Object> getUserHistory(Map<String, Object> params) throws SQLException, JSONException;
}
