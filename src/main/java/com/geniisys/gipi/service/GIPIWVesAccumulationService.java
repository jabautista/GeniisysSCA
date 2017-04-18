package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWVesAccumulation;

public interface GIPIWVesAccumulationService {
	List<GIPIWVesAccumulation> getGIPIWVesAccumulation(Integer parId) throws SQLException;
	List<Map<String, Object>> prepareGIPIWVesAccumulationForDelete(JSONArray delRows) throws JSONException; 
}
