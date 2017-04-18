package com.geniisys.gism.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GISMSmsReportDAO {
	Map<String, Object> populateSmsReportPrint(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateGisms012User(Map<String, Object> params) throws SQLException;
}
