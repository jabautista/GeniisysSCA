package com.geniisys.giuw.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

public interface GIUWWitemdsService {
	
	HashMap<String, Object> getGiuwWitemdsForDistrFinal(HashMap<String, Object> params) throws SQLException, JSONException;
	List<Map<String, Object>>   getGiuwWitemdsOthPgeDistGrps (HashMap<String, Object> params) throws SQLException; // added by jhing 12.05.2014
}
