package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIUWReportsParam;

public interface GIPIWReportsExtService {
	String checkUwReportsEdst(Map<String, Object> params) throws SQLException;
	String checkUwReports(Map<String, Object> params) throws SQLException;
	String checkUwReportsDist(Map<String, Object> params) throws SQLException;
	String checkUwReportsOutward(Map<String, Object> params) throws SQLException;
	String checkUwReportsPerPeril(Map<String, Object> params) throws SQLException;
	String checkUwReportsPerAssd(Map<String, Object> params) throws SQLException;
	String checkUwReportsInward(Map<String, Object> params) throws SQLException;
	String checkUwReportsPolicy(Map<String, Object> params) throws SQLException;
	
	String extractUWReports(Map<String, Object> params) throws SQLException;
	String extractUWReportsDist(Map<String, Object> params) throws SQLException;
	String extractUWReportsOutward(Map<String, Object> params) throws SQLException;
	String extractUWReportsPerPeril(Map<String, Object> params) throws SQLException;
	String extractUWReportsPerAssd(Map<String, Object> params) throws SQLException;
	String extractUWReportsInward(Map<String, Object> params) throws SQLException;
	String extractUWReportsPolicy(Map<String, Object> params) throws SQLException;
	
	String validatePrintPolEndt(Map<String, Object> params) throws SQLException;
	String validatePrintAssd(Map<String, Object> params) throws SQLException;
	String validatePrint(Map<String, Object> params) throws SQLException;
	String validatePrintOutwardInwardRI(Map<String, Object> params) throws SQLException;
	
	Integer countNoShareCd(Map<String, Object> params) throws SQLException;
	
	GIPIUWReportsParam getLastExtractParams(Map<String, Object> params) throws SQLException;
	Integer getParamDate(String userId) throws SQLException;
	Map<String, Object> validateCedant(Map<String, Object> params) throws SQLException;
}
