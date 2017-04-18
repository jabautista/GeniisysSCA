package com.geniisys.giuw.service;

import java.sql.SQLException;
import java.util.Map;

public interface PostDistributionService {
	
	String postBatchDistribution(Map<String, Object> params) throws SQLException, Exception;
	
}
