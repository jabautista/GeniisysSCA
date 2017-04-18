package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIQuoteCosign;

public interface GIPIQuoteCosignService {

	List<GIPIQuoteCosign> getGIPIQuoteCosigns(Integer quoteId) throws SQLException;
	List<GIPIQuoteCosign> prepareGIPIQuoteCosignJSON(JSONArray rows, String userId) throws JSONException;
}
