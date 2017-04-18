package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACApdcPayt;

public interface GIACApdcPaytService {

	PaginatedList getApdcPaytListing(Map<String, Object> params) throws SQLException;
	Map<String, Object> popApdc(Map<String, Object> params) throws SQLException;
	Integer generateApdcId() throws SQLException;
	void saveAcknowledgmentReceipt(Map<String, Object> allParams) throws SQLException, JSONException, ParseException, Exception;
	String verifyApdcNo(Map<String, Object> params) throws SQLException;
	Integer getDocSeqNo(Map<String, Object> params) throws SQLException;
	void savePrintChanges(Map<String, Object> params) throws Exception;
	GIACApdcPayt getApdcPayt(Map<String, Object> params) throws SQLException;
	
	void showGIACApdcPayt(HttpServletRequest request, ApplicationContext appContext, String userId) throws SQLException, JSONException; 
	GIACApdcPayt getGIACApdcPayt(Integer apdcId) throws SQLException;	
	JSONObject getGIACApdcPaytListing(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getBreakdownAmounts(HttpServletRequest request) throws SQLException;
	void delGIACApdcPayt(Integer apdcId) throws SQLException;
	void saveGIACApdcPayt(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void cancelGIACApdcPayt(Integer apdcId, String userId) throws SQLException;
	void valDelApdc(HttpServletRequest request) throws SQLException;
}
