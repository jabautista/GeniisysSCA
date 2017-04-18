package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACDeferredDAO {
	
	String checkIss (Map<String, Object> params) throws SQLException;
	String checkIfDataExists (Map<String, Object> params) throws SQLException;
	String checkGenTag (Map<String, Object> params) throws SQLException;
	String checkStatus (Map<String, Object> params) throws SQLException;
	void setTranFlag (Map<String, Object> params) throws SQLException;
	String extractMethod (Map<String, Object> params) throws SQLException;
	String checkIfComputed (Map<String, Object> params) throws SQLException;
	String computeMethod (Map<String, Object> params) throws SQLException;
	String cancelAcctEnries (Map<String, Object> params) throws SQLException;
	String reversePostedTrans (Map<String, Object> params) throws SQLException;
	String generateAcctEntries (Map<String, Object> params) throws SQLException;
	String setGenTag (Map<String, Object> params) throws SQLException;
}

