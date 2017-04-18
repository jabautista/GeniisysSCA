package com.geniisys.giuw.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giuw.exceptions.PostingDistributionException;

public interface PostDistributionDAO {
	
	String postBatchDistribution(Map<String, Object> params) throws SQLException, PostingDistributionException, Exception;

}
