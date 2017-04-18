package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giac.entity.GIACTranMm;

public interface GIACTranMmService {
	
	List<GIACTranMm> getClosedTransactionMonthYear(Map<String, Object> params) throws SQLException;
	String checkBookingDate(HttpServletRequest request) throws SQLException;
	String getClosedTag(Map<String, Object> params) throws SQLException;
	
	// shan 12.12.2013
	JSONObject showGiacs038(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiacs038(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String checkFunctionGiacs038(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Integer getNextTranYrGiacs038(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Integer checkTranYrGiacs038(HttpServletRequest request) throws SQLException, JSONException;
	String generateTranMmGiacs038(HttpServletRequest request, String userId) throws SQLException;
	JSONObject getTranMmStatHistGiacs038(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getClmTranMmStatHistGiacs038(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
