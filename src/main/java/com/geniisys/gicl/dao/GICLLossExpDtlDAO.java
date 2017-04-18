package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLLossExpDtlDAO {
	String validateLossExpDtlDelete(Map<String, Object> params) throws SQLException;
	String validateLossExpDtlAdd(Map<String, Object> params) throws SQLException;
	String validateLossExpDtlUpdate(Map<String, Object> params) throws SQLException;
	String computeDepreciation(Map<String, Object> params) throws SQLException, Exception;
	String checkExistLossDtlAllWTax(Map<String, Object> params) throws SQLException;
	String clearLossExpenseDeductibles(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> validateSelectedLEDeductible(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> getLossExpDeductibleAmts(Map<String, Object> params) throws SQLException, Exception;
	String validateLossExpDeductibleDelete(Map<String, Object> params) throws SQLException;
	String validateLossExpDeductibleUpdate(Map<String, Object> params) throws SQLException;
	void saveLossExpDeductibles(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> checkLOAOverrideRequestExist(Map<String, Object> params) throws SQLException, Exception;
	void createLOAOverrideRequest(Map<String, Object> params) throws SQLException, Exception;
}
