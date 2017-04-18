package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.Date;
import java.util.Map;

import com.geniisys.gicl.dao.GICLTakeUpHistDAO;
import com.geniisys.gicl.service.GICLTakeUpHistService;

public class GICLTakeUpHistServiceImpl implements GICLTakeUpHistService{
	
	private GICLTakeUpHistDAO giclTakeUpHistDAO;

	public GICLTakeUpHistDAO getGiclTakeUpHistDAO() {
		return giclTakeUpHistDAO;
	}

	public void setGiclTakeUpHistDAO(GICLTakeUpHistDAO giclTakeUpHistDAO) {
		this.giclTakeUpHistDAO = giclTakeUpHistDAO;
	}

	@Override
	public Date getMaxAcctDate() throws SQLException {
		return this.getGiclTakeUpHistDAO().getMaxAcctDate();
	}
	
	@Override
	public Map<String, Object> validateTranDate(Map<String, Object> params)
			throws SQLException {
		return this.getGiclTakeUpHistDAO().validateTranDate(params);
	}

	@Override
	public Map<String, Object> bookOsGICLB001(Map<String, Object> params)
			throws SQLException {
		return this.getGiclTakeUpHistDAO().bookOsGICLB001(params);
	}
	
	

}
