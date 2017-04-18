package com.geniisys.giac.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACOutFaculPremPaytsDAO {

	List<Map<String, Object>> getBinderList(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getBinderList2(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> validateBinderNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> getBreakdownAmts(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getAllOutFaculPremPayts(Map<String, Object> params) throws SQLException;
	void saveOutFaculPremPayts(Map<String, Object> allParams) throws SQLException;
	BigDecimal getDisbursementAmt(Map<String, Object> params) throws SQLException;
	Map<String, Object> getOverrideDisbursementAmt(Map<String, Object> params) throws SQLException;
	Map<String, Object> getRevertDisbursementAmt(Map<String, Object> params) throws SQLException;
	Map<String, Object> getFaculIssCdPremSeqNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> postFormsCommitOutFacul(Map<String, Object> params) throws SQLException;
	Map<String, Object> getOverrideDetails(Map<String, Object> params) throws SQLException; //added by steven 5.29.2012
	Map<String, Object> validateBinderNo2(Map<String, Object> params) throws SQLException;	// shan 09.16.2014
	Integer getNextRecordNo(Map<String, Object> params) throws SQLException; // SR-19631 : shan 08.17.2015
}
