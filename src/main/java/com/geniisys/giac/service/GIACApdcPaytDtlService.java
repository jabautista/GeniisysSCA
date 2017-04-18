package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIACApdcPaytDtlService {

	Map<String, Object> getApdcPaytDtlTableGrid(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> gpdcPremPostQuery(Map<String, Object> params) throws SQLException;
	String checkGeneratedOR(Integer apdcId) throws SQLException;
	Integer generatePdcId() throws SQLException;
	Integer getApdcSw(Integer tranId) throws SQLException;
	
	//Dated Checks
	JSONObject showGiacs091(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiacs091(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveOrParticulars(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showDatedChecksDetails(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> multipleOR(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> groupOr(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validateDcbNo(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void createDbcNo(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> giacs091DefaultBank(HttpServletRequest request, String userId) throws SQLException, JSONException;
	List<Map <String, Object>> getGiacs091Funds(String userId) throws SQLException;
	String giacs091ValidateTransactionDate (Map<String, Object> params) throws SQLException;
	String giacs091CheckSOABalance(Map<String, Object> params) throws SQLException; /*added by MarkS SR-5881 12.14.2016*/
}

