package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIInvoiceDAO;
import com.geniisys.gipi.entity.GIPIInvoice;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIInvoiceDAOImpl implements GIPIInvoiceDAO{
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> getPolicyInvoice(HashMap<String,Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getPolInvoice",params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIInvoiceDAO#getMultiBookingDateByPolicy(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public String getMultiBookingDateByPolicy(Integer policyId, Integer distNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", policyId);
		params.put("distNo", distNo);
		return (String)this.getSqlMapClient().queryForObject("getMultiBookingDateByPolicy", params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIInvoice> populateBasicDetails(
			HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("populateBasicDetails", params);
	}
}
