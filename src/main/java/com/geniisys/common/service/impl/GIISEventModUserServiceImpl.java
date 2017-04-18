package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.common.dao.GIISEventModUserDAO;
import com.geniisys.common.service.GIISEventModUserService;

public class GIISEventModUserServiceImpl implements GIISEventModUserService {

	private GIISEventModUserDAO giisEventModUserDAO;
	
	@Override
	public String validatePassingUser(Map<String, Object> params)
			throws SQLException {
		return this.giisEventModUserDAO.validatePassingUser(params);
	}

	public void setGiisEventModUserDAO(GIISEventModUserDAO giisEventModUserDAO) {
		this.giisEventModUserDAO = giisEventModUserDAO;
	}

	public GIISEventModUserDAO getGiisEventModUserDAO() {
		return giisEventModUserDAO;
	}

}
