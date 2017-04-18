package com.geniisys.giri.service;

import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

public interface GIRIIntreatyService {
	JSONObject showIntreatyListing(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void getIntreatyListing(HttpServletRequest request) throws SQLException, Exception;
	String copyIntreaty(Integer intreatyId, String userId) throws SQLException, Exception;
	void approveIntreaty(HttpServletRequest request, String userId) throws SQLException, Exception;
	void cancelIntreaty(HttpServletRequest request, String userId) throws SQLException, Exception;
	void showCreateIntreaty(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, String userId) throws SQLException, Exception;
	JSONObject getIntreatyChargesTG(HttpServletRequest request) throws SQLException, JSONException;
	Integer saveIntreaty(String param, String userId) throws SQLException, Exception;
	void showInchargesTax(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, String userId) throws SQLException, Exception;
	JSONObject getInchargesTaxTG(HttpServletRequest request) throws SQLException, JSONException;
	void saveInchargesTax(String param, String userId) throws SQLException, Exception;
	void showViewIntreaty(HttpServletRequest request, ApplicationContext APPLICATION_CONTEXT, String userId) throws SQLException, Exception;
}
