package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACBankDepSlipsService {

	/**
	 * Saves the GBDS/GBDS blocks in GIACS035 (Close DCB)
	 * @param parameters
	 * @param userId
	 * @return
	 * @throws JSONException
	 * @throws SQLException
	 * @throws ParseException
	 */
	String saveGbdsBlock(String parameters, String userId) throws JSONException, SQLException, ParseException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the GBDS/GBDS (Bank/Cash Deposit) block records in GIACS035
	 * @param params
	 * @param strParameters
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	Map<String, Object> getGbdsListTableGridMap(Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the 
	 *  GCDD (Cash Deposit Analysis - GIAC_CASH_DEP_DTL) block records in GIACS035
	 * @param params
	 * @param strParameters
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	Map<String, Object> getGcddListTableGridMap(Map<String, Object> params) throws SQLException, JSONException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the GBDSD (Deposit Slip Breakdown) block records in GIACS035
	 * @param params
	 * @param strParameters
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	Map<String, Object> getGbdsdListTableGridMapByGaccTranId(Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the GBDSD (Deposit Slip Breakdown) block records in GIACS035
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	Map<String, Object> getGbdsdListTableGridMap(Map<String, Object> params) throws SQLException, JSONException;
	
	/**
	 * Gets the map that will be used for the display of table grid for the ERROR (Cash Deposit Analysis) block records in GIACS035
	 * @param params
	 * @param strParameters
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	Map<String, Object> getGbdsdErrorListTableGridMap(Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException;
	
	JSONObject getGiacBankDepSlips(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getGiacCashDepDtl(HttpServletRequest request) throws SQLException, JSONException;
}
