package com.geniisys.common.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISCurrency;

public interface GIISCurrencyDAO {

	/**
	 * Gets the list of values for GIIS_CURRENCY
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	List<GIISCurrency> getGiisCurrencyLOV(String keyword) throws SQLException;
	
	/**
	 * Gets the list of values for CURRENCY LOV in GIACS035 (Close DCB)
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIISCurrency> getDCBCurrencyLOV(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the list of values for CURRENCY_SHORT_NAME LOV in GIACS035 (Close DCB)
	 * @param shortName
	 * @return
	 * @throws SQLException
	 */
	List<GIISCurrency> getCurrencyLOVByShortName(String shortName) throws SQLException;
	
	BigDecimal getCurrencyByShortname(String shortname) throws SQLException;
	
	String validateDeleteCurrency(Map<String, Object> params) throws SQLException;
	String validateMainCurrencyCd(Map<String, Object> params) throws SQLException;
	String validateShortName(Map<String, Object> params) throws SQLException;
	String validateCurrencyDesc(Map<String, Object> params) throws SQLException;
	String saveCurrency(Map<String, Object> allParams) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void saveGiiss009(Map<String, Object> params) throws SQLException;
}
