package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIWItmperlBeneficiaryDAO;
import com.geniisys.gipi.entity.GIPIWItmperlBeneficiary;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWItmperlBeneficiaryDAOImpl implements GIPIWItmperlBeneficiaryDAO{
	
	private SqlMapClient sqlMapClient;

	/**
	 * 
	 * @return
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * 
	 * @param sqlMapClient
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItmperlBeneficiaryDAO#getGipiWItmperlBeneficiary(java.lang.Integer, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItmperlBeneficiary> getGipiWItmperlBeneficiary(
			Integer parId, Integer itemNo) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo.toString());
		return this.getSqlMapClient().queryForList("getGIPIWItmperlBeneficiary", params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItmperlBeneficiaryDAO#getGipiWItmperlBeneficiary2(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItmperlBeneficiary> getGipiWItmperlBeneficiary2(
			Integer parId) throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIWItmperlBeneficiary2", parId);
	}
}
