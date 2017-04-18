package com.geniisys.giex.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIEXNewGroupDeductiblesService {
	
	void saveGIEXNewGroupDeductibles(HttpServletRequest request, String userId) throws SQLException, JSONException;
	public void deleteModNewGroupDeductibles(Map<String, Object> params) throws SQLException;
	Integer validateIfDeductibleExists(HttpServletRequest request) throws SQLException;
	String countTsiDed (String policyId) throws SQLException;
	String getDeductibleCurrency (String policyId) throws SQLException;
}
