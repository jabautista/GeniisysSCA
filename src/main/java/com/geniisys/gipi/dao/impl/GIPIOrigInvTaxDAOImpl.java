package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIOrigInvTaxDAO;
import com.geniisys.gipi.entity.GIPIOrigInvTax;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIOrigInvTaxDAOImpl implements GIPIOrigInvTaxDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIOrigInvTaxDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIOrigInvTax> getGipiInvTax(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting gipi_inv_tax records...");
		List<GIPIOrigInvTax> origInvTax = this.getSqlMapClient().queryForList("getOrigInvTax", params);
		return origInvTax;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> getLeadPolicyInvTax(HashMap<String, Object> params) throws SQLException {
		
		return this.sqlMapClient.queryForList("getLeadPolicyInvTaxes", params);
	}

}
