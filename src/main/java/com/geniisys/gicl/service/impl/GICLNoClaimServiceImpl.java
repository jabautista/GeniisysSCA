package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.dao.GICLNoClaimDAO;
import com.geniisys.gicl.entity.GICLNoClaim;
import com.geniisys.gicl.service.GICLNoClaimService;

public class GICLNoClaimServiceImpl implements GICLNoClaimService{
	
	private GICLNoClaimDAO giclNoClaimDAO;

	public void setGiclNoClaimDAO(GICLNoClaimDAO giclNoClaimDAO) {
		this.giclNoClaimDAO = giclNoClaimDAO;
	}

	public GICLNoClaimDAO getGiclNoClaimDAO() {
		return giclNoClaimDAO;
	}

	@Override
	public GICLNoClaim getNoClaimCertDtls(Integer noClaimId)
			throws SQLException {
		return this.getGiclNoClaimDAO().getNoClaimCertDtls(noClaimId);
	}

	@Override
	public Map<String, Object> getDetailsGICLS026(Map<String, Object> params)
			throws SQLException {
		return this.getGiclNoClaimDAO().getDetailsGICLS026(params);
	}

	@Override
	public Map<String, Object> getSignatoryGICLS026(Map<String, Object> params)
			throws SQLException {
		return this.getGiclNoClaimDAO().getSignatoryGICLS026(params);
	}

	@Override
	public Map<String, Object> insertNewRecordGICLS026(
			Map<String, Object> params) throws SQLException {
		return this.getGiclNoClaimDAO().insertNewRecordGICLS026(params);
	}

	@Override
	public Map<String, Object> updateRecordGICLS026(Map<String, Object> params)
			throws SQLException {
		return this.getGiclNoClaimDAO().updateRecordGICLS026(params);
	}

}
