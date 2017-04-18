package com.geniisys.giis.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISMortgageeService {
	
	JSONObject showMortgageeMaintenance(HttpServletRequest request) throws SQLException, JSONException;
	String validateAddMortgageeCd(HttpServletRequest request) throws SQLException;
	String validateAddMortgageeName(HttpServletRequest request) throws SQLException;
	String validateDeleteMortgagee(HttpServletRequest request) throws SQLException;
	String saveMortgagee(HttpServletRequest request, String userId) throws SQLException, JSONException;

}
