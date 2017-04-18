package com.geniisys.giuw.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giuw.dao.PostDistributionDAO;
import com.geniisys.giuw.service.PostDistributionService;

public class PostDistributionServiceImpl implements PostDistributionService{

	private PostDistributionDAO postDistributionDAO;
	
	public void setPostDistributionDAO(PostDistributionDAO postDistributionDAO) {
		this.postDistributionDAO = postDistributionDAO;
	}

	public PostDistributionDAO getPostDistributionDAO() {
		return postDistributionDAO;
	}

	@Override
	public String postBatchDistribution(Map<String, Object> params)
			throws SQLException, Exception {
		return this.getPostDistributionDAO().postBatchDistribution(params);
	}

}
