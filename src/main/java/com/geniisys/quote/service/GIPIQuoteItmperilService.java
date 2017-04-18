package com.geniisys.quote.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.quote.entity.GIPIQuoteItmperil;

public interface GIPIQuoteItmperilService {
	String savePerilInfo(String rowParams, Map<String, Object> params) throws JSONException, SQLException;
	List<GIPIQuoteItmperil> getItmperils(Map<String, Object> params) throws SQLException;
}
