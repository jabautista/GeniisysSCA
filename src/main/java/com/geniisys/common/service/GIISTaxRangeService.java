package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISTaxRangeService {
	JSONObject showTaxRange(HttpServletRequest request, String userId) throws SQLException, JSONException; 
	void saveGiiss028TaxRange(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
