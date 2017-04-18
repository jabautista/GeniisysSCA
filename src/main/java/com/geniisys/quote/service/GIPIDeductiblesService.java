package com.geniisys.quote.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GIPIDeductiblesService {

	String getDeductibleInfoGrid(HttpServletRequest request) throws SQLException, JSONException;
	String saveDeductibleInfo(String rowParams, Map<String, Object> params) throws JSONException, SQLException;
	String checkDeductibleText() throws SQLException;
	
}
