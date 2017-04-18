package com.geniisys.giuts.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public interface ExtractExpiringCovernoteDAO {

	Map<String, Object> whenNewFormInstanceGIUTS031(Map<String, Object> params) throws SQLException;
	HashMap<String, Object> extractGIUTS031(HashMap<String, Object> params) throws SQLException;
	Map<String, Object> validateExtractParameters(Map<String, Object> params) throws SQLException;
}
