package com.geniisys.giri.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;


import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GIRIWFrpsRiService {

	String refreshGiriwFrpsRiGrid(HttpServletRequest request) throws SQLException, JSONException;
	String getWarrDays(HttpServletRequest request) throws SQLException;
	HashMap<String, Object> getWfrpRiParams(HashMap<String, Object> params) throws SQLException, JSONException;
	void saveRiAcceptance(String param, String userId) throws SQLException, JSONException, ParseException;
	String createBinderGiris002(Map<String, Object> params) throws SQLException;
	String computeRiPremAmt(HttpServletRequest request) throws SQLException;
	String computeRiPremVat1(HttpServletRequest request) throws SQLException;
	String saveRiPlacement(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String checkDelRecRiPlacement(String parameter) throws SQLException;
	String getPreviousRiGrid(HttpServletRequest request) throws SQLException, JSONException;
	String adjustPremVat(HttpServletRequest request) throws SQLException;
	String adjustPremVatGIRIS002(HttpServletRequest request) throws SQLException;
	String validateBinderPrinting(Map<String, Object> params) throws SQLException;
	String validateFrpsPosting(Map<String, Object> params) throws SQLException;
	Map<String, Object> getTsiPremAmt(Map<String, Object> params) throws SQLException;
	String validateSharePercent(HttpServletRequest request);
	String computeRiTsiAmt(HttpServletRequest request);
}
