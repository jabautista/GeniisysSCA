package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWCargoCarrier;

public interface GIPIWCargoCarrierService {

	List<GIPIWCargoCarrier> getGipiWCargoCarrier(Integer parId) throws SQLException;
	List<GIPIWCargoCarrier> prepareGIPIWCargoCarrierForInsert(JSONArray jsonArray) throws JSONException, ParseException;
	List<Map<String, Object>> prepareGIPIWCargoCarrierForDelete(JSONArray jsonArray) throws JSONException, ParseException;	
}
