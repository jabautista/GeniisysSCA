package com.geniisys.giex.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIEXNewGroupTaxService {
	
	void saveGIEXNewGroupTax(HttpServletRequest request, String userId) throws SQLException, JSONException;
	public void deleteModNewGroupTax(Map<String, Object> params) throws SQLException;
	String computeNewTaxAmt (HttpServletRequest request) throws SQLException;
}
