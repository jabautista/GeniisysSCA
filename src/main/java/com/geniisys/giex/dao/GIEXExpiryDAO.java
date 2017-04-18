package com.geniisys.giex.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giex.entity.GIEXExpiry;

public interface GIEXExpiryDAO {

	Map<String, Object> getLastExtractionHistory(Map<String, Object> params) throws SQLException;
	Map<String, Object> extractExpiringPolicies(Map<String, Object> params) throws SQLException;
	Map<String, Object> extractExpiringPoliciesFinal(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateBalanceClaimFlag(Map<String, Object> params) throws SQLException;
	Map<String, Object> arValidationGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateF000Field(Map<String, Object> params) throws SQLException;
	GIEXExpiry getGIEXS007B240Info(Map<String, Object> params) throws SQLException;
	String checkRecordUser(Map<String, Object> params) throws SQLException;
	List<String> getRenewalNoticePolicyId(Map<String, Object> params) throws SQLException;
	String checkPolicyIdGiexs006(Integer policyId) throws SQLException;
	void generateRenewalNo(Map<String, Object> params) throws Exception;
	void generatePackRenewalNo(Map<String, Object> params) throws Exception;
	Integer checkGenRnNo(Map<String, Object> params) throws SQLException;
	String checkRecordUserNr(Map<String, Object> params) throws SQLException;
	String getGiispLineCdGiexs006(String param) throws SQLException;
	String changeIncludePackValue(String lineCd) throws SQLException;
	void updatePrintTag(Map<String, Object> params) throws SQLException;
	
}
