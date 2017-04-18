package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.dao.GICLLossExpPayeesDAO;
import com.geniisys.gicl.service.GICLLossExpPayeesService;

public class GICLLossExpPayeesServiceImpl implements GICLLossExpPayeesService{
	
	private GICLLossExpPayeesDAO giclLossExpPayeesDAO;
	
	public void setGiclLossExpPayeesDAO(GICLLossExpPayeesDAO giclLossExpPayeesDAO) {
		this.giclLossExpPayeesDAO = giclLossExpPayeesDAO;
	}

	public GICLLossExpPayeesDAO getGiclLossExpPayeesDAO() {
		return giclLossExpPayeesDAO;
	}

	@Override
	public Integer getPayeeClmClmntNo(Map<String, Object> params)
			throws SQLException {
		return this.getGiclLossExpPayeesDAO().getPayeeClmClmntNo(params);
	}

	@Override
	public String validateAssdClassCd(Map<String, Object> params)
			throws SQLException {
		return this.getGiclLossExpPayeesDAO().validateAssdClassCd(params);
	}

}
