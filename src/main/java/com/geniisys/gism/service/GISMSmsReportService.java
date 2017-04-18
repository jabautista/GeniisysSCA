package com.geniisys.gism.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface GISMSmsReportService {
	Map<String, Object> populateSmsReportPrint(HttpServletRequest request) throws SQLException;
	Map<String, Object> validateGisms012User(HttpServletRequest request) throws SQLException;
}
