package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

public interface GICLPrintPLAFLAService {

	Map<String, Object> queryCountLossAdvice(HttpServletRequest request, String userId) throws SQLException;
	String tagPlaAsPrinted(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
	String tagFlaAsPrinted(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception;
}
