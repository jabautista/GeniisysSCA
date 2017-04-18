package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACTaxPaymentsService {

	JSONObject showTaxPayments(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> getGIACS021Variables(Integer gaccTranId) throws SQLException;
	List<Integer> getGIACS021Items(Integer gaccTranId) throws SQLException;
	void saveTaxPayments(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}