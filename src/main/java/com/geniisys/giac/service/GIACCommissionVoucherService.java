package com.geniisys.giac.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACCommissionVoucherService {
	JSONObject populateCommVoucherTableGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getGIACS155CommInvoiceDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject populateCommInvoiceTableGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	JSONObject getGIACS155CommPayables(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getGIACS155CommPayments(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject updateGIACS155CommVoucherExt(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String getGIACS155GrpIssCd(String userId, String repId) throws SQLException;
	void GIACS155SaveCVNo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void GIACS155RemoveIncludeTag(GIISUser USER) throws SQLException;
	
	void populateBatchCV(HttpServletRequest request) throws SQLException;
	JSONObject getBatchCV(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> getCVSeqNo(HttpServletRequest request, String userId) throws SQLException;
	JSONObject getCvDetails(HttpServletRequest request) throws SQLException, JSONException;
	void clearTempTable() throws SQLException;
	void saveGenerateFlag(HttpServletRequest request) throws SQLException, JSONException;
	void generateCVNo(HttpServletRequest request) throws SQLException;
	List<Map<String, Object>> getBatchReports() throws SQLException;
	void tagAll(HttpServletRequest request) throws SQLException, JSONException;
	void untagAll() throws SQLException;
	Map<String, Object> updateTags(HttpServletRequest request, String userId) throws SQLException, JSONException; 
	String checkPolicyStatus(HttpServletRequest request) throws SQLException;
	
	// start AFP SR-18481 : shan 05.21.2015
	JSONObject getCommDueList(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getGIACS251Fund() throws SQLException, JSONException;
	BigDecimal getCommDueTotal(HttpServletRequest request) throws SQLException, JSONException;
	JSONArray getCommDueListByParam(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject generateCVNoCommDue(HttpServletRequest request) throws SQLException, JSONException;
	void updateCommDueCVToNull(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getCommDueDtlTotals(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> updateCommDueTags(HttpServletRequest request, String userId) throws SQLException, JSONException; 
	Integer getNullCommDueCount(HttpServletRequest request) throws SQLException;
	// end AFP SR-18481 : shan 05.21.2015
	
	JSONObject getTotalForPrintedCV(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
