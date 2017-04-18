package com.geniisys.common.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISCurrency;

import com.geniisys.framework.util.PaginatedList;


public interface GIISCurrencyService {

	/**
	 * Gets the list of values for GIIS_CURRENCY
	 * @param pageNo
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getGiisCurrencyLOV(Integer pageNo, String keyword) throws SQLException;
	
	/**
	 * Gets the list of values for CURRENCY LOV in GIACS035 (Close DCB)
	 * @param pageNo
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getDCBCurrencyLOV(Integer pageNo, Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the list of values for CURRENCY_SHORT_NAME LOV in GIACS035 (Close DCB)
	 * @param shortName
	 * @return
	 * @throws SQLException
	 */
	List<GIISCurrency> getCurrencyLOVByShortName(String shortName) throws SQLException;
	BigDecimal getCurrencyByShortname(String shortname) throws SQLException;
	
	JSONObject showCurrencyList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getAllMainCurrencyCd(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getAllShortName(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getAllCurrencyDesc(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String validateDeleteCurrency(HttpServletRequest request) throws SQLException;
	String validateMainCurrencyCd(HttpServletRequest request) throws SQLException;
	String validateShortName(HttpServletRequest request) throws SQLException;
	String validateCurrencyDesc(HttpServletRequest request) throws SQLException;
	String saveCurrency(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss009(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
