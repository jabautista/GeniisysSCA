package com.geniisys.giuts.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public interface CopyUtilitiesDAO {

	HashMap<String, Object> summarizePolToPar(HashMap<String, Object> params) throws SQLException;
	void checkIfPolicyExists(Map<String, Object> params) throws SQLException;
	void checkPolicy(Map<String, Object> params) throws SQLException;
	void validateLine(Map<String, Object> params) throws SQLException;
	void validateIssCd(Map<String, Object> params) throws SQLException;
	// GIUTS008A start
	String validateLineCdGiuts008a(Map<String, Object> params) throws SQLException;
	String validateIssCdGiuts008a(Map<String, Object> params) throws SQLException;
	HashMap<String, Object> copyPackPolicyGiuts008a(HashMap<String, Object> params) throws SQLException;
	void validateParIssCd(HashMap<String, Object> params) throws SQLException;
}
