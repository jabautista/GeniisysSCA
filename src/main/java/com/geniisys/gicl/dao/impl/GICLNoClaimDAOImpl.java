package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLNoClaimDAO;
import com.geniisys.gicl.entity.GICLNoClaim;
import com.geniisys.giex.dao.impl.GIEXExpiriesVDAOImpl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLNoClaimDAOImpl implements GICLNoClaimDAO{
	
	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIEXExpiriesVDAOImpl.class);

	
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public GICLNoClaim getNoClaimCertDtls(Integer noClaimId)
			throws SQLException {
		log.info("Getting No Claim Certificate Details");
		return (GICLNoClaim) this.getSqlMapClient().queryForObject("getNoClaimCertDtls", noClaimId);
	}

	@Override
	public Map<String, Object> getDetailsGICLS026(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getDetailsGICLS026", params);
		return params;
	}

	@Override
	public Map<String, Object> getSignatoryGICLS026(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getSignatoryGICLS026", params);
		return params;
	}

	@Override
	public Map<String, Object> insertNewRecordGICLS026(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("insertNewRecordGICLS026",params);
		return params;
	}

	@Override
	public Map<String, Object> updateRecordGICLS026(Map<String, Object> params)
			throws SQLException {
		log.info("Updating GICL_NO_CLAIM : "+params.toString());
		this.getSqlMapClient().update("updateRecordGICLS026",params);
		return params;
	}
	
}
