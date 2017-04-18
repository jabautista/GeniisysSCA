package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISLossTaxesService {

	JSONObject showGicls106(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGicls106(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGicls106Tax(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGicls106Branch(HttpServletRequest request, String userId) throws SQLException;
	JSONObject showTaxRateHistory(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showCopyTax(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void copyTaxToIssuingSource(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validateGicls106LossTaxes(HttpServletRequest request) throws SQLException;
	JSONObject showLineLossExp(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveLineLossExp(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String valLineLossExp(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGicls106Line(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> validateGicls106LossExp(HttpServletRequest request) throws SQLException;
	JSONObject showLineLossExpHistory(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void copyTaxToIssuingSourceAndTaxLine(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> checkCopyTaxLineBtn(HttpServletRequest request, String userId) throws SQLException;
}
