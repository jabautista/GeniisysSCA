package com.geniisys.giex.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giex.dao.GIEXPackExpiryDAO;
import com.geniisys.giex.service.GIEXPackExpiryService;

public class GIEXPackExpiryServiceImpl implements GIEXPackExpiryService{

	private GIEXPackExpiryDAO giexPackExpiryDAO;

	public void setGiexPackExpiryDAO(GIEXPackExpiryDAO giexPackExpiryDAO) {
		this.giexPackExpiryDAO = giexPackExpiryDAO;
	}

	public GIEXPackExpiryDAO getGiexPackExpiryDAO() {
		return giexPackExpiryDAO;
	}

	@Override
	public String checkPackPolicyIdGiexs006(Integer packPolicyId)
			throws SQLException {
		return this.giexPackExpiryDAO.checkPackPolicyIdGiexs006(packPolicyId);
	}

	@Override
	public List<Integer> getPackPolicyId(Map<String, Object> params)
			throws SQLException {
		return this.giexPackExpiryDAO.getPackPolicyId(params);
	}

	@Override
	public String checkPackRecordUser(Map<String, Object> params)
			throws SQLException {
		return this.giexPackExpiryDAO.checkPackRecordUser(params);
	}
	
}
