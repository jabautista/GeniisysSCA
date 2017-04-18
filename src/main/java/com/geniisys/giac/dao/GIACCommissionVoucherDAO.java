package com.geniisys.giac.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

public interface GIACCommissionVoucherDAO {
	Map<String, Object> getGIACS155CommInvoiceDetails(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGIACS155CommPayables(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateGIACS155CommVoucherExt(Map<String, Object> params) throws SQLException;
	String getGIACS155GrpIssCd(String userId, String repId) throws SQLException;
	void GIACS155SaveCVNo(Map<String, Object> params) throws SQLException;
	void GIACS155RemoveIncludeTag(String userId) throws  SQLException;
	
	void populateBatchCV(Map<String, Object> params) throws SQLException;
	Map<String, Object> getCVSeqNo(Map<String, Object> params) throws SQLException;
	void clearTempTable() throws SQLException;
	void saveGenerateFlag(Map<String, Object> params) throws SQLException, JSONException;
	void generateCVNo(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getBatchReports() throws SQLException;
	void tagAll(Map<String, Object> params) throws SQLException;
	void untagAll() throws SQLException;
	Map<String, Object> updateTags(Map<String, Object> params) throws SQLException;
	String checkPolicyStatus(Map<String, Object> params) throws SQLException;
	
	// start AFP SR-18481 : shan 05.21.2015
	List<Map<String, Object>> getGIACS251FundList() throws SQLException;
	BigDecimal getCommDueTotal(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getCommDueListByParam(Map<String, Object> params) throws SQLException;
	Map<String, Object> generateCVNoCommDue(Map<String, Object> params) throws SQLException;
	void updateCommDueCVToNull(Map<String, Object> params) throws SQLException;
	Map<String, Object> getCommDueDtlTotals(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateCommDueTags(Map<String, Object> params) throws SQLException;
	Integer getNullCommDueCount(String bankFileNo) throws SQLException;
	// end AFP SR-18481 : shan 05.21.2015
	
	Map<String, Object> getTotalForPrintedCV(Map<String, Object> params) throws SQLException;
}
