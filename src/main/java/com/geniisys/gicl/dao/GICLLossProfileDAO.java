package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

public interface GICLLossProfileDAO {

	Map<String, Object> whenNewFormInstance() throws SQLException;
	void saveProfile(Map<String, Object> params) throws SQLException, ParseException;
	Map<String, Object> extractLossProfile(Map<String, Object> params) throws SQLException;
	String checkRecovery(Integer claimId) throws SQLException;
	
	void validateRange(Map<String, Object> params) throws SQLException;
}
