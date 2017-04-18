package com.geniisys.giex.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIEXSmsDtlDAO {

	Map<String, Object> checkSMSAssured(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkSMSIntm(Map<String, Object> params) throws SQLException;
	void updateSMSTags(Map<String, Object> params) throws SQLException;
	void sendSMS(Map<String, Object> params) throws SQLException;
	void saveSMS(Map<String, Object> params) throws SQLException;
	
}
