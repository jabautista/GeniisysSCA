package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giac.dao.GIACReinstatedOrDAO;
import com.geniisys.giac.service.GIACReinstatedOrService;

public class GIACReinstatedOrServiceImpl implements GIACReinstatedOrService{

	/** The GIAC Prem Deposit DAO */
	private GIACReinstatedOrDAO giacReinstatedOrDAO;
	
	@Override
	public String reinstateOr(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		giacReinstatedOrDAO.reinstateOr(params);
		return params.get("message") != null ? params.get("message").toString() : "";
	}

	/**
	 * @return the giacReinstatedOrDAO
	 */
	public GIACReinstatedOrDAO getGiacReinstatedOrDAO() {
		return giacReinstatedOrDAO;
	}

	/**
	 * @param giacReinstatedOrDAO the giacReinstatedOrDAO to set
	 */
	public void setGiacReinstatedOrDAO(GIACReinstatedOrDAO giacReinstatedOrDAO) {
		this.giacReinstatedOrDAO = giacReinstatedOrDAO;
	}

}