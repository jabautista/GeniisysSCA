package com.geniisys.giex.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.giex.entity.GIEXExpiry;

public interface GIEXBusinessConservationDAO {
	Map<String, Object> extractPolicies(Map<String, Object> params) throws SQLException;
	public List<GIEXExpiry> getBusConDetails(HashMap<String, Object> params) throws SQLException, JSONException;
	public List<GIEXExpiry> getBusConPackDetails(HashMap<String, Object> params) throws SQLException, JSONException;
}