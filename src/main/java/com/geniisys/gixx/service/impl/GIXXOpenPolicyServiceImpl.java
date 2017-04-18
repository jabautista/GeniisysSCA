package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXOpenPolicyDAO;
import com.geniisys.gixx.entity.GIXXOpenPolicy;
import com.geniisys.gixx.service.GIXXOpenPolicyService;

public class GIXXOpenPolicyServiceImpl implements GIXXOpenPolicyService {
	
	private GIXXOpenPolicyDAO gixxOpenPolicyDAO;
	

	public GIXXOpenPolicyDAO getGixxOpenPolicyDAO() {
		return gixxOpenPolicyDAO;
	}

	public void setGixxOpenPolicyDAO(GIXXOpenPolicyDAO gixxOpenPolicyDAO) {
		this.gixxOpenPolicyDAO = gixxOpenPolicyDAO;
	}


	@Override
	public GIXXOpenPolicy getGIXXOpenPolicy(Map<String, Object> params) throws SQLException {
		return this.getGixxOpenPolicyDAO().getGIXXOpenPolicy(params);
	}

}
