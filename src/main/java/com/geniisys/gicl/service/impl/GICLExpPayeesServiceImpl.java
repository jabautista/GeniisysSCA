package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.dao.GICLExpPayeesDAO;
import com.geniisys.gicl.service.GICLExpPayeesService;

public class GICLExpPayeesServiceImpl implements GICLExpPayeesService{

	private GICLExpPayeesDAO giclExpPayeesDAO;

	public GICLExpPayeesDAO getGiclExpPayeesDAO() {
		return giclExpPayeesDAO;
	}

	public void setGiclExpPayeesDAO(GICLExpPayeesDAO giclExpPayeesDAO) {
		this.giclExpPayeesDAO = giclExpPayeesDAO;
	}

	@Override
	public String checkGiclExpPayeesExist(Map<String, Object> params)
			throws SQLException {
		return this.getGiclExpPayeesDAO().checkGiclExpPayeesExist(params);
	}
	
	
}
