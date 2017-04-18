package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public interface GICLBiggestClaimDAO {

	Map<String, Object> whenNewFormInstanceGICLS220() throws SQLException;
	HashMap<String, Object> extractGICLS220(HashMap<String, Object> params) throws SQLException;
	String extractParametersExistGicls220(Map<String, Object> params) throws SQLException;
	
}
