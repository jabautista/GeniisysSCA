package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACCommSlipExtService {

	void populateBatchCommSlip(HttpServletRequest request) throws SQLException;
	JSONObject getBatchCommSlip(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> getCommSlipNo(HttpServletRequest request, String userId) throws SQLException;
	void tagAll(HttpServletRequest request) throws SQLException, JSONException;
	void untagAll() throws SQLException;
	Map<String, Object> generateCommSlipNo(HttpServletRequest request) throws SQLException;
	void saveGenerateFlag(HttpServletRequest request) throws SQLException, JSONException;
	List<Map<String, Object>> getBatchCommSlipReports() throws SQLException;
	Map<String, Object> updateCommSlip(HttpServletRequest request, String userId) throws SQLException;
	void clearCommSlipNo(HttpServletRequest request) throws SQLException;
	
}
