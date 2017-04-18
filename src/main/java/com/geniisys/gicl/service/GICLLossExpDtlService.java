package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GICLLossExpDtlService {
	String validateLossExpDtlDelete(Map<String, Object> params) throws SQLException;
	String validateLossExpDtlAdd(Map<String, Object> params) throws SQLException;
	String validateLossExpDtlUpdate(Map<String, Object> params) throws SQLException;
	String computeDepreciation(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	String checkExistLossDtlAllWTax(Map<String, Object> params) throws SQLException;
	String clearLossExpenseDeductibles(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Map<String, Object> validateSelectedLEDeductible(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Map<String, Object> getLossExpDeductibleAmts(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	String validateLossExpDeductibleDelete(Map<String, Object> params) throws SQLException;
	String validateLossExpDeductibleUpdate(Map<String, Object> params) throws SQLException;
	void saveLossExpDeductibles(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	Map<String, Object> checkLOAOverrideRequestExist(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
	void createLOAOverrideRequest(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
}
