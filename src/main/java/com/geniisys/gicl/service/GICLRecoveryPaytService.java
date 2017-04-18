package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;

public interface GICLRecoveryPaytService {

	void gicl055NewFormInstance(HttpServletRequest request, GIISUser USER, ApplicationContext appContext) throws SQLException, JSONException;
	void getRecoveryPaytListing(HttpServletRequest request, Map<String, Object> recAcct, String userId) throws SQLException, JSONException;
	void getGiclDistributions(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void getGiclRiDistributions(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> cancelRecoveryPayt(Map<String, Object> params) throws SQLException;
	void getRecAcctEntries(HttpServletRequest request, String userId, ApplicationContext appContext) throws SQLException, JSONException;
	void saveGICLAcctEntries(JSONObject objParams, String userId) throws SQLException, JSONException;
	Map<String, Object> generateRecAcctInfo (Map<String, Object> params) throws SQLException;
	String generateRecovery(JSONObject obj, String userId) throws SQLException, JSONException;
	void setRecoveryAcct(JSONObject obj, String userId) throws SQLException, JSONException, ParseException;
	String checkRecoveryValidPayt(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getGiclRecoveryPaytGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getGiclRecoveryRidsGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Map<String, Object> getRecAEAmountSum (Map<String, Object> params) throws SQLException; /* benjo 08.27.2015 UCPBGEN-SR-19654 */
}
