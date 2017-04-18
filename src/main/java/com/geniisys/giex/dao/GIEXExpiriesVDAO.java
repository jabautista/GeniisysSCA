package com.geniisys.giex.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giex.entity.GIEXExpiriesV;

public interface GIEXExpiriesVDAO {
	
	List<GIEXExpiriesV> getExpiredPolicies (HashMap<String, Object> params) throws SQLException;
	List<GIEXExpiriesV> getQueriedExpiredPolicies (HashMap<String, Object> params) throws SQLException;
	Map<String, Object> preFormGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> postQueryGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPolicyGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkRenewFlagGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> verifyOverrideRbGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> processPostButtonGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> processPostOnOverrideGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveProcessTagGIEXS004(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedNotParam(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedNotTime(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedOnBeforeMonth(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedOnBeforeDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedExactMonth(Map<String, Object> params) throws SQLException;
	Map<String, Object> purgeBasedExactDate(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkNoOfRecordsToPurge(Map<String, Object> params) throws SQLException;
	List<String> getPolicyIdGiexs006(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGiex004InitialVariables() throws SQLException;
	void giexs004ProcessPostButton(Map<String , Object>params) throws SQLException;
	void giexs004ProcessRenewal(Map<String, Object> params) throws SQLException;
	void giexs004ProcessPolicies(Map<String, Object> params) throws SQLException;
	String updateExpiryRecord(Map<String, Object> params) throws SQLException;
	String updateExpiriesByBatch(Map<String, Object> params) throws SQLException;
	Integer checkExtractUserAccess (Map<String, Object> params) throws SQLException;
	String checkRecords(Map<String, Object> params) throws SQLException;
	String checkSubline(Map<String, Object> params) throws SQLException;	
}
