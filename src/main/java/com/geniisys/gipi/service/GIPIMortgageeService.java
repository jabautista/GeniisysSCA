package com.geniisys.gipi.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIPIMortgageeService {
	
	HashMap<String, Object> getMortgageeList(HashMap<String, Object> params) throws SQLException;
	
	HashMap<String, Object> getItemMortgagees(HashMap<String, Object> params) throws SQLException;
	
	JSONObject getMortgageesTableGrid(HttpServletRequest request) throws SQLException, JSONException;
	
	BigDecimal getPerItemAmount(HttpServletRequest request) throws SQLException, JSONException; //kenneth SR 5483 05.26.2016
	
	String getPerItemMortgName(HttpServletRequest request) throws SQLException, JSONException; //Mark SR 5483,2743,3708 09.07.2016

}
